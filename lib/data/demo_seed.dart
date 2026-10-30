import 'package:drift/drift.dart';

import '../domain/dates.dart';
import '../domain/enums.dart';
import '../domain/rates.dart';
import '../domain/roll_up.dart';
import '../domain/workbook_mapping.dart';
import 'db/app_database.dart';
import 'repositories/entries_repository.dart';
import 'repositories/other_work_repository.dart';
import 'repositories/periods_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/rates_repository.dart';
import 'repositories/role_rows_repository.dart';
import 'repositories/timetable_repository.dart';

/// One of the owner's Data_Entry rows in V10.1 (SPEC §3.3).
class _DemoRow {
  const _DemoRow(
    this.sheetRow,
    this.code,
    this.batch,
    this.name,
    this.type,
    this.credits,
    this.students,
    this.role, [
    this.inputs = const {},
  ]);

  final int sheetRow;
  final String code;
  final String batch;
  final String name;
  final ModuleType type;
  final double credits;
  final int students;
  final Role role;
  final Map<InputColumn, double> inputs;
}

const _dsa = 'Data Structures and Algorithms';
const _ood = 'Object Oriented Design Patterns and Principles';
const _devOps = 'DevOps Engineering';
const _mad = 'Mobile Application Development';
const _taught = ModuleType.taught;

const _demoRows = [
  _DemoRow(129, 'EE3202', '25th', _dsa, _taught, 0, 0, Role.teacher, {
    InputColumn.ac: 74,
    InputColumn.ad: 1,
  }),
  _DemoRow(165, 'EC3202', '25th', _dsa, _taught, 0, 0, Role.teacher, {
    InputColumn.ac: 193,
    InputColumn.ad: 1,
  }),
  _DemoRow(291, 'EC5204', '25th', _ood, _taught, 0, 0, Role.secondExaminer),
  _DemoRow(
    310,
    'EC5406',
    '25th',
    'Software Group Project',
    ModuleType.project,
    4,
    200,
    Role.teacher,
    {InputColumn.x: 200, InputColumn.ae: 50},
  ),
  _DemoRow(
    318,
    'EC5207',
    '25th',
    _devOps,
    _taught,
    2,
    180,
    Role.secondExaminer,
  ),
  _DemoRow(319, 'EC5207', '25th', _devOps, _taught, 2, 180, Role.moderator),
  _DemoRow(321, 'EC5208', '25th', _mad, _taught, 0, 0, Role.teacher),
  _DemoRow(400, 'EC5204', '24th', _ood, _taught, 0, 0, Role.secondExaminer),
];

/// Seeds and removes demo data (SPEC §8.9). Everything it creates is flagged
/// `isDemo` so Setup → "Remove demo data" can take it all away.
class DemoSeeder {
  DemoSeeder(this._db, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  /// Loads the owner's 8 role rows with their workbook opening balances
  /// (78.7 h) plus a few sample entries (+1.0 h today → 79.7 h).
  ///
  /// Throws [StateError] if a real (non-demo) profile exists.
  Future<void> seed() async {
    final existing = await ProfileRepository(_db).get();
    if (existing != null && !existing.isDemo) {
      throw StateError('Real data exists; demo data was not loaded.');
    }

    final today = isoDate(_now());
    final entries = EntriesRepository(
      _db,
      PeriodsRepository(_db, now: _now),
      now: _now,
    );
    final roleRows = RoleRowsRepository(_db);

    await _db.transaction(() async {
      await remove();

      await ProfileRepository(_db).save(
        ProfileCompanion.insert(
          staffName: 'Mr. Kalhara Batangala',
          displayName: 'Kalhara',
          academicYearLabel: '2025/26',
          workbookFileName: const Value(
            'Demo data (DEIE Workload Model V10.1)',
          ),
          importedAt: Value(_now()),
          isDemo: const Value(true),
        ),
      );
      await RatesRepository(_db).replaceAll(RateSet.defaults());

      final ids = <String, int>{};
      for (final row in _demoRows) {
        final id = await roleRows.upsert(
          RoleRowsCompanion.insert(
            moduleCode: row.code,
            batch: row.batch,
            moduleName: row.name,
            moduleType: row.type,
            credits: Value(row.credits),
            students: Value(row.students),
            role: row.role,
            sheetRow: Value(row.sheetRow),
            isDemo: const Value(true),
          ),
        );
        ids['${row.code} ${row.batch} ${row.role.name}'] = id;

        // Opening balances, exactly as an import would create them.
        for (final entry in inputsToEntries(WorkbookInputs(row.inputs))) {
          await entries.add(
            roleRowId: id,
            date: today,
            activity: entry.activity,
            subtype: entry.subtype,
            count: entry.count,
            questionsPerPaper: entry.questionsPerPaper,
            note: 'From workbook V10.1',
            source: EntrySource.import,
            isDemo: true,
          );
        }
      }

      // Sample entries matching the design screenshots.
      final ec5208 = ids['EC5208 25th teacher']!;
      await entries.add(
        roleRowId: ec5208,
        date: today,
        activity: Activity.caPrep,
        subtype: Subtype.quiz,
        count: 10,
        spentMinutes: 60,
        note: 'Quiz 2',
        isDemo: true,
      );
      await entries.add(
        roleRowId: ids['EC5406 25th teacher'],
        date: today,
        activity: Activity.caMarking,
        subtype: Subtype.project,
        status: EntryStatus.draft,
        source: EntrySource.quickText,
        rawText: 'panel evaluation, software group project',
        isDemo: true,
      );

      final otherWork = OtherWorkRepository(_db, now: _now);
      final research = (await otherWork.getCategories()).firstWhere(
        (c) => c.name == 'Research',
      );
      await otherWork.add(
        date: addDays(today, -1),
        categoryId: research.id,
        spentMinutes: 120,
        note: 'Paper reading',
        isDemo: true,
      );

      final timetable = TimetableRepository(_db);
      await timetable.add(
        roleRowId: ec5208,
        kind: SlotKind.lecture,
        weekday: DateTime.thursday,
        startTime: '10:00',
        endTime: '12:00',
        isDemo: true,
      );
      await timetable.add(
        roleRowId: ec5208,
        kind: SlotKind.lab,
        weekday: DateTime.tuesday,
        startTime: '13:00',
        endTime: '16:00',
        isDemo: true,
      );
    });
  }

  /// Removes all demo data, including anything logged against demo role
  /// rows. Leaves real data, categories and reminder settings untouched.
  Future<void> remove() => _db.transaction(() async {
    final demoRowIds =
        await (_db.selectOnly(_db.roleRows)
              ..addColumns([_db.roleRows.id])
              ..where(_db.roleRows.isDemo.equals(true)))
            .map((row) => row.read(_db.roleRows.id)!)
            .get();

    // Photos and timetable slots follow via ON DELETE CASCADE.
    await (_db.delete(
      _db.entries,
    )..where((e) => e.isDemo.equals(true) | e.roleRowId.isIn(demoRowIds))).go();
    await (_db.delete(_db.otherWork)..where((o) => o.isDemo.equals(true))).go();
    await (_db.delete(
      _db.timetableSlots,
    )..where((s) => s.isDemo.equals(true))).go();
    await (_db.delete(_db.roleRows)..where((r) => r.isDemo.equals(true))).go();

    final profile = await ProfileRepository(_db).get();
    if (profile != null && profile.isDemo) {
      await _db.delete(_db.profile).go();
      await _db.delete(_db.rates).go();
    }
  });

  /// Whether any demo data is present.
  Future<bool> hasDemoData() async {
    final row =
        await (_db.select(_db.roleRows)
              ..where((r) => r.isDemo.equals(true))
              ..limit(1))
            .getSingleOrNull();
    final profile = await ProfileRepository(_db).get();
    return row != null || (profile?.isDemo ?? false);
  }
}
