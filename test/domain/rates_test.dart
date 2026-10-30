import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/rates.dart';

void main() {
  test('defaults match SPEC §3.1', () {
    const expected = {
      RateKey.creditHours: 14.0,
      RateKey.coordTaught: 10.0,
      RateKey.coordProject: 25.0,
      RateKey.secondMarkPaper: 0.1,
      RateKey.moderator: 2.0,
      RateKey.labFirstTime: 20.0,
      RateKey.caPrepQuiz: 0.1,
      RateKey.caPrepStructured: 1.5,
      RateKey.caPrepEssay: 2.0,
      RateKey.caPrepProject: 5.0,
      RateKey.examPrepMcq: 0.1,
      RateKey.examPrepStructured: 1.5,
      RateKey.examPrepEssay: 2.0,
      RateKey.examPrepProject: 5.0,
      RateKey.caMarkQuiz: 0.0,
      RateKey.caMarkStructured: 0.1,
      RateKey.caMarkEssay: 0.1,
      RateKey.caMarkProject: 0.2,
      RateKey.examMarkMcq: 0.002,
      RateKey.examMarkStructured: 0.1,
      RateKey.examMarkEssay: 0.1,
      RateKey.examMarkProject: 0.2,
      RateKey.projectSupervision: 30.0,
      RateKey.itEvaluation: 0.3,
      RateKey.pgSupervision: 50.0,
    };
    expect(expected.keys.toSet(), RateKey.values.toSet());

    final rates = RateSet.defaults();
    for (final MapEntry(:key, :value) in expected.entries) {
      expect(rates.hours(key), closeTo(value, 1e-12), reason: key.name);
      expect(rates.isDefault(key), isTrue);
    }
  });

  test('labels shared by two sections are told apart by section', () {
    expect(RateKey.caPrepStructured.label, RateKey.examPrepStructured.label);
    expect(
      RateKey.caPrepStructured.section,
      isNot(RateKey.examPrepStructured.section),
    );
    // Every (label, section) pair is unique, so the importer can match.
    final pairs = RateKey.values.map((k) => (k.label, k.section)).toList();
    expect(pairs.toSet().length, pairs.length);
  });

  test('only the PG rate is outside Admin_Config', () {
    expect(RateKey.values.where((k) => !k.isInAdminConfig), [
      RateKey.pgSupervision,
    ]);
  });

  test('from() keeps supplied rates and flags the rest as defaults', () {
    final rates = RateSet.from({RateKey.caPrepQuiz: 0.2});
    expect(rates.hours(RateKey.caPrepQuiz), 0.2);
    expect(rates.isDefault(RateKey.caPrepQuiz), isFalse);
    expect(rates.hours(RateKey.caPrepEssay), 2.0);
    expect(rates.isDefault(RateKey.caPrepEssay), isTrue);
    expect(rates.defaultKeys, isNot(contains(RateKey.caPrepQuiz)));
    expect(rates.defaultKeys.length, RateKey.values.length - 1);
  });

  test('equality by values', () {
    expect(RateSet.defaults(), RateSet.defaults());
    expect(RateSet.from({RateKey.moderator: 2}), RateSet.defaults());
    expect(RateSet.from({RateKey.moderator: 3}), isNot(RateSet.defaults()));
  });
}
