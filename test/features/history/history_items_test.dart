import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/features/history/history_items.dart';

const today = '2026-10-29';

EntryRow entry(
  String id,
  String date, {
  int roleRowId = 1,
  Activity activity = Activity.examMarking,
  Subtype? subtype = Subtype.essay,
  double? count = 40,
  double? qpp = 1,
  EntryStatus status = EntryStatus.complete,
  EntrySource source = EntrySource.manual,
  int minute = 0,
}) => EntryRow(
  id: id,
  roleRowId: roleRowId,
  date: date,
  activity: activity,
  subtype: subtype,
  count: count,
  questionsPerPaper: qpp,
  status: status,
  source: source,
  createdAt: DateTime(2026, 10, 29, 9, minute),
  updatedAt: DateTime(2026, 10, 29, 9, minute),
  isDemo: false,
);

RoleRow row({int id = 1, int students = 0}) => RoleRow(
  id: id,
  moduleCode: 'EC3202',
  batch: '25th',
  moduleName: 'Data Structures and Algorithms',
  moduleType: ModuleType.taught,
  credits: 0,
  students: students,
  role: Role.teacher,
  isActive: true,
  isDemo: false,
);

void main() {
  group('groupByDay', () {
    test('newest day first, headers, drafts left out', () {
      final days = groupByDay(
        [
          entry('a', '2026-10-26'),
          entry('b', today, minute: 1),
          entry('c', today, minute: 5),
          entry('d', today, status: EntryStatus.draft),
        ],
        [
          OtherWorkRow(
            id: 'o',
            date: '2026-10-28',
            categoryId: 1,
            spentMinutes: 120,
            createdAt: DateTime(2026, 10, 28),
            isDemo: false,
          ),
        ],
        today: today,
      );
      expect(days.map((d) => d.header), [
        'TODAY · THU 29 OCT',
        'YESTERDAY · WED 28 OCT',
        'MON 26 OCT',
      ]);
      expect(days.first.items.map((i) => (i as EntryItem).entry.id), [
        'c',
        'b',
      ]);
      expect(days[1].items.single, isA<OtherWorkItem>());
    });
  });

  group('markingProgress', () {
    final rates = RateSet.defaults();

    test('batches on top of the opening balance (SPEC §13 roll-up)', () {
      final progress = markingProgress(
        [
          entry('open', today, count: 193, source: EntrySource.import),
          entry('b1', today, count: 40, qpp: 1),
          entry('b2', today, count: 38, qpp: 2),
        ],
        {1: row()},
        rates,
      ).single;
      expect(progress.title, 'EC3202 end-exam marking');
      expect(progress.total, 271);
      expect(progress.batches, 3);
      expect(progress.hours, closeTo(19.3 + 4.0 + 7.6, 1e-9));
      expect(progress.target, isNull, reason: 'students = 0 in V10.1');
    });

    test('opening balance alone makes no card', () {
      expect(
        markingProgress(
          [entry('open', today, count: 193, source: EntrySource.import)],
          {1: row()},
          rates,
        ),
        isEmpty,
      );
    });

    test('target and students: separate card for project evaluation', () {
      final list = markingProgress(
        [
          entry('p', today, subtype: Subtype.project, count: 60, qpp: null),
          entry('e', today, count: 20, qpp: 2),
          entry('draft', today, count: null, status: EntryStatus.draft),
        ],
        {1: row(students: 200)},
        rates,
      );
      expect(list, hasLength(2));
      final students = list.firstWhere((p) => p.countsStudents);
      expect(students.title, 'EC3202 end-exam evaluation');
      expect(students.unit, 'students');
      expect(students.target, 200);
      expect(students.batches, 1);
    });
  });
}
