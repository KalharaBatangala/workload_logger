/// Core vocabulary of the workload model (SPEC §3–§5). Pure Dart.
library;

/// Normalises workbook text for comparison: trimmed, whitespace collapsed,
/// lower-case.
String normalizeWorkbookText(String text) =>
    text.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

/// The role of a staff member on a Data_Entry row (column H).
enum Role {
  coordinator('Coordinator'),
  teacher('Teacher'),
  secondExaminer('Second Examiner'),
  moderator('Moderator');

  const Role(this.workbookLabel);

  /// The exact text used in the workbook.
  final String workbookLabel;

  /// Parses column H; returns null for anything unrecognised.
  static Role? fromWorkbook(String text) {
    final normalized = normalizeWorkbookText(text);
    for (final role in values) {
      if (normalizeWorkbookText(role.workbookLabel) == normalized) return role;
    }
    return null;
  }
}

/// Module type (Data_Entry column D).
enum ModuleType {
  taught('Taught'),
  project('Project');

  const ModuleType(this.workbookLabel);

  final String workbookLabel;

  /// Any value other than "Project" is treated as Taught (SPEC §3.5: row 402
  /// has a typo validation list).
  static ModuleType fromWorkbook(String text) =>
      normalizeWorkbookText(text) == 'project' ? project : taught;
}

/// A kind of logged work (SPEC §5).
enum Activity {
  lecture,
  caPrep,
  examPrep,
  caMarking,
  examMarking,
  labFirstTime,
  projectSupervision,
  itEvaluation,
  secondMarking,

  /// Status only; Moderator hours are credited automatically.
  moderationDone,

  /// Work outside the workload model; never credited.
  other;

  /// Marking activities count papers × questions per paper (except the
  /// project subtype, which counts students).
  bool get isMarking => this == caMarking || this == examMarking;
}

/// Assessment type for preparation and marking activities.
enum Subtype { quiz, mcq, structured, essay, project }

/// The 11 summary categories, in the workbook's hours-column order (AJ–AT).
enum Category {
  coordination('Coordination', 'AJ'),
  secondMarking('2nd Marking', 'AK'),
  moderator('Moderator', 'AL'),
  teaching('Teaching', 'AM'),
  caPrep('CA Prep', 'AN'),
  examPrep('Exam Prep', 'AO'),
  caMarking('CA Marking', 'AP'),
  examMarking('Exam Marking', 'AQ'),
  labPrep('Lab Prep', 'AR'),
  projectSupervision('Project Supervision', 'AS'),
  industrialTraining('Industrial Training', 'AT');

  const Category(this.label, this.hoursColumn);

  /// Display label (Summary screen).
  final String label;

  /// Data_Entry column holding this category's hours.
  final String hoursColumn;

  /// Data_Entry column holding the row total.
  static const totalColumn = 'AU';
}
