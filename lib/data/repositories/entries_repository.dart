import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums.dart';
import '../../domain/role_row.dart';
import '../db/app_database.dart';
import 'periods_repository.dart';

extension EntryRowDomain on EntryRow {
  /// The view of this entry that the credit maths uses.
  EntryInput toInput() => EntryInput(
    activity: activity,
    subtype: subtype,
    count: count,
    questionsPerPaper: questionsPerPaper,
    isComplete: status == EntryStatus.complete,
    isDeleted: deletedAt != null,
  );

  bool get isDraft => status == EntryStatus.draft;

  /// Opening balance copied from the workbook (not work done that day).
  bool get isOpeningBalance => source == EntrySource.import;
}

/// Logged work. Entries are soft-deleted so "Undo" works, and entries dated
/// inside a closed period cannot be changed.
class EntriesRepository {
  EntriesRepository(
    this._db,
    this._periods, {
    DateTime Function()? now,
    this._uuid = const Uuid(),
  }) : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final PeriodsRepository _periods;
  final DateTime Function() _now;
  final Uuid _uuid;

  $EntriesTable get _entries => _db.entries;

  /// Adds an entry and returns its id.
  Future<String> add({
    required int? roleRowId,
    required String date,
    required Activity activity,
    Subtype? subtype,
    double? count,
    double? questionsPerPaper,
    int? spentMinutes,
    String? note,
    EntryStatus status = EntryStatus.complete,
    EntrySource source = EntrySource.manual,
    String? rawText,
    bool isDemo = false,
  }) async {
    await _periods.ensureUnlocked(date);
    final id = _uuid.v4();
    final now = _now();
    await _db
        .into(_entries)
        .insert(
          EntriesCompanion.insert(
            id: id,
            roleRowId: Value(roleRowId),
            date: date,
            activity: activity,
            subtype: Value(subtype),
            count: Value(count),
            questionsPerPaper: Value(questionsPerPaper),
            spentMinutes: Value(spentMinutes),
            note: Value(note),
            status: status,
            source: source,
            rawText: Value(rawText),
            createdAt: now,
            updatedAt: now,
            isDemo: Value(isDemo),
          ),
        );
    return id;
  }

  Future<EntryRow?> byId(String id) =>
      (_db.select(_entries)..where((e) => e.id.equals(id))).getSingleOrNull();

  /// Saves an edited entry (all fields), stamping updatedAt.
  Future<void> save(EntryRow entry) async {
    final existing = await byId(entry.id);
    if (existing == null) {
      throw StateError('Entry ${entry.id} does not exist');
    }
    await _periods.ensureUnlocked(existing.date);
    await _periods.ensureUnlocked(entry.date);
    await _db.update(_entries).replace(entry.copyWith(updatedAt: _now()));
  }

  /// Marks a draft complete after the missing information was added.
  Future<void> finishDraft(EntryRow draft) =>
      save(draft.copyWith(status: EntryStatus.complete));

  Future<void> softDelete(String id) => _setDeleted(id, _now());

  Future<void> undoDelete(String id) => _setDeleted(id, null);

  Future<void> _setDeleted(String id, DateTime? deletedAt) async {
    final existing = await byId(id);
    if (existing == null) return;
    await _periods.ensureUnlocked(existing.date);
    await (_db.update(_entries)..where((e) => e.id.equals(id))).write(
      EntriesCompanion(deletedAt: Value(deletedAt), updatedAt: Value(_now())),
    );
  }

  /// Non-deleted entries on [date], newest first.
  Stream<List<EntryRow>> watchForDate(String date) =>
      _watch((e) => e.date.equals(date));

  /// Non-deleted entries from [from] (inclusive; null = all) up to [to]
  /// (inclusive; null = open), newest first.
  Stream<List<EntryRow>> watchRange({String? from, String? to}) => _watch(
    (e) => Expression.and([
      if (from != null) e.date.isBiggerOrEqualValue(from),
      if (to != null) e.date.isSmallerOrEqualValue(to),
    ]),
  );

  Stream<List<EntryRow>> watchDrafts() =>
      _watch((e) => e.status.equalsValue(EntryStatus.draft));

  Stream<List<EntryRow>> watchForRoleRow(int roleRowId) =>
      _watch((e) => e.roleRowId.equals(roleRowId));

  // Remembered defaults (SPEC §5): read from what was logged before.

  /// Sources that mean "the user logged this" (not imported balances).
  static const _loggedSources = [
    EntrySource.manual,
    EntrySource.timetable,
    EntrySource.notification,
    EntrySource.quickText,
  ];

  Future<EntryRow?> _latest(
    Expression<bool> Function($EntriesTable e) filter,
  ) =>
      (_db.select(_entries)
            ..where(
              (e) =>
                  e.deletedAt.isNull() &
                  e.source.isInValues(_loggedSources) &
                  filter(e),
            )
            ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  /// The type last used for (role row, activity), to pre-select it.
  Future<Subtype?> lastSubtype(int roleRowId, Activity activity) async =>
      (await _latest(
        (e) =>
            e.roleRowId.equals(roleRowId) &
            e.activity.equalsValue(activity) &
            e.subtype.isNotNull(),
      ))?.subtype;

  /// Questions per paper last used for (role row, activity, type).
  Future<double?> lastQuestionsPerPaper(
    int roleRowId,
    Activity activity,
    Subtype subtype,
  ) async => (await _latest(
    (e) =>
        e.roleRowId.equals(roleRowId) &
        e.activity.equalsValue(activity) &
        e.subtype.equalsValue(subtype) &
        e.questionsPerPaper.isNotNull(),
  ))?.questionsPerPaper;

  /// The most recent entry among [roleRowIds] (for the "most likely" tile).
  Future<EntryRow?> lastEntryFor(List<int> roleRowIds) =>
      _latest((e) => e.roleRowId.isIn(roleRowIds));

  /// Role rows logged most recently first, without repeats.
  Future<List<int>> recentRoleRowIds({int limit = 3}) async {
    final rows =
        await (_db.select(_entries)
              ..where(
                (e) =>
                    e.deletedAt.isNull() &
                    e.roleRowId.isNotNull() &
                    e.source.isInValues(_loggedSources),
              )
              ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
              ..limit(50))
            .get();
    final ids = <int>[];
    for (final row in rows) {
      if (!ids.contains(row.roleRowId)) ids.add(row.roleRowId!);
      if (ids.length == limit) break;
    }
    return ids;
  }

  Stream<List<EntryRow>> _watch(
    Expression<bool> Function($EntriesTable e) filter,
  ) =>
      (_db.select(_entries)
            ..where((e) => e.deletedAt.isNull() & filter(e))
            ..orderBy([
              (e) => OrderingTerm.desc(e.date),
              (e) => OrderingTerm.desc(e.createdAt),
            ]))
          .watch();
}
