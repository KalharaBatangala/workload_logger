import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/repositories/entries_repository.dart';
import 'package:workload_logger/data/repositories/periods_repository.dart';
import 'package:workload_logger/data/repositories/role_rows_repository.dart';
import 'package:workload_logger/domain/enums.dart';

import 'test_database.dart';

void main() {
  late AppDatabase db;
  late EntriesRepository entries;
  late int rowA;
  late int rowB;
  var minute = 0;

  setUp(() async {
    db = openTestDatabase();
    // Each entry gets a later createdAt so "latest" is well defined.
    minute = 0;
    entries = EntriesRepository(
      db,
      PeriodsRepository(db),
      now: () => testNow.add(Duration(minutes: minute++)),
    );
    final rows = RoleRowsRepository(db);
    Future<int> row(String code) => rows.upsert(
      RoleRowsCompanion.insert(
        moduleCode: code,
        batch: '25th',
        moduleName: code,
        moduleType: ModuleType.taught,
        role: Role.teacher,
      ),
    );
    rowA = await row('EC3202');
    rowB = await row('EC5208');
  });
  tearDown(() => db.close());

  Future<void> mark(
    int row,
    Subtype subtype,
    double qpp, {
    EntrySource source = EntrySource.manual,
  }) => entries.add(
    roleRowId: row,
    date: testToday,
    activity: Activity.examMarking,
    subtype: subtype,
    count: 40,
    questionsPerPaper: qpp,
    source: source,
  );

  test('last subtype and Qs/paper per role row and activity', () async {
    await mark(rowA, Subtype.essay, 2);
    await mark(rowA, Subtype.structured, 3);
    await mark(rowB, Subtype.mcq, 40);

    expect(
      await entries.lastSubtype(rowA, Activity.examMarking),
      Subtype.structured,
    );
    expect(await entries.lastSubtype(rowA, Activity.caMarking), isNull);
    expect(
      await entries.lastQuestionsPerPaper(
        rowA,
        Activity.examMarking,
        Subtype.essay,
      ),
      2,
    );
    expect(
      await entries.lastQuestionsPerPaper(
        rowB,
        Activity.examMarking,
        Subtype.essay,
      ),
      isNull,
    );
  });

  test('opening balances and deleted entries are not remembered', () async {
    await mark(rowA, Subtype.essay, 1, source: EntrySource.import);
    expect(await entries.lastSubtype(rowA, Activity.examMarking), isNull);

    final id = await entries.add(
      roleRowId: rowA,
      date: testToday,
      activity: Activity.caPrep,
      subtype: Subtype.quiz,
      count: 10,
    );
    await entries.softDelete(id);
    expect(await entries.lastSubtype(rowA, Activity.caPrep), isNull);
    expect(await entries.recentRoleRowIds(), isEmpty);
  });

  test('recent role rows, newest first, no repeats', () async {
    await mark(rowA, Subtype.essay, 1);
    await mark(rowB, Subtype.essay, 1);
    await mark(rowB, Subtype.essay, 1);
    expect(await entries.recentRoleRowIds(), [rowB, rowA]);
    expect(await entries.recentRoleRowIds(limit: 1), [rowB]);
    expect((await entries.lastEntryFor([rowA, rowB]))!.roleRowId, rowB);
    expect(await entries.lastEntryFor([999]), isNull);
  });
}
