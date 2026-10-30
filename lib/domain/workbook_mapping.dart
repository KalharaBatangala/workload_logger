/// How logged activities map onto Data_Entry input columns I–AI (SPEC §3.2).
/// This file is the only place that knows the workbook's column layout.
library;

import 'enums.dart';

/// 0-based column index for a column letter: `columnIndex('A') == 0`,
/// `columnIndex('AC') == 28`.
int columnIndex(String letters) {
  final upper = letters.trim().toUpperCase();
  if (upper.isEmpty || !RegExp(r'^[A-Z]+$').hasMatch(upper)) {
    throw ArgumentError.value(letters, 'letters', 'not a column letter');
  }
  var index = 0;
  for (final unit in upper.codeUnits) {
    index = index * 26 + (unit - 64);
  }
  return index - 1;
}

/// Column letter for a 0-based index: `columnLetter(28) == 'AC'`.
String columnLetter(int index) {
  if (index < 0) throw RangeError.value(index, 'index');
  var n = index + 1;
  final buffer = StringBuffer();
  while (n > 0) {
    final remainder = (n - 1) % 26;
    buffer.write(String.fromCharCode(65 + remainder));
    n = (n - 1) ~/ 26;
  }
  return buffer.toString().split('').reversed.join();
}

/// The 27 input columns of Data_Entry, in sheet order.
enum InputColumn {
  i('Lecture hours conducted'),
  j('CA prep — Quiz: questions prepared'),
  k('CA prep — Structured: questions prepared'),
  l('CA prep — Essay: questions prepared'),
  m('CA prep — Project: assessments prepared'),
  n('End exam prep — MCQ: questions prepared'),
  o('End exam prep — Structured: questions prepared'),
  p('End exam prep — Essay: questions prepared'),
  q('End exam prep — Project: assessments prepared'),
  r('CA marking — Quiz: papers marked'),
  s('CA marking — Quiz: questions per paper'),
  t('CA marking — Structured: papers marked'),
  u('CA marking — Structured: questions per paper'),
  v('CA marking — Essay: papers marked'),
  w('CA marking — Essay: questions per paper'),
  x('CA — Project: students evaluated'),
  y('End exam marking — MCQ: papers marked'),
  z('End exam marking — MCQ: questions per paper'),
  aa('End exam marking — Structured: papers marked'),
  ab('End exam marking — Structured: questions per paper'),
  ac('End exam marking — Essay: papers marked'),
  ad('End exam marking — Essay: questions per paper'),
  ae('End exam — Project: students evaluated'),
  af('2nd marking — end-exam papers marked'),
  ag('Labs prepared first time'),
  ah('UG projects supervised'),
  ai('Industrial Training students evaluated');

  const InputColumn(this.meaning);

  final String meaning;

  /// Upper-case column letter, e.g. "AC".
  String get letter => name.toUpperCase();

  /// 0-based column index in the sheet.
  int get index0 => columnIndex(letter);
}

/// Where an entry's numbers go: the count column, plus the questions-per-paper
/// column for paper-based marking.
class ColumnTarget {
  const ColumnTarget(this.count, [this.questionsPerPaper]);

  final InputColumn count;
  final InputColumn? questionsPerPaper;

  bool get isPaperMarking => questionsPerPaper != null;

  @override
  bool operator ==(Object other) =>
      other is ColumnTarget &&
      other.count == count &&
      other.questionsPerPaper == questionsPerPaper;

  @override
  int get hashCode => Object.hash(count, questionsPerPaper);

  @override
  String toString() =>
      'ColumnTarget(${count.letter}${questionsPerPaper == null ? '' : ', ${questionsPerPaper!.letter}'})';
}

/// (activity, subtype) → columns. Activities without subtypes use `null`.
/// `moderationDone` and `other` have no column.
const Map<(Activity, Subtype?), ColumnTarget> columnTargets = {
  (Activity.lecture, null): ColumnTarget(InputColumn.i),
  (Activity.caPrep, Subtype.quiz): ColumnTarget(InputColumn.j),
  (Activity.caPrep, Subtype.structured): ColumnTarget(InputColumn.k),
  (Activity.caPrep, Subtype.essay): ColumnTarget(InputColumn.l),
  (Activity.caPrep, Subtype.project): ColumnTarget(InputColumn.m),
  (Activity.examPrep, Subtype.mcq): ColumnTarget(InputColumn.n),
  (Activity.examPrep, Subtype.structured): ColumnTarget(InputColumn.o),
  (Activity.examPrep, Subtype.essay): ColumnTarget(InputColumn.p),
  (Activity.examPrep, Subtype.project): ColumnTarget(InputColumn.q),
  (Activity.caMarking, Subtype.quiz): ColumnTarget(
    InputColumn.r,
    InputColumn.s,
  ),
  (Activity.caMarking, Subtype.structured): ColumnTarget(
    InputColumn.t,
    InputColumn.u,
  ),
  (Activity.caMarking, Subtype.essay): ColumnTarget(
    InputColumn.v,
    InputColumn.w,
  ),
  (Activity.caMarking, Subtype.project): ColumnTarget(InputColumn.x),
  (Activity.examMarking, Subtype.mcq): ColumnTarget(
    InputColumn.y,
    InputColumn.z,
  ),
  (Activity.examMarking, Subtype.structured): ColumnTarget(
    InputColumn.aa,
    InputColumn.ab,
  ),
  (Activity.examMarking, Subtype.essay): ColumnTarget(
    InputColumn.ac,
    InputColumn.ad,
  ),
  (Activity.examMarking, Subtype.project): ColumnTarget(InputColumn.ae),
  (Activity.secondMarking, null): ColumnTarget(InputColumn.af),
  (Activity.labFirstTime, null): ColumnTarget(InputColumn.ag),
  (Activity.projectSupervision, null): ColumnTarget(InputColumn.ah),
  (Activity.itEvaluation, null): ColumnTarget(InputColumn.ai),
};

/// Columns for an entry, or null if the combination has no column
/// (moderationDone, other, or an invalid subtype).
ColumnTarget? columnTargetFor(Activity activity, Subtype? subtype) =>
    columnTargets[(activity, subtype)];

/// The input values of one role row, keyed by column. Absent columns are 0.
class WorkbookInputs {
  WorkbookInputs([Map<InputColumn, double> values = const {}])
    : _values = Map.unmodifiable({
        for (final entry in values.entries)
          if (entry.value != 0) entry.key: entry.value,
      });

  final Map<InputColumn, double> _values;

  double operator [](InputColumn column) => _values[column] ?? 0;

  /// Non-zero values only.
  Map<InputColumn, double> get nonZero => _values;

  /// True when every input is zero.
  bool get isEmpty => _values.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is WorkbookInputs &&
      InputColumn.values.every((column) => other[column] == this[column]);

  @override
  int get hashCode => Object.hashAll(InputColumn.values.map((c) => this[c]));

  @override
  String toString() =>
      'WorkbookInputs(${_values.entries.map((e) => '${e.key.letter}=${e.value}').join(', ')})';
}
