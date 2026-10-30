/// Which activities a role row offers (SPEC §5).
library;

import 'enums.dart';
import 'role_row.dart';
import 'workbook_mapping.dart';

/// An activity offered for a role row, with the subtypes the user picks from.
class ActivityOption {
  const ActivityOption(
    this.activity, {
    this.subtypes = const [],
    this.isSecondary = false,
  });

  final Activity activity;

  /// Empty for activities without a type (lecture, lab, second marking…).
  final List<Subtype> subtypes;

  /// Shown under "More" rather than as a main tile.
  final bool isSecondary;

  @override
  bool operator ==(Object other) =>
      other is ActivityOption &&
      other.activity == activity &&
      other.isSecondary == isSecondary &&
      other.subtypes.length == subtypes.length &&
      Iterable.generate(subtypes.length)
          .every((i) => other.subtypes[i] == subtypes[i]);

  @override
  int get hashCode =>
      Object.hash(activity, isSecondary, Object.hashAll(subtypes));

  @override
  String toString() =>
      'ActivityOption(${activity.name}, ${subtypes.map((s) => s.name).toList()}'
      '${isSecondary ? ', secondary' : ''})';
}

const _caSubtypesTaught = [
  Subtype.quiz,
  Subtype.structured,
  Subtype.essay,
  Subtype.project,
];
const _examSubtypesTaught = [
  Subtype.mcq,
  Subtype.structured,
  Subtype.essay,
  Subtype.project,
];
const _projectOnly = [Subtype.project];

/// Whether the module is an Industrial Training module (the only place the
/// IT evaluation activity appears).
bool isIndustrialTrainingModule(RoleRowInfo row) =>
    normalizeWorkbookText(row.moduleName).contains('industrial training');

/// Activities for one role row, in tile order. Coordinator rows have none:
/// their hours are credited automatically.
List<ActivityOption> activitiesFor(RoleRowInfo row) {
  switch (row.role) {
    case Role.coordinator:
      return const [];
    case Role.secondExaminer:
      return const [ActivityOption(Activity.secondMarking)];
    case Role.moderator:
      return const [ActivityOption(Activity.moderationDone)];
    case Role.teacher:
      final taught = row.moduleType == ModuleType.taught;
      final ca = taught ? _caSubtypesTaught : _projectOnly;
      final exam = taught ? _examSubtypesTaught : _projectOnly;
      return [
        const ActivityOption(Activity.lecture),
        ActivityOption(Activity.caPrep, subtypes: ca),
        ActivityOption(Activity.examPrep, subtypes: exam),
        ActivityOption(Activity.caMarking, subtypes: ca),
        ActivityOption(Activity.examMarking, subtypes: exam),
        if (taught) const ActivityOption(Activity.labFirstTime),
        if (isIndustrialTrainingModule(row))
          const ActivityOption(Activity.itEvaluation),
        ActivityOption(Activity.projectSupervision, isSecondary: taught),
      ];
  }
}

/// True for roles whose hours are credited automatically (no logging).
bool isAutomaticRole(Role role) =>
    role == Role.coordinator || role == Role.moderator;

/// What the count of an entry measures.
enum CountKind {
  hours,
  questions,
  assessments,
  papers,
  students,
  labs,
  projects,
}

/// The unit counted for (activity, subtype); null for activities without a
/// count (moderation, other work).
CountKind? countKindFor(Activity activity, Subtype? subtype) =>
    switch (activity) {
      Activity.lecture => CountKind.hours,
      Activity.caPrep || Activity.examPrep =>
        subtype == Subtype.project
            ? CountKind.assessments
            : CountKind.questions,
      Activity.caMarking || Activity.examMarking =>
        subtype == Subtype.project ? CountKind.students : CountKind.papers,
      Activity.secondMarking => CountKind.papers,
      Activity.labFirstTime => CountKind.labs,
      Activity.projectSupervision => CountKind.projects,
      Activity.itEvaluation => CountKind.students,
      Activity.moderationDone || Activity.other => null,
    };

/// Whether (activity, subtype) is paper marking, which also needs the number
/// of questions marked per paper.
bool needsQuestionsPerPaper(Activity activity, Subtype? subtype) =>
    columnTargetFor(activity, subtype)?.isPaperMarking ?? false;
