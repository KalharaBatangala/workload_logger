import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/activity_catalogue.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/role_row.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

import 'fixtures.dart';

List<Activity> mainTiles(RoleRowInfo row) =>
    activitiesFor(row)
        .where((option) => !option.isSecondary)
        .map((option) => option.activity)
        .toList();

ActivityOption optionFor(RoleRowInfo row, Activity activity) =>
    activitiesFor(row).singleWhere((option) => option.activity == activity);

void main() {
  test('EC5208 Taught Teacher shows the six tiles of the design', () {
    expect(mainTiles(ec5208Teacher.info), [
      Activity.lecture,
      Activity.caPrep,
      Activity.examPrep,
      Activity.caMarking,
      Activity.examMarking,
      Activity.labFirstTime,
    ]);
    // Project supervision is available under "More".
    expect(
      optionFor(ec5208Teacher.info, Activity.projectSupervision).isSecondary,
      isTrue,
    );
  });

  test('Taught subtypes: CA quiz…, exam mcq…', () {
    final row = ec5208Teacher.info;
    const ca = [
      Subtype.quiz,
      Subtype.structured,
      Subtype.essay,
      Subtype.project,
    ];
    const exam = [
      Subtype.mcq,
      Subtype.structured,
      Subtype.essay,
      Subtype.project,
    ];
    expect(optionFor(row, Activity.caPrep).subtypes, ca);
    expect(optionFor(row, Activity.caMarking).subtypes, ca);
    expect(optionFor(row, Activity.examPrep).subtypes, exam);
    expect(optionFor(row, Activity.examMarking).subtypes, exam);
  });

  test('EC5406 Project Teacher: project subtypes only, no lab', () {
    final row = ec5406Teacher.info;
    expect(mainTiles(row), [
      Activity.lecture,
      Activity.caPrep,
      Activity.examPrep,
      Activity.caMarking,
      Activity.examMarking,
      Activity.projectSupervision,
    ]);
    for (final activity in [
      Activity.caPrep,
      Activity.examPrep,
      Activity.caMarking,
      Activity.examMarking,
    ]) {
      expect(optionFor(row, activity).subtypes, [Subtype.project]);
    }
  });

  test('Second Examiner → second marking only', () {
    expect(mainTiles(ec5207SecondExaminer.info), [Activity.secondMarking]);
  });

  test('Moderator → moderation done only (hours automatic)', () {
    expect(mainTiles(ec5207Moderator.info), [Activity.moderationDone]);
    expect(isAutomaticRole(Role.moderator), isTrue);
  });

  test('Coordinator → no activities (hours automatic)', () {
    const row = RoleRowInfo(
      moduleCode: 'EC5406',
      batch: '25th',
      moduleName: 'Software Group Project',
      moduleType: ModuleType.project,
      role: Role.coordinator,
    );
    expect(activitiesFor(row), isEmpty);
    expect(isAutomaticRole(Role.coordinator), isTrue);
    expect(isAutomaticRole(Role.teacher), isFalse);
  });

  test('IT evaluation only on Industrial Training modules', () {
    const it = RoleRowInfo(
      moduleCode: 'EE4300',
      batch: '25th',
      moduleName: 'Industrial  training',
      moduleType: ModuleType.taught,
      role: Role.teacher,
    );
    expect(mainTiles(it), contains(Activity.itEvaluation));
    expect(
      mainTiles(ec5208Teacher.info),
      isNot(contains(Activity.itEvaluation)),
    );
  });

  test('every offered (activity, subtype) has a workbook column', () {
    final rows = [
      ...ownerRows.map((row) => row.info),
      const RoleRowInfo(
        moduleCode: 'EE4300',
        batch: '25th',
        moduleName: 'Industrial Training',
        moduleType: ModuleType.taught,
        role: Role.teacher,
      ),
    ];
    for (final row in rows) {
      for (final option in activitiesFor(row)) {
        if (option.activity == Activity.moderationDone) continue;
        final subtypes = option.subtypes.isEmpty
            ? const <Subtype?>[null]
            : option.subtypes;
        for (final subtype in subtypes) {
          expect(
            columnTargetFor(option.activity, subtype),
            isNotNull,
            reason: '${option.activity.name}/${subtype?.name}',
          );
        }
      }
    }
  });
}
