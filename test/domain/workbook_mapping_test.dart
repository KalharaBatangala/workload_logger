import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

void main() {
  group('column letters', () {
    test('letter ↔ index', () {
      expect(columnIndex('A'), 0);
      expect(columnIndex('I'), 8);
      expect(columnIndex('Z'), 25);
      expect(columnIndex('AA'), 26);
      expect(columnIndex('ac'), 28);
      expect(columnIndex('AU'), 46);
      for (var i = 0; i < 200; i++) {
        expect(columnIndex(columnLetter(i)), i);
      }
    });

    test('invalid letters throw', () {
      expect(() => columnIndex(''), throwsArgumentError);
      expect(() => columnIndex('A1'), throwsArgumentError);
    });
  });

  test('input columns are exactly I…AI, contiguous and in order', () {
    expect(InputColumn.values.first.letter, 'I');
    expect(InputColumn.values.last.letter, 'AI');
    expect(InputColumn.values.length, 27);
    for (var k = 0; k < InputColumn.values.length; k++) {
      expect(InputColumn.values[k].index0, columnIndex('I') + k);
    }
  });

  test('every input column is used exactly once', () {
    final used = [
      for (final target in columnTargets.values) ...[
        target.count,
        if (target.questionsPerPaper != null) target.questionsPerPaper!,
      ],
    ];
    expect(used.toSet().length, used.length, reason: 'no column used twice');
    expect(used.toSet(), InputColumn.values.toSet());
  });

  test('spot checks against SPEC §3.2', () {
    expect(
      columnTargetFor(Activity.examMarking, Subtype.essay),
      const ColumnTarget(InputColumn.ac, InputColumn.ad),
    );
    expect(
      columnTargetFor(Activity.caMarking, Subtype.project),
      const ColumnTarget(InputColumn.x),
    );
    expect(
      columnTargetFor(Activity.lecture, null),
      const ColumnTarget(InputColumn.i),
    );
    expect(
      columnTargetFor(Activity.secondMarking, null),
      const ColumnTarget(InputColumn.af),
    );
    expect(columnTargetFor(Activity.moderationDone, null), isNull);
    expect(columnTargetFor(Activity.other, null), isNull);
    expect(columnTargetFor(Activity.caPrep, Subtype.mcq), isNull);
  });

  test('category hours columns are AJ…AT, total AU', () {
    expect(Category.values.first.hoursColumn, 'AJ');
    expect(Category.values.last.hoursColumn, 'AT');
    for (var k = 0; k < Category.values.length; k++) {
      expect(
        columnIndex(Category.values[k].hoursColumn),
        columnIndex('AJ') + k,
      );
    }
    expect(Category.totalColumn, 'AU');
  });

  test('WorkbookInputs: absent and zero values read as 0', () {
    final inputs = WorkbookInputs({InputColumn.j: 10, InputColumn.k: 0});
    expect(inputs[InputColumn.j], 10);
    expect(inputs[InputColumn.k], 0);
    expect(inputs[InputColumn.ai], 0);
    expect(inputs.nonZero, {InputColumn.j: 10});
    expect(WorkbookInputs().isEmpty, isTrue);
    expect(inputs, WorkbookInputs({InputColumn.j: 10}));
  });

  group('enum parsing', () {
    test('roles', () {
      expect(Role.fromWorkbook('Second Examiner'), Role.secondExaminer);
      expect(Role.fromWorkbook('  second   examiner '), Role.secondExaminer);
      expect(Role.fromWorkbook('Teacher'), Role.teacher);
      expect(Role.fromWorkbook('NA'), isNull);
    });

    test('module type: anything but Project is Taught (SPEC §3.5)', () {
      expect(ModuleType.fromWorkbook('Project'), ModuleType.project);
      expect(ModuleType.fromWorkbook(' project '), ModuleType.project);
      expect(ModuleType.fromWorkbook('Taught'), ModuleType.taught);
      expect(ModuleType.fromWorkbook('Coordinated,Project'), ModuleType.taught);
      expect(ModuleType.fromWorkbook(''), ModuleType.taught);
    });
  });
}
