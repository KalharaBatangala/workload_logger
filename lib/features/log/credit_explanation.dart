import '../../core/format.dart';
import '../../domain/activity_catalogue.dart';
import '../../domain/credit_calculator.dart';
import '../../domain/rates.dart';
import 'activity_labels.dart';
import 'providers.dart';

/// The left side of the credit strip (SPEC §8.4), e.g. "10 × 6 min credited",
/// "40 × 3 × 6 min credited", "2 h conducted, credited as is".
String creditExplanation(LogFlowState state, RateSet rates) {
  final activity = state.activity;
  if (activity == null) return '';
  final count = state.count;
  if (countKindFor(activity, state.subtype) == CountKind.hours) {
    return count > 0
        ? '${formatCount(count)} h conducted, credited as is'
        : 'Enter the hours you taught';
  }
  final key = rateKeyFor(activity, state.subtype);
  if (key == null) return '';
  final rate = formatRate(rates.hours(key));
  if (count <= 0) return 'Set the number · $rate each';
  if (state.needsQpp) {
    final qpp = state.questionsPerPaper;
    if (qpp == null || qpp <= 0) return 'Set questions per paper · $rate each';
    return '${formatCount(count)} × ${formatCount(qpp)} × $rate credited';
  }
  return '${formatCount(count)} × $rate credited';
}

/// "Prepared CA · Quiz · 10 questions · Today" for the Saved screen.
String entrySummary(LogFlowState state, {required String dayLabel}) {
  final activity = state.activity;
  if (activity == null) return '';
  final kind = state.countKind;
  return [
    ActivityLabels.title(activity),
    if (state.subtype != null && state.subtypes.length > 1)
      ActivityLabels.subtype(state.subtype!),
    if (kind != null && state.count > 0)
      '${formatCount(state.count)} ${ActivityLabels.countUnit(kind, state.count)}',
    if (state.needsQpp && (state.questionsPerPaper ?? 0) > 0)
      '${formatCount(state.questionsPerPaper!)} Qs/paper',
    dayLabel,
  ].join(' · ');
}
