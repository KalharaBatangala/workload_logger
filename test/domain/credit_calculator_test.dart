import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/credit_calculator.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/domain/role_row.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

import 'fixtures.dart';

Matcher hours(double expected) => closeTo(expected, 1e-9);

void main() {
  final rates = RateSet.defaults();

  CategoryHours hoursOf(OwnerRow row) =>
      roleRowHours(row.info, row.inputs, rates);

  CategoryHours ownerTotal(List<OwnerRow> rows) =>
      CategoryHours.sum(rows.map(hoursOf));

  group('SPEC §13 role-row fixtures', () {
    test('EE3202 Teacher: AC=74, AD=1 → examMarking 7.4', () {
      final h = hoursOf(ee3202Teacher);
      expect(h[Category.examMarking], hours(7.4));
      expect(h.total, hours(7.4));
    });

    test('EC3202 Teacher: AC=193, AD=1 → examMarking 19.3', () {
      final h = hoursOf(ec3202Teacher);
      expect(h[Category.examMarking], hours(19.3));
      expect(h.total, hours(19.3));
    });

    test('EC5406 Teacher (Project): X=200, AE=50 → 40 + 10 = 50', () {
      final h = hoursOf(ec5406Teacher);
      expect(h[Category.caMarking], hours(40.0));
      expect(h[Category.examMarking], hours(10.0));
      expect(h.total, hours(50.0));
    });

    test('EC5207 Moderator → moderator 2.0 automatically', () {
      final h = hoursOf(ec5207Moderator);
      expect(h[Category.moderator], hours(2.0));
      expect(h.total, hours(2.0));
    });

    test('Second Examiner rows with AF=0 → 0', () {
      for (final row in [
        ec5207SecondExaminer,
        ec5204SecondExaminer25,
        ec5204SecondExaminer24,
      ]) {
        expect(hoursOf(row).total, hours(0), reason: '${row.info}');
      }
    });

    test('owner total 78.7 h, split as in Workload_Summary', () {
      final total = ownerTotal(ownerRows);
      expect(total[Category.caMarking], hours(40.0));
      expect(total[Category.examMarking], hours(36.7));
      expect(total[Category.moderator], hours(2.0));
      expect(total.total, hours(78.7));
      // Nothing else is credited.
      for (final category in Category.values.where(
        (c) => ![
          Category.caMarking,
          Category.examMarking,
          Category.moderator,
        ].contains(c),
      )) {
        expect(total[category], 0, reason: category.name);
      }
    });

    test('EC5208 caPrep/quiz 10 → owner total 79.7 h', () {
      final ec5208 = OwnerRow(
        ec5208Teacher.sheetRow,
        ec5208Teacher.info,
        const {InputColumn.j: 10},
      );
      final rows = [
        for (final row in ownerRows) row == ec5208Teacher ? ec5208 : row,
      ];
      expect(hoursOf(ec5208)[Category.caPrep], hours(1.0));
      expect(ownerTotal(rows).total, hours(79.7));
    });
  });

  group('SPEC §13 single-entry credits', () {
    double credit(
      Activity activity, {
      Subtype? subtype,
      required double count,
      int? qpp,
    }) => entryCredit(
      EntryInput(
        activity: activity,
        subtype: subtype,
        count: count,
        questionsPerPaper: qpp,
      ),
      rates,
    );

    test('caPrep', () {
      expect(
        credit(Activity.caPrep, subtype: Subtype.quiz, count: 10),
        hours(1.0),
      );
      expect(
        credit(Activity.caPrep, subtype: Subtype.structured, count: 3),
        hours(4.5),
      );
      expect(
        credit(Activity.caPrep, subtype: Subtype.essay, count: 2),
        hours(4.0),
      );
      expect(
        credit(Activity.caPrep, subtype: Subtype.project, count: 1),
        hours(5.0),
      );
    });

    test('examMarking/mcq 100 papers × 40 qpp → 8.0 h', () {
      expect(
        credit(Activity.examMarking, subtype: Subtype.mcq, count: 100, qpp: 40),
        hours(8.0),
      );
    });

    test('caMarking/structured 40 × 3 → 12.0 h; caMarking/quiz → 0', () {
      expect(
        credit(
          Activity.caMarking,
          subtype: Subtype.structured,
          count: 40,
          qpp: 3,
        ),
        hours(12.0),
      );
      expect(
        credit(Activity.caMarking, subtype: Subtype.quiz, count: 120, qpp: 20),
        0,
      );
    });

    test('secondMarking, lab, project supervision', () {
      expect(credit(Activity.secondMarking, count: 40), hours(4.0));
      expect(credit(Activity.labFirstTime, count: 1), hours(20.0));
      expect(credit(Activity.projectSupervision, count: 2), hours(60.0));
    });

    test('lecture credits its hours; IT evaluation 0.3 h per student', () {
      expect(credit(Activity.lecture, count: 2), hours(2.0));
      expect(credit(Activity.itEvaluation, count: 10), hours(3.0));
    });

    test('moderationDone and other are never credited', () {
      expect(credit(Activity.moderationDone, count: 1), 0);
      expect(credit(Activity.other, count: 120), 0);
    });

    test('drafts and deleted entries credit 0', () {
      const draft = EntryInput(
        activity: Activity.caPrep,
        subtype: Subtype.quiz,
        count: 10,
        isComplete: false,
      );
      const deleted = EntryInput(
        activity: Activity.caPrep,
        subtype: Subtype.quiz,
        count: 10,
        isDeleted: true,
      );
      expect(entryCredit(draft, rates), 0);
      expect(entryCredit(deleted, rates), 0);
    });

    test('invalid complete entries throw', () {
      expect(
        () => entryCredit(
          const EntryInput(activity: Activity.caPrep, subtype: Subtype.quiz),
          rates,
        ),
        throwsArgumentError,
      );
      expect(
        () => entryCredit(
          const EntryInput(
            activity: Activity.examMarking,
            subtype: Subtype.essay,
            count: 40,
          ),
          rates,
        ),
        throwsArgumentError,
      );
      expect(
        () => entryCredit(
          const EntryInput(
            activity: Activity.examPrep,
            subtype: Subtype.quiz, // quiz is CA only; exams use mcq
            count: 10,
          ),
          rates,
        ),
        throwsArgumentError,
      );
    });
  });

  group('coordination', () {
    RoleRowInfo coordinator(ModuleType type) => RoleRowInfo(
      moduleCode: 'EC9999',
      batch: '25th',
      moduleName: 'Test module',
      moduleType: type,
      role: Role.coordinator,
    );

    test('Project module → 25 h, Taught module → 10 h', () {
      final project = coordinator(ModuleType.project);
      final taught = coordinator(ModuleType.taught);
      expect(roleRowHours(project, WorkbookInputs(), rates).total, hours(25));
      expect(roleRowHours(taught, WorkbookInputs(), rates).total, hours(10));
      expect(automaticHours(project, rates), hours(25));
      expect(automaticHours(taught, rates), hours(10));
    });
  });

  group('workbook quirks', () {
    test('AF on a non-Second-Examiner row is not credited', () {
      final inputs = WorkbookInputs({InputColumn.af: 40});
      expect(roleRowHours(ec5208Teacher.info, inputs, rates).total, 0);
      expect(
        roleRowHours(
          ec5207SecondExaminer.info,
          inputs,
          rates,
        )[Category.secondMarking],
        hours(4.0),
      );
    });

    test('rates come from the RateSet, not constants', () {
      final custom = RateSet.from({RateKey.examMarkEssay: 0.2});
      expect(
        roleRowHours(ee3202Teacher.info, ee3202Teacher.inputs, custom).total,
        hours(14.8),
      );
    });
  });

  test('PG supervision: 50 h per student', () {
    expect(pgSupervisionHours(3, rates), hours(150));
  });

  test('every creditable activity has a category', () {
    for (final activity in Activity.values) {
      final category = categoryOf(activity);
      if (activity == Activity.moderationDone || activity == Activity.other) {
        expect(category, isNull);
      } else {
        expect(category, isNotNull, reason: activity.name);
      }
    }
  });
}
