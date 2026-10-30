import 'package:flutter/material.dart';

import 'format.dart';
import '../domain/activity_catalogue.dart';
import '../domain/enums.dart';
import '../domain/rates.dart';

/// Words and icons for activities, types and counts (SPEC §5, §8.3, §8.4).
abstract final class ActivityLabels {
  static String title(Activity activity) => switch (activity) {
    Activity.lecture => 'Lecture conducted',
    Activity.caPrep => 'Prepared CA',
    Activity.examPrep => 'Prepared end exam',
    Activity.caMarking => 'Marked CA',
    Activity.examMarking => 'Marked end exam',
    Activity.labFirstTime => 'New lab prepared',
    Activity.projectSupervision => 'Projects supervised',
    Activity.itEvaluation => 'IT students evaluated',
    Activity.secondMarking => 'Papers second-marked',
    Activity.moderationDone => 'Moderation done',
    Activity.other => 'Other work',
  };

  /// The small hint under a tile title; rates come from [rates].
  static String hint(
    Activity activity,
    List<Subtype> subtypes,
    RateSet rates,
  ) => switch (activity) {
    Activity.lecture => 'Enter hours',
    Activity.caPrep || Activity.examPrep =>
      subtypes.length == 1 ? 'Project assessments' : subtypeList(subtypes),
    Activity.caMarking => 'Papers or students',
    Activity.examMarking => 'First marking, in batches',
    Activity.labFirstTime =>
      'First time only · ${formatRate(rates.hours(RateKey.labFirstTime))} each',
    Activity.projectSupervision =>
      '${formatRate(rates.hours(RateKey.projectSupervision))} per project',
    Activity.itEvaluation =>
      '${formatRate(rates.hours(RateKey.itEvaluation))} per student',
    Activity.secondMarking =>
      '${formatRate(rates.hours(RateKey.secondMarkPaper))} per paper',
    Activity.moderationDone => 'One tap · hours are automatic',
    Activity.other => 'Not in the workload model',
  };

  /// "Quiz, structured, essay, project".
  static String subtypeList(List<Subtype> subtypes) {
    final words = subtypes.map((s) => subtype(s).toLowerCase()).toList();
    if (words.first == 'mcq') words[0] = 'MCQ';
    final text = words.join(', ');
    return text[0].toUpperCase() + text.substring(1);
  }

  static IconData icon(Activity activity) => switch (activity) {
    Activity.lecture => Icons.co_present_outlined,
    Activity.caPrep => Icons.edit_outlined,
    Activity.examPrep => Icons.description_outlined,
    Activity.caMarking || Activity.examMarking => Icons.check_box_outlined,
    Activity.labFirstTime => Icons.science_outlined,
    Activity.projectSupervision => Icons.groups_outlined,
    Activity.itEvaluation => Icons.badge_outlined,
    Activity.secondMarking => Icons.fact_check_outlined,
    Activity.moderationDone => Icons.verified_outlined,
    Activity.other => Icons.more_horiz_rounded,
  };

  static String subtype(Subtype subtype) => switch (subtype) {
    Subtype.quiz => 'Quiz',
    Subtype.mcq => 'MCQ',
    Subtype.structured => 'Structured',
    Subtype.essay => 'Essay',
    Subtype.project => 'Project',
  };

  /// Label above the count ("Questions prepared", "Papers marked"…).
  static String countLabel(CountKind kind) => switch (kind) {
    CountKind.hours => 'Hours',
    CountKind.questions => 'Questions prepared',
    CountKind.assessments => 'Assessments prepared',
    CountKind.papers => 'Papers marked',
    CountKind.students => 'Students evaluated',
    CountKind.labs => 'Labs prepared',
    CountKind.projects => 'Projects supervised',
  };

  /// Unit after a number ("10 questions", "40 papers", "2 h").
  static String countUnit(CountKind kind, double count) {
    final one = count == 1;
    return switch (kind) {
      CountKind.hours => 'h',
      CountKind.questions => one ? 'question' : 'questions',
      CountKind.assessments => one ? 'assessment' : 'assessments',
      CountKind.papers => one ? 'paper' : 'papers',
      CountKind.students => one ? 'student' : 'students',
      CountKind.labs => one ? 'lab' : 'labs',
      CountKind.projects => one ? 'project' : 'projects',
    };
  }

  /// Quick-set chips: 5/10/20, plus 25/50 for marking (SPEC §8.4). Hours
  /// and the rarely-large counts (labs, projects) get small numbers.
  static List<double> quickCounts(CountKind kind) => switch (kind) {
    CountKind.hours => const [1, 2, 3],
    CountKind.labs || CountKind.projects => const [1, 2, 3],
    CountKind.papers || CountKind.students => const [5, 10, 20, 25, 50],
    CountKind.questions || CountKind.assessments => const [5, 10, 20],
  };

  /// "Teacher" → "Teacher activities"; used in Step 2's footer.
  static String roleActivities(Role role) => switch (role) {
    Role.teacher => 'teaching activities',
    Role.secondExaminer => 'second-marking',
    Role.moderator => 'moderation',
    Role.coordinator => 'coordination',
  };
}
