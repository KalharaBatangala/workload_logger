/// Whether an entry has everything it needs to be credited (SPEC §12).
/// Anything less is saved as a draft.
library;

import 'activity_catalogue.dart';
import 'enums.dart';
import 'workbook_mapping.dart';

/// Most lecture hours one entry may hold.
const maxLectureHours = 12.0;

/// Allowed range for questions per paper.
const minQuestionsPerPaper = 1;
const maxQuestionsPerPaper = 100;

/// True when (activity, subtype, count, Qs/paper) can be saved as complete:
/// - the subtype is one the activity has (or none, for activities without);
/// - counts are whole numbers ≥ 1; lecture hours are multiples of 0.5, ≤ 12;
/// - paper marking has Qs/paper between 1 and 100.
bool isCompleteEntry({
  required Activity activity,
  Subtype? subtype,
  double? count,
  double? questionsPerPaper,
}) {
  if (activity == Activity.moderationDone) return true;
  if (activity == Activity.other) return false;
  if (columnTargetFor(activity, subtype) == null) return false;

  final c = count;
  if (c == null || c <= 0) return false;
  if (countKindFor(activity, subtype) == CountKind.hours) {
    if (c > maxLectureHours || (c * 2) != (c * 2).roundToDouble()) {
      return false;
    }
  } else if (c != c.roundToDouble()) {
    return false;
  }

  if (needsQuestionsPerPaper(activity, subtype)) {
    final q = questionsPerPaper;
    if (q == null ||
        q != q.roundToDouble() ||
        q < minQuestionsPerPaper ||
        q > maxQuestionsPerPaper) {
      return false;
    }
  }
  return true;
}
