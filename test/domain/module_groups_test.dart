import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/activity_catalogue.dart';
import 'package:workload_logger/domain/entry_validation.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/module_groups.dart';

import 'fixtures.dart';

void main() {
  final groups = groupModules([
    for (final row in ownerRows) (id: row.sheetRow, info: row.info),
  ]);
  ModuleGroup byCode(String code) => groups.singleWhere((g) => g.code == code);

  group('groupModules (SPEC §8.2)', () {
    test('one entry per module code, in workbook order', () {
      expect(groups.map((g) => g.code), [
        'EE3202',
        'EC3202',
        'EC5204',
        'EC5406',
        'EC5207',
        'EC5208',
      ]);
    });

    test('subtitles merge roles and batches', () {
      expect(byCode('EC5406').subtitle, 'Teacher · 25th · Project');
      expect(byCode('EC5207').subtitle, 'Second Examiner + Moderator · 25th');
      expect(byCode('EC5204').subtitle, 'Second Examiner · 24th and 25th');
      expect(byCode('EC5208').subtitle, 'Teacher · 25th');
    });

    test('batches and rows per batch', () {
      expect(byCode('EC5204').batches, ['24th', '25th']);
      expect(byCode('EC5204').rowsForBatch('24th').single.id, 400);
      expect(byCode('EC5207').rowsForBatch('25th'), hasLength(2));
      expect(byCode('EC5207').contains(319), isTrue);
    });
  });

  group('countKindFor', () {
    test('every offered (activity, subtype) has a count kind', () {
      for (final row in ownerRows) {
        for (final option in activitiesFor(row.info)) {
          if (option.activity == Activity.moderationDone) continue;
          final subtypes = option.subtypes.isEmpty
              ? const <Subtype?>[null]
              : option.subtypes;
          for (final subtype in subtypes) {
            expect(countKindFor(option.activity, subtype), isNotNull);
          }
        }
      }
    });

    test('labels follow the type', () {
      expect(countKindFor(Activity.caPrep, Subtype.quiz), CountKind.questions);
      expect(
        countKindFor(Activity.caPrep, Subtype.project),
        CountKind.assessments,
      );
      expect(countKindFor(Activity.caMarking, Subtype.essay), CountKind.papers);
      expect(
        countKindFor(Activity.examMarking, Subtype.project),
        CountKind.students,
      );
      expect(countKindFor(Activity.lecture, null), CountKind.hours);
      expect(needsQuestionsPerPaper(Activity.caMarking, Subtype.essay), isTrue);
      expect(
        needsQuestionsPerPaper(Activity.caMarking, Subtype.project),
        isFalse,
      );
      expect(needsQuestionsPerPaper(Activity.secondMarking, null), isFalse);
    });
  });

  group('isCompleteEntry (SPEC §12)', () {
    bool complete(Activity a, {Subtype? s, double? count, double? qpp}) =>
        isCompleteEntry(
          activity: a,
          subtype: s,
          count: count,
          questionsPerPaper: qpp,
        );

    test('counts are whole numbers ≥ 1', () {
      expect(complete(Activity.caPrep, s: Subtype.quiz, count: 10), isTrue);
      expect(complete(Activity.caPrep, s: Subtype.quiz, count: 0), isFalse);
      expect(complete(Activity.caPrep, s: Subtype.quiz), isFalse);
      expect(complete(Activity.caPrep, s: Subtype.quiz, count: 2.5), isFalse);
    });

    test('lecture hours: multiples of 0.5, at most 12', () {
      expect(complete(Activity.lecture, count: 1.5), isTrue);
      expect(complete(Activity.lecture, count: 12), isTrue);
      expect(complete(Activity.lecture, count: 12.5), isFalse);
      expect(complete(Activity.lecture, count: 1.25), isFalse);
    });

    test('paper marking needs Qs/paper 1–100', () {
      expect(
        complete(Activity.caMarking, s: Subtype.structured, count: 40),
        isFalse,
      );
      expect(
        complete(Activity.caMarking, s: Subtype.structured, count: 40, qpp: 3),
        isTrue,
      );
      expect(
        complete(
          Activity.caMarking,
          s: Subtype.structured,
          count: 40,
          qpp: 101,
        ),
        isFalse,
      );
      expect(
        complete(Activity.caMarking, s: Subtype.project, count: 40),
        isTrue,
      );
    });

    test('subtype must exist for the activity', () {
      expect(complete(Activity.caPrep, count: 10), isFalse);
      expect(complete(Activity.examPrep, s: Subtype.quiz, count: 10), isFalse);
      expect(complete(Activity.moderationDone), isTrue);
    });
  });
}
