/// How an entry reads in lists (Today, History).
library;

import '../data/db/app_database.dart';
import '../domain/activity_catalogue.dart';
import '../domain/credit_calculator.dart';
import '../domain/enums.dart';
import '../domain/rates.dart';
import '../data/repositories/entries_repository.dart';
import 'activity_labels.dart';
import 'format.dart';

class EntryDisplay {
  const EntryDisplay({
    required this.title,
    required this.detail,
    required this.credit,
    required this.isDraft,
  });

  /// "Prepared CA · Quiz".
  final String title;

  /// "10 questions · spent 1 h · logged 9:40 pm".
  final String detail;

  /// Credited hours; null for drafts and entries that credit nothing by
  /// themselves (moderation).
  final double? credit;
  final bool isDraft;
}

EntryDisplay describeEntry(EntryRow entry, RateSet rates) {
  final activity = entry.activity;
  final subtype = entry.subtype;
  final isDraft = entry.status == EntryStatus.draft;
  final kind = countKindFor(activity, subtype);
  final count = entry.count;

  final what = <String>[
    if (kind != null && count != null)
      '${formatCount(count)} ${ActivityLabels.countUnit(kind, count)}'
          '${entry.questionsPerPaper != null ? ' × ${formatCount(entry.questionsPerPaper!)} Qs' : ''}',
    if (isDraft && count == null)
      entry.rawText != null ? '"${entry.rawText}"' : 'needs a count',
    if (entry.spentMinutes != null)
      'spent ${formatMinutes(entry.spentMinutes!)}',
    if (entry.source == EntrySource.timetable) 'from timetable',
    'logged ${formatClockTime(_hhmm(entry.createdAt.toLocal()))}',
  ];

  double? credit;
  if (!isDraft && activity != Activity.moderationDone) {
    try {
      credit = entryCredit(entry.toInput(), rates);
    } on ArgumentError {
      credit = null; // incomplete data in a complete entry: show no credit
    }
  }

  return EntryDisplay(
    title: [
      ActivityLabels.title(activity),
      if (subtype != null) ActivityLabels.subtype(subtype),
    ].join(' · '),
    detail: what.join(' · '),
    credit: credit,
    isDraft: isDraft,
  );
}

String _hhmm(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
