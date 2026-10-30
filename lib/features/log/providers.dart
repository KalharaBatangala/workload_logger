import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/periods_repository.dart';
import '../../data/repositories/role_rows_repository.dart';
import '../../domain/activity_catalogue.dart';
import '../../domain/credit_calculator.dart';
import '../../domain/entry_validation.dart';
import '../../domain/entry_warnings.dart';
import '../../domain/enums.dart';
import '../../domain/module_groups.dart';
import '../../domain/rates.dart';
import '../../domain/role_row.dart';

// ---------------------------------------------------------------------------
// Device services (overridden in tests)

/// Takes a photo or picks one from the gallery; returns its path or null.
final pickPhotoProvider =
    Provider<Future<String?> Function({required bool camera})>(
      (ref) => ({required bool camera}) async {
        final file = await ImagePicker().pickImage(
          source: camera ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 2000,
          imageQuality: 75,
        );
        return file?.path;
      },
    );

/// Copies a picked photo into the app's own folder and returns the new path,
/// so evidence survives the picker's temporary files being cleared.
final photoStoreProvider =
    Provider<Future<String> Function(String source, String entryId, int index)>(
      (ref) => (source, entryId, index) async {
        final docs = await getApplicationDocumentsDirectory();
        final dir = Directory('${docs.path}/photos');
        await dir.create(recursive: true);
        final dot = source.lastIndexOf('.');
        final ext = dot == -1 ? '.jpg' : source.substring(dot);
        final target = '${dir.path}/${entryId}_$index$ext';
        await File(source).copy(target);
        return target;
      },
    );

// ---------------------------------------------------------------------------
// Data for the steps

/// The owner's modules, one per code (Step 1).
final moduleGroupsProvider = Provider<AsyncValue<List<ModuleGroup>>>(
  (ref) => ref
      .watch(roleRowsProvider)
      .whenData(
        (rows) =>
            groupModules([for (final r in rows) (id: r.id, info: r.toInfo())]),
      ),
);

/// The module logged most recently, for the RECENT card.
final recentModuleCodeProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  final groups = await ref.watch(
    roleRowsProvider.selectAsync(
      (rows) =>
          groupModules([for (final r in rows) (id: r.id, info: r.toInfo())]),
    ),
  );
  final recent = await ref
      .watch(entriesRepositoryProvider)
      .recentRoleRowIds(limit: 1);
  if (recent.isEmpty) return null;
  for (final group in groups) {
    if (group.contains(recent.first)) return group.code;
  }
  return null;
});

/// The (role row, activity) last logged for a module: its tile gets the gold
/// "most likely" border on Step 2.
final likelyActivityProvider = FutureProvider.autoDispose
    .family<({int roleRowId, Activity activity})?, String>((ref, code) async {
      final groups = ref.watch(moduleGroupsProvider).value ?? const [];
      final group = groups.where((g) => g.code == code).firstOrNull;
      if (group == null) return null;
      final last = await ref.watch(entriesRepositoryProvider).lastEntryFor([
        for (final r in group.rows) r.id,
      ]);
      if (last == null) return null;
      return (roleRowId: last.roleRowId!, activity: last.activity);
    });

// ---------------------------------------------------------------------------
// Flow state

/// What was saved, for the Saved screen and Undo.
class SavedEntry {
  const SavedEntry({required this.id, required this.isDraft});

  final String id;
  final bool isDraft;
}

const _unset = Object();

class LogFlowState {
  const LogFlowState({
    required this.date,
    this.moduleCode,
    this.batch,
    this.roleRowId,
    this.roleRow,
    this.activity,
    this.subtypes = const [],
    this.subtype,
    this.count = 0,
    this.questionsPerPaper,
    this.spentMinutes,
    this.note = '',
    this.photoPaths = const [],
    this.saved,
    this.error,
    this.editingId,
    this.readOnly = false,
  });

  /// `yyyy-MM-dd`.
  final String date;
  final String? moduleCode;

  /// Chosen batch when the module ran for more than one.
  final String? batch;
  final int? roleRowId;
  final RoleRowInfo? roleRow;
  final Activity? activity;

  /// Types offered for [activity]; empty when it has none.
  final List<Subtype> subtypes;
  final Subtype? subtype;

  /// 0 until the user sets it (then the entry can be complete).
  final double count;
  final double? questionsPerPaper;
  final int? spentMinutes;
  final String note;

  /// Photos picked but not yet stored.
  final List<String> photoPaths;
  final SavedEntry? saved;

  /// A plain message when saving failed.
  final String? error;

  /// Id of the entry being edited; null when logging a new one.
  final String? editingId;

  bool get isEditing => editingId != null;

  /// True for an entry in a closed period: shown, but cannot be changed.
  final bool readOnly;

  CountKind? get countKind =>
      activity == null ? null : countKindFor(activity!, subtype);

  bool get needsQpp =>
      activity != null && needsQuestionsPerPaper(activity!, subtype);

  /// Whether Save will create a complete entry (otherwise a draft).
  bool get isComplete =>
      activity != null &&
      isCompleteEntry(
        activity: activity!,
        subtype: subtype,
        count: count > 0 ? count : null,
        questionsPerPaper: needsQpp ? questionsPerPaper : null,
      );

  /// The entry as the credit maths sees it.
  EntryInput? get entryInput => activity == null
      ? null
      : EntryInput(
          activity: activity!,
          subtype: subtype,
          count: count > 0 ? count : null,
          questionsPerPaper: needsQpp ? questionsPerPaper : null,
          isComplete: isComplete,
        );

  /// Credit if saved now: 0 while incomplete.
  double creditWith(RateSet rates) {
    final input = entryInput;
    return input == null ? 0 : entryCredit(input, rates);
  }

  LogFlowState copyWith({
    String? date,
    Object? moduleCode = _unset,
    Object? batch = _unset,
    Object? roleRowId = _unset,
    Object? roleRow = _unset,
    Object? activity = _unset,
    List<Subtype>? subtypes,
    Object? subtype = _unset,
    double? count,
    Object? questionsPerPaper = _unset,
    Object? spentMinutes = _unset,
    String? note,
    List<String>? photoPaths,
    Object? saved = _unset,
    Object? error = _unset,
    Object? editingId = _unset,
  }) => LogFlowState(
    date: date ?? this.date,
    moduleCode: moduleCode == _unset ? this.moduleCode : moduleCode as String?,
    batch: batch == _unset ? this.batch : batch as String?,
    roleRowId: roleRowId == _unset ? this.roleRowId : roleRowId as int?,
    roleRow: roleRow == _unset ? this.roleRow : roleRow as RoleRowInfo?,
    activity: activity == _unset ? this.activity : activity as Activity?,
    subtypes: subtypes ?? this.subtypes,
    subtype: subtype == _unset ? this.subtype : subtype as Subtype?,
    count: count ?? this.count,
    questionsPerPaper: questionsPerPaper == _unset
        ? this.questionsPerPaper
        : questionsPerPaper as double?,
    spentMinutes: spentMinutes == _unset
        ? this.spentMinutes
        : spentMinutes as int?,
    note: note ?? this.note,
    photoPaths: photoPaths ?? this.photoPaths,
    saved: saved == _unset ? this.saved : saved as SavedEntry?,
    error: error == _unset ? this.error : error as String?,
    editingId: editingId == _unset ? this.editingId : editingId as String?,
    readOnly: readOnly,
  );
}

/// Drives the logging flow (SPEC §8.2–8.5). Disposed when the flow closes,
/// so each visit starts fresh.
class LogFlowController extends Notifier<LogFlowState> {
  @override
  LogFlowState build() => LogFlowState(date: ref.read(todayProvider));

  /// Starts over (Log another), keeping the chosen date.
  void restart() => state = LogFlowState(date: state.date);

  void setDate(String date) => state = state.copyWith(date: date, error: null);

  /// Step 1. A module that ran for a single batch has it chosen already.
  void chooseModule(ModuleGroup group) => state = LogFlowState(
    date: state.date,
    moduleCode: group.code,
    batch: group.batches.length == 1 ? group.batches.single : null,
  );

  void chooseBatch(String batch) => state = state.copyWith(batch: batch);

  /// Step 2: picks the activity and pre-fills remembered defaults.
  Future<void> chooseActivity({
    required int roleRowId,
    required RoleRowInfo roleRow,
    required ActivityOption option,
  }) async {
    final entries = ref.read(entriesRepositoryProvider);
    Subtype? subtype;
    if (option.subtypes.isNotEmpty) {
      final last = await entries.lastSubtype(roleRowId, option.activity);
      subtype = option.subtypes.contains(last) ? last : option.subtypes.first;
    }
    state = state.copyWith(
      roleRowId: roleRowId,
      roleRow: roleRow,
      activity: option.activity,
      subtypes: option.subtypes,
      subtype: subtype,
      count: 0,
      questionsPerPaper: await _rememberedQpp(
        roleRowId,
        option.activity,
        subtype,
      ),
      spentMinutes: null,
      note: '',
      photoPaths: const [],
      saved: null,
      error: null,
    );
  }

  Future<double?> _rememberedQpp(
    int roleRowId,
    Activity activity,
    Subtype? subtype,
  ) async {
    if (subtype == null || !needsQuestionsPerPaper(activity, subtype)) {
      return null;
    }
    return ref
        .read(entriesRepositoryProvider)
        .lastQuestionsPerPaper(roleRowId, activity, subtype);
  }

  Future<void> setSubtype(Subtype subtype) async {
    state = state.copyWith(subtype: subtype);
    final rowId = state.roleRowId;
    final activity = state.activity;
    if (rowId == null || activity == null) return;
    final remembered = await _rememberedQpp(rowId, activity, subtype);
    if (state.subtype != subtype) return; // changed again meanwhile
    state = state.copyWith(
      questionsPerPaper: needsQuestionsPerPaper(activity, subtype)
          ? (remembered ?? state.questionsPerPaper)
          : null,
    );
  }

  void setCount(double count) =>
      state = state.copyWith(count: count < 0 ? 0 : count);

  void setQuestionsPerPaper(double? qpp) =>
      state = state.copyWith(questionsPerPaper: qpp);

  void setSpentMinutes(int? minutes) =>
      state = state.copyWith(spentMinutes: minutes);

  void setNote(String note) => state = state.copyWith(note: note);

  Future<void> addPhoto({required bool camera}) async {
    final path = await ref.read(pickPhotoProvider)(camera: camera);
    if (path != null) {
      state = state.copyWith(photoPaths: [...state.photoPaths, path]);
    }
  }

  void removePhoto(int index) => state = state.copyWith(
    photoPaths: [...state.photoPaths]..removeAt(index),
  );

  /// Step 3: saves a complete entry, or a draft if something is missing.
  /// Returns false (with [LogFlowState.error] set) if it could not be saved.
  Future<bool> save() async {
    final s = state;
    final activity = s.activity;
    if (activity == null) return false;
    final complete = s.isComplete;
    final note = s.note.trim();
    final count = s.count > 0 ? s.count : null;
    final qpp = s.needsQpp ? s.questionsPerPaper : null;
    final status = complete ? EntryStatus.complete : EntryStatus.draft;
    final entries = ref.read(entriesRepositoryProvider);
    try {
      final String id;
      final editingId = s.editingId;
      if (editingId != null) {
        final existing = await entries.byId(editingId);
        if (existing == null) return false;
        await entries.save(
          existing.copyWith(
            date: s.date,
            subtype: Value(s.subtype),
            count: Value(count),
            questionsPerPaper: Value(qpp),
            spentMinutes: Value(s.spentMinutes),
            note: Value(note.isEmpty ? null : note),
            status: status,
          ),
        );
        id = editingId;
      } else {
        id = await entries.add(
          roleRowId: s.roleRowId,
          date: s.date,
          activity: activity,
          subtype: s.subtype,
          count: count,
          questionsPerPaper: qpp,
          spentMinutes: s.spentMinutes,
          note: note.isEmpty ? null : note,
          status: status,
        );
      }
      await _storePhotos(id, s.photoPaths);
      state = s.copyWith(
        saved: SavedEntry(id: id, isDraft: !complete),
        error: null,
      );
      return true;
    } on PeriodLockedException {
      state = s.copyWith(
        error:
            'This date is in a closed period, so nothing can be added to it. '
            'Pick another date.',
      );
      return false;
    }
  }

  /// Fills the flow from an existing entry so Step 3 can edit it.
  void loadEntry(EntryRow entry, RoleRow? row, {bool readOnly = false}) {
    final info = row?.toInfo();
    final option = info == null
        ? null
        : activitiesFor(info)
              .where((o) => o.activity == entry.activity)
              .firstOrNull;
    state = LogFlowState(
      date: entry.date,
      moduleCode: row?.moduleCode,
      batch: row?.batch,
      roleRowId: entry.roleRowId,
      roleRow: info,
      activity: entry.activity,
      subtypes: option?.subtypes ?? [if (entry.subtype != null) entry.subtype!],
      subtype: entry.subtype,
      count: entry.count ?? 0,
      questionsPerPaper: entry.questionsPerPaper,
      spentMinutes: entry.spentMinutes,
      note: entry.note ?? '',
      editingId: entry.id,
      readOnly: readOnly,
    );
  }

  /// Starts Step 3 for a lecture on [row] (Today's "Other hours").
  Future<void> startLecture(RoleRow row) async {
    final info = row.toInfo();
    state = LogFlowState(
      date: state.date,
      moduleCode: row.moduleCode,
      batch: row.batch,
    );
    await chooseActivity(
      roleRowId: row.id,
      roleRow: info,
      option: activitiesFor(info)
          .firstWhere((o) => o.activity == Activity.lecture),
    );
  }

  Future<void> _storePhotos(String entryId, List<String> paths) async {
    final store = ref.read(photoStoreProvider);
    final photos = ref.read(photosRepositoryProvider);
    for (final (i, path) in paths.indexed) {
      await photos.add(entryId, await store(path, entryId, i));
    }
  }

  /// Saved screen → Undo: removes the entry (soft delete) and keeps the
  /// values so Step 3 reopens as it was.
  Future<void> undo() async {
    final saved = state.saved;
    if (saved == null) return;
    await ref.read(entriesRepositoryProvider).softDelete(saved.id);
    state = state.copyWith(saved: null);
  }

  /// Edit mode: deletes the entry being edited (soft delete, so it can be
  /// undone). Returns its id, or null if nothing was deleted.
  Future<String?> deleteEditing() async {
    final id = state.editingId;
    if (id == null || state.readOnly) return null;
    await ref.read(entriesRepositoryProvider).softDelete(id);
    return id;
  }

  /// Moderator rows: one tap records that moderation was done. Its hours are
  /// credited automatically, so the entry itself credits nothing.
  Future<bool> logModeration({
    required int roleRowId,
    required RoleRowInfo roleRow,
  }) async {
    state = state.copyWith(
      roleRowId: roleRowId,
      roleRow: roleRow,
      activity: Activity.moderationDone,
      subtypes: const [],
      subtype: null,
      count: 0,
      questionsPerPaper: null,
    );
    return save();
  }

  /// The Other-work form (never credited).
  Future<void> saveOtherWork({
    required int categoryId,
    required int spentMinutes,
    String? note,
  }) => ref
      .read(otherWorkRepositoryProvider)
      .add(
        date: state.date,
        categoryId: categoryId,
        spentMinutes: spentMinutes,
        note: (note?.trim().isEmpty ?? true) ? null : note!.trim(),
      );
}

final logFlowProvider =
    NotifierProvider.autoDispose<LogFlowController, LogFlowState>(
      LogFlowController.new,
    );

/// Other-work categories, in their sort order.
final otherCategoriesProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(otherWorkRepositoryProvider).watchCategories(),
);

/// SPEC §12 warnings for what Step 3 would save (never blocking). Only
/// re-checked when one of the fields that matter changes.
final logWarningsProvider = FutureProvider.autoDispose<List<EntryWarning>>((
  ref,
) async {
  final (
    rowId,
    activity,
    subtype,
    date,
    count,
    editingId,
    students,
    readOnly,
  ) = ref.watch(
    logFlowProvider.select(
      (s) => (
        s.roleRowId,
        s.activity,
        s.subtype,
        s.date,
        s.count,
        s.editingId,
        s.roleRow?.students ?? 0,
        s.readOnly,
      ),
    ),
  );
  if (rowId == null || activity == null || count <= 0 || readOnly) {
    return const [];
  }
  final entries = await ref
      .read(entriesRepositoryProvider)
      .getForRoleRow(rowId);
  return entryWarnings(
    candidate: WarningEntry(
      id: editingId,
      roleRowId: rowId,
      activity: activity,
      subtype: subtype,
      date: date,
      count: count,
    ),
    existing: [
      for (final e in entries)
        WarningEntry(
          id: e.id,
          roleRowId: rowId,
          activity: e.activity,
          subtype: e.subtype,
          date: e.date,
          count: e.count ?? 0,
          createdAt: e.createdAt,
          isComplete: e.status == EntryStatus.complete,
        ),
    ],
    students: students,
    now: ref.read(clockProvider)(),
  );
});
