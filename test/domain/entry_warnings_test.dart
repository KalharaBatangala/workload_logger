import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/entry_warnings.dart';
import 'package:workload_logger/domain/enums.dart';

final now = DateTime(2026, 10, 29, 21, 40);

WarningEntry marking(
  double count, {
  String? id,
  Duration? ago,
  String date = '2026-10-29',
  Subtype subtype = Subtype.essay,
  bool complete = true,
}) => WarningEntry(
  id: id,
  roleRowId: 1,
  activity: Activity.examMarking,
  subtype: subtype,
  date: date,
  count: count,
  createdAt: ago == null ? null : now.subtract(ago),
  isComplete: complete,
);

List<EntryWarning> check(
  WarningEntry candidate,
  List<WarningEntry> existing, {
  int students = 180,
}) => entryWarnings(
  candidate: candidate,
  existing: existing,
  students: students,
  now: now,
);

void main() {
  group('more papers than students', () {
    test('warns when the total would pass the module\'s students', () {
      final w =
          check(marking(60), [
                marking(100, ago: const Duration(days: 2)),
                marking(40, ago: const Duration(days: 1)),
              ]).single
              as MoreThanStudents;
      expect(w.total, 200);
      expect(w.students, 180);
      expect(w.kind.name, 'papers');
    });

    test('exactly the students is fine', () {
      expect(check(marking(80), [marking(100)]), isEmpty);
    });

    test('students = 0 means unknown: no check (SPEC §12)', () {
      expect(check(marking(500), [], students: 0), isEmpty);
    });

    test('other types and drafts do not add up', () {
      expect(
        check(marking(100), [
          marking(100, subtype: Subtype.structured),
          marking(100, complete: false),
        ]),
        isEmpty,
      );
    });

    test('counts of questions are not papers: no check', () {
      const prep = WarningEntry(
        roleRowId: 1,
        activity: Activity.caPrep,
        subtype: Subtype.quiz,
        date: '2026-10-29',
        count: 500,
      );
      expect(check(prep, []), isEmpty);
    });
  });

  group('likely duplicate', () {
    test('same everything within 10 minutes', () {
      final w =
          check(marking(40), [
                marking(40, ago: const Duration(minutes: 3)),
              ]).single
              as LikelyDuplicate;
      expect(w.ago, const Duration(minutes: 3));
    });

    test('not after 10 minutes, nor with another count or date', () {
      expect(
        check(marking(40), [
          marking(40, ago: const Duration(minutes: 11)),
          marking(41, ago: const Duration(minutes: 1)),
          marking(40, ago: const Duration(minutes: 1), date: '2026-10-28'),
        ]),
        isEmpty,
      );
    });

    test('an entry being edited is not its own duplicate', () {
      expect(
        check(marking(40, id: 'a'), [
          marking(40, id: 'a', ago: const Duration(minutes: 1)),
        ]),
        isEmpty,
      );
    });
  });
}
