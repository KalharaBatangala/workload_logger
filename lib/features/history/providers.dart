import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import 'history_items.dart';

/// Every non-deleted entry, newest first.
final historyEntriesProvider = StreamProvider.autoDispose<List<EntryRow>>(
  (ref) => ref.watch(entriesRepositoryProvider).watchRange(),
);

final historyOtherWorkProvider = StreamProvider.autoDispose<List<OtherWorkRow>>(
  (ref) => ref.watch(otherWorkRepositoryProvider).watchRange(),
);

final otherCategoryNamesProvider = StreamProvider.autoDispose<Map<int, String>>(
  (ref) => ref
      .watch(otherWorkRepositoryProvider)
      .watchCategories()
      .map((all) => {for (final c in all) c.id: c.name}),
);

final historyDaysProvider = Provider.autoDispose<List<DaySection>>(
  (ref) => groupByDay(
    ref.watch(historyEntriesProvider).value ?? const [],
    ref.watch(historyOtherWorkProvider).value ?? const [],
    today: ref.watch(todayProvider),
  ),
);

/// Marking batch cards for the current academic year.
final markingProgressProvider = Provider.autoDispose<List<MarkingProgress>>(
  (ref) => markingProgress(
    ref.watch(yearEntriesProvider).value ?? const [],
    ref.watch(allRoleRowsProvider).value ?? const {},
    ref.watch(currentRatesProvider),
  ),
);

/// Deleting and restoring from History (with snackbar Undo).
class HistoryActions {
  HistoryActions(this._ref);

  final Ref _ref;

  /// Soft delete; [undoDeleteEntry] brings it back. Also discards drafts.
  Future<void> deleteEntry(String id) =>
      _ref.read(entriesRepositoryProvider).softDelete(id);

  Future<void> undoDeleteEntry(String id) =>
      _ref.read(entriesRepositoryProvider).undoDelete(id);

  Future<void> deleteOtherWork(OtherWorkRow work) =>
      _ref.read(otherWorkRepositoryProvider).remove(work.id);

  Future<void> restoreOtherWork(OtherWorkRow work) =>
      _ref.read(otherWorkRepositoryProvider).restore(work);
}

final historyActionsProvider = Provider(HistoryActions.new);
