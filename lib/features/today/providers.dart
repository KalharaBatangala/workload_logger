import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/entries_repository.dart';
import '../../domain/activity_catalogue.dart';
import '../../domain/dates.dart';
import '../../domain/enums.dart';

/// Today's entries as the user logged them (opening balances left out),
/// newest first.
final todayLoggedEntriesProvider = Provider<AsyncValue<List<EntryRow>>>(
  (ref) => ref
      .watch(todayEntriesProvider)
      .whenData(
        (all) => [
          for (final e in all)
            if (!e.isOpeningBalance) e,
        ],
      ),
);

/// Active role rows by id, for module codes and names in lists.
final roleRowsByIdProvider = Provider<Map<int, RoleRow>>(
  (ref) => {
    for (final row in ref.watch(roleRowsProvider).value ?? const <RoleRow>[])
      row.id: row,
  },
);

/// A timetable slot to ask about on Today (SPEC §8.1).
class TimetableCard {
  const TimetableCard({required this.slot, required this.row});

  final TimetableSlot slot;
  final RoleRow row;

  bool get isLab => slot.kind == SlotKind.lab;

  /// Slot length in hours, rounded to the nearest half hour (lecture hours
  /// are logged in 0.5 steps, SPEC §12), at least 0.5.
  double get hours => slotLengthHours(slot.startTime, slot.endTime);
}

final _todaySlotsProvider = StreamProvider.autoDispose<List<TimetableSlot>>((
  ref,
) {
  final weekday = parseIsoDate(ref.watch(todayProvider)).weekday;
  return ref.watch(timetableRepositoryProvider).watchForWeekday(weekday);
});

final _todayAnswersProvider = StreamProvider.autoDispose<Map<int, SlotAnswer>>(
  (ref) => ref
      .watch(timetableRepositoryProvider)
      .watchAnswers(ref.watch(todayProvider)),
);

/// Today's slots still waiting for an answer. A lecture slot also counts as
/// answered once a lecture for that role row is logged today by hand.
final timetableCardsProvider = FutureProvider.autoDispose<List<TimetableCard>>((
  ref,
) async {
  final slots = await ref.watch(_todaySlotsProvider.future);
  final answers = await ref.watch(_todayAnswersProvider.future);
  final entries = await ref.watch(todayEntriesProvider.future);
  final rows = await ref.watch(roleRowsProvider.future);
  final byId = {for (final r in rows) r.id: r};

  return [
    for (final slot in slots)
      if (!answers.containsKey(slot.id) &&
          byId[slot.roleRowId] != null &&
          !(slot.kind == SlotKind.lecture &&
              entries.any(
                (e) =>
                    e.roleRowId == slot.roleRowId &&
                    e.activity == Activity.lecture,
              )))
        TimetableCard(slot: slot, row: byId[slot.roleRowId]!),
  ];
});

/// Up to three module codes, most recently logged first (Quick log chips).
final quickLogCodesProvider = Provider<List<String>>((ref) {
  final entries = ref.watch(yearEntriesProvider).value ?? const <EntryRow>[];
  final rows = ref.watch(roleRowsByIdProvider);
  final logged =
      entries.where((e) => !e.isOpeningBalance && e.roleRowId != null).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  final codes = <String>[];
  for (final entry in logged) {
    final code = rows[entry.roleRowId]?.moduleCode;
    if (code != null && !codes.contains(code)) codes.add(code);
    if (codes.length == 3) break;
  }
  return codes;
});

/// Role rows that still credit nothing this year and need logging: roles
/// whose hours are not automatic (SPEC §8.1 nudge).
final zeroRowsProvider = Provider<List<RoleRow>>((ref) {
  final totals = ref.watch(totalsProvider).value;
  final rows = ref.watch(roleRowsProvider).value;
  if (totals == null || rows == null) return const [];
  return [
    for (final row in rows)
      if (!isAutomaticRole(row.role) &&
          (totals.year.byRoleRow[row.id]?.total ?? 0) == 0)
        row,
  ];
});

/// What a "Yes" on a timetable card created, so it can be undone.
sealed class TimetableYes {
  const TimetableYes(this.date, this.slotId);

  final String date;
  final int slotId;
}

class LectureLogged extends TimetableYes {
  const LectureLogged(super.date, super.slotId, this.entryId);

  final String entryId;
}

class LabLogged extends TimetableYes {
  const LabLogged(super.date, super.slotId, this.otherWorkId);

  final String otherWorkId;
}

/// Category used for lab slots: labs conducted are other work until the
/// department says otherwise (SPEC §14 Q1, decided with the owner).
const labCategoryName = 'Lab sessions conducted';

/// The actions behind Today's timetable cards.
class TodayActions {
  TodayActions(this._ref);

  final Ref _ref;

  /// Lecture → a credited lecture entry for the slot's length (source
  /// timetable); lab → other work, not credited.
  Future<TimetableYes> answerYes(TimetableCard card) async {
    final date = _ref.read(todayProvider);
    final TimetableYes result;
    if (card.isLab) {
      final otherWork = _ref.read(otherWorkRepositoryProvider);
      final categories = await otherWork.getCategories();
      final category =
          categories.where((c) => c.name == labCategoryName).firstOrNull?.id ??
          await otherWork.addCategory(labCategoryName);
      final id = await otherWork.add(
        date: date,
        categoryId: category,
        spentMinutes: (card.hours * 60).round(),
        note: '${card.row.moduleCode} lab, from your timetable',
      );
      result = LabLogged(date, card.slot.id, id);
    } else {
      final id = await _ref
          .read(entriesRepositoryProvider)
          .add(
            roleRowId: card.row.id,
            date: date,
            activity: Activity.lecture,
            count: card.hours,
            source: EntrySource.timetable,
          );
      result = LectureLogged(date, card.slot.id, id);
    }
    await _ref
        .read(timetableRepositoryProvider)
        .answer(date, card.slot.id, SlotAnswer.yes);
    return result;
  }

  Future<void> answerNo(TimetableCard card) => _ref
      .read(timetableRepositoryProvider)
      .answer(_ref.read(todayProvider), card.slot.id, SlotAnswer.no);

  /// The snackbar's Undo after "Yes".
  Future<void> undoYes(TimetableYes yes) async {
    switch (yes) {
      case LectureLogged(:final entryId):
        await _ref.read(entriesRepositoryProvider).softDelete(entryId);
      case LabLogged(:final otherWorkId):
        await _ref.read(otherWorkRepositoryProvider).remove(otherWorkId);
    }
    await _ref
        .read(timetableRepositoryProvider)
        .clearAnswer(yes.date, yes.slotId);
  }
}

final todayActionsProvider = Provider(TodayActions.new);
