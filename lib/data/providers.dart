import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/dates.dart';
import '../domain/rates.dart';
import '../domain/role_row.dart';
import '../domain/summary.dart';
import 'db/app_database.dart';
import 'demo_seed.dart';
import 'repositories/day_reviews_repository.dart';
import 'repositories/entries_repository.dart';
import 'repositories/other_work_repository.dart';
import 'repositories/periods_repository.dart';
import 'repositories/pg_supervision_repository.dart';
import 'repositories/photos_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/rates_repository.dart';
import 'repositories/reminder_settings_repository.dart';
import 'repositories/role_rows_repository.dart';
import 'repositories/timetable_repository.dart';
import 'workbook/import_service.dart';

// ---------------------------------------------------------------------------
// Infrastructure (overridden in tests)

/// The app database. Tests override this with an in-memory database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

/// The current time. Tests override this to fix "today".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Today's date as `yyyy-MM-dd`.
final todayProvider = Provider<String>(
  (ref) => isoDate(ref.watch(clockProvider)()),
);

// ---------------------------------------------------------------------------
// Repositories

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.watch(databaseProvider)),
);
final ratesRepositoryProvider = Provider(
  (ref) => RatesRepository(ref.watch(databaseProvider)),
);
final roleRowsRepositoryProvider = Provider(
  (ref) => RoleRowsRepository(ref.watch(databaseProvider)),
);
final periodsRepositoryProvider = Provider(
  (ref) => PeriodsRepository(
    ref.watch(databaseProvider),
    now: ref.watch(clockProvider),
  ),
);
final entriesRepositoryProvider = Provider(
  (ref) => EntriesRepository(
    ref.watch(databaseProvider),
    ref.watch(periodsRepositoryProvider),
    now: ref.watch(clockProvider),
  ),
);
final photosRepositoryProvider = Provider(
  (ref) => PhotosRepository(
    ref.watch(databaseProvider),
    now: ref.watch(clockProvider),
  ),
);
final otherWorkRepositoryProvider = Provider(
  (ref) => OtherWorkRepository(
    ref.watch(databaseProvider),
    now: ref.watch(clockProvider),
  ),
);
final timetableRepositoryProvider = Provider(
  (ref) => TimetableRepository(ref.watch(databaseProvider)),
);
final reminderSettingsRepositoryProvider = Provider(
  (ref) => ReminderSettingsRepository(ref.watch(databaseProvider)),
);
final dayReviewsRepositoryProvider = Provider(
  (ref) => DayReviewsRepository(ref.watch(databaseProvider)),
);
final pgSupervisionRepositoryProvider = Provider(
  (ref) => PgSupervisionRepository(ref.watch(databaseProvider)),
);
final demoSeederProvider = Provider(
  (ref) =>
      DemoSeeder(ref.watch(databaseProvider), now: ref.watch(clockProvider)),
);

final importServiceProvider = Provider(
  (ref) =>
      ImportService(ref.watch(databaseProvider), now: ref.watch(clockProvider)),
);

// ---------------------------------------------------------------------------
// Live data

final profileProvider = StreamProvider<ProfileRow?>(
  (ref) => ref.watch(profileRepositoryProvider).watch(),
);

final rateSetProvider = StreamProvider<RateSet>(
  (ref) => ref.watch(ratesRepositoryProvider).watchRateSet(),
);

/// Active role rows in workbook order.
final roleRowsProvider = StreamProvider<List<RoleRow>>(
  (ref) => ref.watch(roleRowsRepositoryProvider).watchActive(),
);

/// Non-deleted entries (complete and drafts) on a given date.
final entriesForDateProvider = StreamProvider.family<List<EntryRow>, String>(
  (ref, date) => ref.watch(entriesRepositoryProvider).watchForDate(date),
);

/// Non-deleted entries logged for today.
final todayEntriesProvider = StreamProvider<List<EntryRow>>(
  (ref) => ref
      .watch(entriesRepositoryProvider)
      .watchForDate(ref.watch(todayProvider)),
);

final draftsProvider = StreamProvider<List<EntryRow>>(
  (ref) => ref.watch(entriesRepositoryProvider).watchDrafts(),
);

/// First day of the current academic year (null = since the beginning):
/// everything after the last closed period.
final currentYearStartProvider = StreamProvider<String?>(
  (ref) => ref.watch(periodsRepositoryProvider).watchCurrentYearStart(),
);

/// Non-deleted entries of the current academic year.
final yearEntriesProvider = StreamProvider<List<EntryRow>>((ref) async* {
  final from = await ref.watch(currentYearStartProvider.future);
  yield* ref.watch(entriesRepositoryProvider).watchRange(from: from);
});

/// Credited hours for the hero cards and the Saved screen.
class Totals {
  const Totals({required this.today, required this.week, required this.year});

  /// Entries dated today. Opening balances and automatic hours excluded.
  final double today;

  /// Entries dated Monday–Sunday of this week. Same exclusions as [today].
  final double week;

  /// The academic year, exactly as the exported workbook rows compute it
  /// (includes opening balances and automatic Coordinator/Moderator hours).
  final PeriodSummary year;
}

final totalsProvider = FutureProvider<Totals>((ref) async {
  final rates = await ref.watch(rateSetProvider.future);
  final rows = await ref.watch(roleRowsProvider.future);
  final entries = await ref.watch(yearEntriesProvider.future);
  final today = ref.watch(todayProvider);
  final monday = weekStart(today);
  final sunday = addDays(monday, 6);

  // Opening balances are copied from the workbook, not work done that day.
  final logged = entries.where((e) => !e.isOpeningBalance);
  double creditedBetween(String from, String to) => creditedHours(
    logged
        .where((e) => e.date.compareTo(from) >= 0 && e.date.compareTo(to) <= 0)
        .map((e) => e.toInput()),
    rates,
  );

  final entriesByRow = <int, List<EntryInput>>{};
  for (final entry in entries) {
    final rowId = entry.roleRowId;
    if (rowId == null) continue;
    (entriesByRow[rowId] ??= []).add(entry.toInput());
  }

  return Totals(
    today: creditedBetween(today, today),
    week: creditedBetween(monday, sunday),
    year: summarize(
      {for (final row in rows) row.id: row.toInfo()},
      entriesByRow,
      rates,
    ),
  );
});
