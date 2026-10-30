import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/credit_calculator.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/domain/role_row.dart';
import 'package:workload_logger/domain/roll_up.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

import 'fixtures.dart';

Matcher hours(double expected) => closeTo(expected, 1e-9);

EntryInput essayBatch(double papers, int qpp) => EntryInput(
  activity: Activity.examMarking,
  subtype: Subtype.essay,
  count: papers,
  questionsPerPaper: qpp,
);

void main() {
  final rates = RateSet.defaults();

  test('SPEC §13: 40×1 + 38×2 essay batches → AC 78, AD 116/78, 11.6 h', () {
    final inputs = rollUp([essayBatch(40, 1), essayBatch(38, 2)]);

    expect(inputs[InputColumn.ac], 78);
    // Full precision, never rounded.
    expect(inputs[InputColumn.ad], 116 / 78);
    expect(
      roleRowHours(ec5208Teacher.info, inputs, rates)[Category.examMarking],
      hours(11.6),
    );
  });

  test('counts of the same column are summed', () {
    final inputs = rollUp(const [
      EntryInput(activity: Activity.caPrep, subtype: Subtype.quiz, count: 10),
      EntryInput(activity: Activity.caPrep, subtype: Subtype.quiz, count: 5),
      EntryInput(activity: Activity.lecture, count: 2),
      EntryInput(activity: Activity.lecture, count: 1.5),
    ]);
    expect(inputs[InputColumn.j], 15);
    expect(inputs[InputColumn.i], 3.5);
    expect(
      inputs.nonZero.keys,
      unorderedEquals([InputColumn.j, InputColumn.i]),
    );
  });

  test('drafts, deleted, moderation and other work are excluded', () {
    final inputs = rollUp(const [
      EntryInput(
        activity: Activity.caPrep,
        subtype: Subtype.quiz,
        isComplete: false, // draft without count
      ),
      EntryInput(
        activity: Activity.caPrep,
        subtype: Subtype.quiz,
        count: 10,
        isDeleted: true,
      ),
      EntryInput(activity: Activity.moderationDone, count: 1),
      EntryInput(activity: Activity.other, count: 60),
    ]);
    expect(inputs.isEmpty, isTrue);
  });

  test('project marking counts students and has no Qs/paper column', () {
    final inputs = rollUp(const [
      EntryInput(
        activity: Activity.caMarking,
        subtype: Subtype.project,
        count: 120,
      ),
      EntryInput(
        activity: Activity.caMarking,
        subtype: Subtype.project,
        count: 80,
      ),
    ]);
    expect(inputs, WorkbookInputs({InputColumn.x: 200}));
  });

  test('opening balances as entries reproduce the workbook inputs', () {
    // EC5406: X=200, AE=50 (SPEC §7.2 step 4 converts these into entries).
    final inputs = rollUp(const [
      EntryInput(
        activity: Activity.caMarking,
        subtype: Subtype.project,
        count: 200,
      ),
      EntryInput(
        activity: Activity.examMarking,
        subtype: Subtype.project,
        count: 50,
      ),
    ]);
    expect(inputs, ec5406Teacher.inputs);

    final ec3202 = rollUp([essayBatch(193, 1)]);
    expect(ec3202, ec3202Teacher.inputs);
  });

  test('complete paper marking without Qs/paper throws', () {
    expect(
      () => rollUp(const [
        EntryInput(
          activity: Activity.caMarking,
          subtype: Subtype.structured,
          count: 40,
        ),
      ]),
      throwsArgumentError,
    );
  });

  test('Σ entry credits == role-row hours of the roll-up', () {
    const entries = [
      EntryInput(activity: Activity.lecture, count: 2),
      EntryInput(activity: Activity.caPrep, subtype: Subtype.quiz, count: 10),
      EntryInput(
        activity: Activity.caPrep,
        subtype: Subtype.structured,
        count: 3,
      ),
      EntryInput(activity: Activity.examPrep, subtype: Subtype.mcq, count: 40),
      EntryInput(activity: Activity.examPrep, subtype: Subtype.essay, count: 4),
      EntryInput(
        activity: Activity.caMarking,
        subtype: Subtype.structured,
        count: 40,
        questionsPerPaper: 3,
      ),
      EntryInput(
        activity: Activity.caMarking,
        subtype: Subtype.structured,
        count: 25,
        questionsPerPaper: 4,
      ),
      EntryInput(
        activity: Activity.examMarking,
        subtype: Subtype.mcq,
        count: 100,
        questionsPerPaper: 40,
      ),
      EntryInput(
        activity: Activity.examMarking,
        subtype: Subtype.essay,
        count: 38,
        questionsPerPaper: 2,
      ),
      EntryInput(
        activity: Activity.examMarking,
        subtype: Subtype.essay,
        count: 40,
        questionsPerPaper: 1,
      ),
      EntryInput(activity: Activity.labFirstTime, count: 1),
      EntryInput(activity: Activity.projectSupervision, count: 2),
      EntryInput(
        activity: Activity.caPrep,
        subtype: Subtype.essay,
        count: 5,
        isComplete: false,
      ),
    ];

    final perEntry = entries.fold<double>(
      0,
      (sum, entry) => sum + entryCredit(entry, rates),
    );
    final row = roleRowHours(ec5208Teacher.info, rollUp(entries), rates);
    expect(row.total, hours(perEntry));

    // And per category.
    for (final category in Category.values) {
      final expected = entries
          .where((e) => categoryOf(e.activity) == category)
          .fold<double>(0, (sum, e) => sum + entryCredit(e, rates));
      expect(row[category], hours(expected), reason: category.name);
    }
  });
}
