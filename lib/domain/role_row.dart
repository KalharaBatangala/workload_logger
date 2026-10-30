/// The minimal domain views of a role row and an entry that the credit maths
/// needs. Database rows (M2) map onto these.
library;

import 'enums.dart';

/// One Data_Entry row: module + batch + staff + role (SPEC §3.3).
class RoleRowInfo {
  const RoleRowInfo({
    required this.moduleCode,
    required this.batch,
    required this.moduleName,
    required this.moduleType,
    required this.role,
    this.students = 0,
  });

  final String moduleCode;
  final String batch;
  final String moduleName;
  final ModuleType moduleType;
  final Role role;

  /// Total No. of Students; 0 means unknown (validation is then skipped).
  final int students;

  @override
  String toString() =>
      'RoleRowInfo($moduleCode $batch ${role.workbookLabel} ${moduleType.workbookLabel})';
}

/// One logged piece of work, reduced to what the maths needs.
class EntryInput {
  const EntryInput({
    required this.activity,
    this.subtype,
    this.count,
    this.questionsPerPaper,
    this.isComplete = true,
    this.isDeleted = false,
  });

  final Activity activity;
  final Subtype? subtype;

  /// Questions, papers, students, labs, projects — or hours for a lecture.
  final double? count;

  /// Paper-based marking only. Whole numbers when logged; fractional only for
  /// opening balances (the workbook stores a weighted average).
  final double? questionsPerPaper;

  /// False for drafts.
  final bool isComplete;

  /// Soft-deleted entries never count.
  final bool isDeleted;

  /// Whether this entry contributes to totals.
  bool get counts => isComplete && !isDeleted;

  @override
  String toString() =>
      'EntryInput(${activity.name}${subtype == null ? '' : '/${subtype!.name}'}, '
      'count: $count, qpp: $questionsPerPaper'
      '${isComplete ? '' : ', draft'}${isDeleted ? ', deleted' : ''})';
}
