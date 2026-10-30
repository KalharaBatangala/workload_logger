/// Workload rates from the Admin_Config sheet (SPEC §3.1). Pure Dart.
library;

/// Admin_Config section headings. Some labels (e.g. "Quiz question") appear in
/// more than one section, so the importer matches label + section.
enum RateSection {
  /// Rows 4–10: general allocations (no numbered heading).
  general,

  /// "2. CONTINUOUS ASSESSMENT…" — CA question preparation.
  caPreparation,

  /// "3. END-OF-SEMESTER EXAM…" — end exam preparation.
  examPreparation,

  /// Section 4 — CA marking.
  caMarking,

  /// Section 5 — end exam marking.
  examMarking,

  /// Project supervision and industrial training.
  supervision,

  /// Not in Admin_Config (PG rate is typed into the PG sheet formula, §3.4).
  notInAdminConfig,
}

/// Every rate the app uses, with its Admin_Config label, cell and default.
///
/// The defaults are written the way the workbook writes them (`6 / 60` etc.)
/// and are only for tests and as a fallback when a label is missing.
enum RateKey {
  creditHours(
    'Hours allocated per 1 credit (reference)',
    RateSection.general,
    'B5',
    14,
  ),
  coordTaught(
    'Module Coordination - Taught module (per semester)',
    RateSection.general,
    'B6',
    10,
  ),
  coordProject(
    'Module Coordination - Project module (per semester)',
    RateSection.general,
    'B7',
    25,
  ),
  secondMarkPaper(
    'Second marking - End exam (hours per paper)',
    RateSection.general,
    'B8',
    6 / 60,
  ),
  moderator(
    'Moderator (per module, per semester)',
    RateSection.general,
    'B9',
    2,
  ),
  labFirstTime(
    'Lab preparation - first time only (per lab)',
    RateSection.general,
    'B10',
    20,
  ),
  caPrepQuiz('Quiz question', RateSection.caPreparation, 'B13', 6 / 60),
  caPrepStructured(
    'Structured question',
    RateSection.caPreparation,
    'B14',
    1.5,
  ),
  caPrepEssay('Essay question', RateSection.caPreparation, 'B15', 2),
  caPrepProject(
    'Project-type CA preparation',
    RateSection.caPreparation,
    'B16',
    5,
  ),
  examPrepMcq('MCQ question', RateSection.examPreparation, 'B19', 0.1),
  examPrepStructured(
    'Structured question',
    RateSection.examPreparation,
    'B20',
    1.5,
  ),
  examPrepEssay('Essay question', RateSection.examPreparation, 'B21', 2),
  examPrepProject(
    'Project-type end exam preparation',
    RateSection.examPreparation,
    'B22',
    5,
  ),
  caMarkQuiz('CA - Quiz', RateSection.caMarking, 'B25', 0),
  caMarkStructured('CA - Structured', RateSection.caMarking, 'B26', 6 / 60),
  caMarkEssay('CA - Essay', RateSection.caMarking, 'B27', 6 / 60),
  caMarkProject(
    'CA - Project evaluation',
    RateSection.caMarking,
    'B28',
    12 / 60,
  ),
  examMarkMcq('Exam - MCQ', RateSection.examMarking, 'B31', 0.002),
  examMarkStructured('Exam - Structured', RateSection.examMarking, 'B32', 0.1),
  examMarkEssay('Exam - Essay', RateSection.examMarking, 'B33', 0.1),
  examMarkProject(
    'Exam - Project evaluation',
    RateSection.examMarking,
    'B34',
    12 / 60,
  ),
  projectSupervision(
    'Project supervision (per project)',
    RateSection.supervision,
    'B37',
    30,
  ),
  itEvaluation(
    'Industrial Training Evaluation',
    RateSection.supervision,
    'B40',
    18 / 60,
  ),
  pgSupervision(
    'Postgraduate supervision (per student per year)',
    RateSection.notInAdminConfig,
    null,
    50,
  );

  const RateKey(this.label, this.section, this.sourceCell, this.defaultHours);

  /// Text in Admin_Config column A.
  final String label;

  final RateSection section;

  /// Cell in V10.1; informational only — the importer matches by label.
  final String? sourceCell;

  final double defaultHours;

  /// Whether this rate is read from Admin_Config at all.
  bool get isInAdminConfig => section != RateSection.notInAdminConfig;
}

/// An immutable set of rates, one value per [RateKey].
class RateSet {
  RateSet._(this._hours, this._defaultKeys);

  /// All rates at their SPEC §3.1 defaults.
  factory RateSet.defaults() => RateSet.from(const {});

  /// Rates from [hours]; any key not present falls back to its default and is
  /// reported by [isDefault].
  factory RateSet.from(Map<RateKey, double> hours) {
    final resolved = <RateKey, double>{};
    final defaults = <RateKey>{};
    for (final key in RateKey.values) {
      final value = hours[key];
      if (value == null) {
        resolved[key] = key.defaultHours;
        defaults.add(key);
      } else {
        resolved[key] = value;
      }
    }
    return RateSet._(Map.unmodifiable(resolved), Set.unmodifiable(defaults));
  }

  final Map<RateKey, double> _hours;
  final Set<RateKey> _defaultKeys;

  /// Hours credited per unit for [key].
  double hours(RateKey key) => _hours[key]!;

  /// True when [key] was not supplied and its default is used.
  bool isDefault(RateKey key) => _defaultKeys.contains(key);

  /// Keys using their default value.
  Set<RateKey> get defaultKeys => _defaultKeys;

  @override
  bool operator ==(Object other) =>
      other is RateSet &&
      RateKey.values.every((key) => other._hours[key] == _hours[key]);

  @override
  int get hashCode => Object.hashAll(RateKey.values.map((key) => _hours[key]));

  @override
  String toString() =>
      'RateSet(${_hours.entries.map((e) => '${e.key.name}: ${e.value}').join(', ')})';
}
