/// All credit maths (SPEC §4). The workload model credits counted outputs ×
/// fixed rates, never time spent. Nothing outside this file multiplies by a
/// rate.
library;

import 'enums.dart';
import 'rates.dart';
import 'role_row.dart';
import 'workbook_mapping.dart';

/// Hours per summary category for one role row (or a sum of role rows).
class CategoryHours {
  CategoryHours([Map<Category, double> hours = const {}])
    : _hours = Map.unmodifiable({
        for (final category in Category.values) category: hours[category] ?? 0,
      });

  static final zero = CategoryHours();

  final Map<Category, double> _hours;

  double operator [](Category category) => _hours[category]!;

  /// Column AU: the sum of the 11 categories.
  double get total => _hours.values.fold(0, (sum, hours) => sum + hours);

  CategoryHours operator +(CategoryHours other) => CategoryHours({
    for (final category in Category.values)
      category: this[category] + other[category],
  });

  /// Sum of many role rows' hours.
  static CategoryHours sum(Iterable<CategoryHours> all) =>
      all.fold(zero, (sum, hours) => sum + hours);

  @override
  String toString() =>
      'CategoryHours(${_hours.entries.where((e) => e.value != 0).map((e) => '${e.key.name}: ${e.value}').join(', ')}, total: $total)';
}

/// Credited hours for one role row, given its input values I–AI.
/// Mirrors the workbook's AJ–AU formulas exactly.
CategoryHours roleRowHours(
  RoleRowInfo row,
  WorkbookInputs inputs,
  RateSet rates,
) {
  double v(InputColumn column) => inputs[column];
  double r(RateKey key) => rates.hours(key);

  final coordination = row.role == Role.coordinator
      ? (row.moduleType == ModuleType.project
            ? r(RateKey.coordProject)
            : r(RateKey.coordTaught))
      : 0.0;
  final secondMarking = row.role == Role.secondExaminer
      ? v(InputColumn.af) * r(RateKey.secondMarkPaper)
      : 0.0;
  final moderator = row.role == Role.moderator ? r(RateKey.moderator) : 0.0;
  final teaching = v(InputColumn.i);
  final caPrep =
      v(InputColumn.j) * r(RateKey.caPrepQuiz) +
      v(InputColumn.k) * r(RateKey.caPrepStructured) +
      v(InputColumn.l) * r(RateKey.caPrepEssay) +
      v(InputColumn.m) * r(RateKey.caPrepProject);
  final examPrep =
      v(InputColumn.n) * r(RateKey.examPrepMcq) +
      v(InputColumn.o) * r(RateKey.examPrepStructured) +
      v(InputColumn.p) * r(RateKey.examPrepEssay) +
      v(InputColumn.q) * r(RateKey.examPrepProject);
  final caMarking =
      v(InputColumn.r) * v(InputColumn.s) * r(RateKey.caMarkQuiz) +
      v(InputColumn.t) * v(InputColumn.u) * r(RateKey.caMarkStructured) +
      v(InputColumn.v) * v(InputColumn.w) * r(RateKey.caMarkEssay) +
      v(InputColumn.x) * r(RateKey.caMarkProject);
  final examMarking =
      v(InputColumn.y) * v(InputColumn.z) * r(RateKey.examMarkMcq) +
      v(InputColumn.aa) * v(InputColumn.ab) * r(RateKey.examMarkStructured) +
      v(InputColumn.ac) * v(InputColumn.ad) * r(RateKey.examMarkEssay) +
      v(InputColumn.ae) * r(RateKey.examMarkProject);
  final labPrep = v(InputColumn.ag) * r(RateKey.labFirstTime);
  final supervision = v(InputColumn.ah) * r(RateKey.projectSupervision);
  final industrial = v(InputColumn.ai) * r(RateKey.itEvaluation);

  return CategoryHours({
    Category.coordination: coordination,
    Category.secondMarking: secondMarking,
    Category.moderator: moderator,
    Category.teaching: teaching,
    Category.caPrep: caPrep,
    Category.examPrep: examPrep,
    Category.caMarking: caMarking,
    Category.examMarking: examMarking,
    Category.labPrep: labPrep,
    Category.projectSupervision: supervision,
    Category.industrialTraining: industrial,
  });
}

/// Hours credited automatically just because the role row exists
/// (Coordinator and Moderator rows). The user never logs these.
double automaticHours(RoleRowInfo row, RateSet rates) => switch (row.role) {
  Role.coordinator =>
    row.moduleType == ModuleType.project
        ? rates.hours(RateKey.coordProject)
        : rates.hours(RateKey.coordTaught),
  Role.moderator => rates.hours(RateKey.moderator),
  Role.teacher || Role.secondExaminer => 0,
};

/// Summary category an activity's credit goes to; null for activities that
/// are never credited per entry (moderationDone, other).
Category? categoryOf(Activity activity) => switch (activity) {
  Activity.lecture => Category.teaching,
  Activity.caPrep => Category.caPrep,
  Activity.examPrep => Category.examPrep,
  Activity.caMarking => Category.caMarking,
  Activity.examMarking => Category.examMarking,
  Activity.labFirstTime => Category.labPrep,
  Activity.projectSupervision => Category.projectSupervision,
  Activity.itEvaluation => Category.industrialTraining,
  Activity.secondMarking => Category.secondMarking,
  Activity.moderationDone || Activity.other => null,
};

/// The rate for one unit of (activity, subtype); null when the activity is
/// credited in plain hours (lecture), not credited, or the subtype is invalid.
RateKey? rateKeyFor(Activity activity, Subtype? subtype) =>
    switch ((activity, subtype)) {
      (Activity.caPrep, Subtype.quiz) => RateKey.caPrepQuiz,
      (Activity.caPrep, Subtype.structured) => RateKey.caPrepStructured,
      (Activity.caPrep, Subtype.essay) => RateKey.caPrepEssay,
      (Activity.caPrep, Subtype.project) => RateKey.caPrepProject,
      (Activity.examPrep, Subtype.mcq) => RateKey.examPrepMcq,
      (Activity.examPrep, Subtype.structured) => RateKey.examPrepStructured,
      (Activity.examPrep, Subtype.essay) => RateKey.examPrepEssay,
      (Activity.examPrep, Subtype.project) => RateKey.examPrepProject,
      (Activity.caMarking, Subtype.quiz) => RateKey.caMarkQuiz,
      (Activity.caMarking, Subtype.structured) => RateKey.caMarkStructured,
      (Activity.caMarking, Subtype.essay) => RateKey.caMarkEssay,
      (Activity.caMarking, Subtype.project) => RateKey.caMarkProject,
      (Activity.examMarking, Subtype.mcq) => RateKey.examMarkMcq,
      (Activity.examMarking, Subtype.structured) => RateKey.examMarkStructured,
      (Activity.examMarking, Subtype.essay) => RateKey.examMarkEssay,
      (Activity.examMarking, Subtype.project) => RateKey.examMarkProject,
      (Activity.secondMarking, null) => RateKey.secondMarkPaper,
      (Activity.labFirstTime, null) => RateKey.labFirstTime,
      (Activity.projectSupervision, null) => RateKey.projectSupervision,
      (Activity.itEvaluation, null) => RateKey.itEvaluation,
      _ => null,
    };

/// Credited hours for a single entry (shown on Saved, in History…).
///
/// Drafts and deleted entries credit 0. A complete entry missing its count,
/// or a complete paper-marking entry missing Qs/paper, is invalid and throws.
double entryCredit(EntryInput entry, RateSet rates) {
  if (!entry.counts) return 0;
  final activity = entry.activity;
  if (activity == Activity.moderationDone || activity == Activity.other) {
    return 0;
  }

  final count = entry.count;
  if (count == null) {
    throw ArgumentError.value(entry, 'entry', 'complete entry has no count');
  }
  if (activity == Activity.lecture) return count;

  final target = columnTargetFor(activity, entry.subtype);
  final rateKey = rateKeyFor(activity, entry.subtype);
  if (target == null || rateKey == null) {
    throw ArgumentError.value(entry, 'entry', 'invalid activity/subtype');
  }
  final rate = rates.hours(rateKey);

  if (target.isPaperMarking) {
    final qpp = entry.questionsPerPaper;
    if (qpp == null) {
      throw ArgumentError.value(
        entry,
        'entry',
        'paper marking needs questions per paper',
      );
    }
    return count * qpp * rate;
  }
  return count * rate;
}

/// PG supervision hours for the year (SPEC §3.4); not one of the 11
/// categories.
double pgSupervisionHours(int students, RateSet rates) =>
    students * rates.hours(RateKey.pgSupervision);
