import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/domain/role_row.dart';
import 'package:workload_logger/domain/roll_up.dart';
import 'package:workload_logger/domain/summary.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

import 'fixtures.dart';

Matcher hours(double expected) => closeTo(expected, 1e-9);

void main() {
  final rates = RateSet.defaults();

  group('inputsToEntries', () {
    test('round-trips every owner row', () {
      for (final row in ownerRows) {
        expect(
          rollUp(inputsToEntries(row.inputs)),
          row.inputs,
          reason: '${row.info}',
        );
      }
    });

    test('round-trips a fractional weighted Qs/paper', () {
      final inputs = WorkbookInputs({
        InputColumn.ac: 78,
        InputColumn.ad: 116 / 78,
        InputColumn.j: 10,
        InputColumn.i: 2.5,
      });
      expect(rollUp(inputsToEntries(inputs)), inputs);
    });

    test('a marking pair becomes one entry', () {
      expect(inputsToEntries(ec3202Teacher.inputs), hasLength(1));
      final entry = inputsToEntries(ec3202Teacher.inputs).single;
      expect(entry.activity, Activity.examMarking);
      expect(entry.subtype, Subtype.essay);
      expect(entry.count, 193);
      expect(entry.questionsPerPaper, 1);
    });
  });

  group('summarize', () {
    final rows = {for (final (i, row) in ownerRows.indexed) i: row.info};
    final openingEntries = {
      for (final (i, row) in ownerRows.indexed) i: inputsToEntries(row.inputs),
    };

    test('opening balances reproduce SPEC §13: 78.7 h', () {
      final summary = summarize(rows, openingEntries, rates);
      expect(summary.total[Category.caMarking], hours(40.0));
      expect(summary.total[Category.examMarking], hours(36.7));
      expect(summary.total[Category.moderator], hours(2.0));
      expect(summary.total.total, hours(78.7));
      expect(
        summary.byRoleRow[ownerRows.indexOf(ec5406Teacher)]!.total,
        hours(50.0),
      );
    });

    test('a quiz on EC5208 adds 1.0 h → 79.7 h', () {
      final ec5208 = ownerRows.indexOf(ec5208Teacher);
      final withQuiz = {
        ...openingEntries,
        ec5208: const [
          EntryInput(
            activity: Activity.caPrep,
            subtype: Subtype.quiz,
            count: 10,
          ),
        ],
      };
      expect(summarize(rows, withQuiz, rates).total.total, hours(79.7));
    });

    test('creditedHours excludes automatic hours and drafts', () {
      const entries = [
        EntryInput(activity: Activity.caPrep, subtype: Subtype.quiz, count: 10),
        EntryInput(activity: Activity.moderationDone, count: 1),
        EntryInput(
          activity: Activity.caPrep,
          subtype: Subtype.essay,
          count: 2,
          isComplete: false,
        ),
      ];
      expect(creditedHours(entries, rates), hours(1.0));
    });
  });
}
