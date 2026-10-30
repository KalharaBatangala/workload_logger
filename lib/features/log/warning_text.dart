import '../../core/activity_labels.dart';
import '../../core/format.dart';
import '../../domain/entry_warnings.dart';

/// "This makes 220 papers for EC5207, which has 180 students."
/// "You logged the same 10 just now."
String warningText(EntryWarning warning, {required String moduleCode}) =>
    switch (warning) {
      MoreThanStudents(:final total, :final students, :final kind) =>
        'This makes ${formatCount(total)} '
            '${ActivityLabels.countUnit(kind, total)} for $moduleCode, which '
            'has $students students.',
      LikelyDuplicate(:final ago) =>
        ago.inMinutes < 1
            ? 'You logged the same just now. Saving again adds it twice.'
            : 'You logged the same ${ago.inMinutes} min ago. Saving again '
                  'adds it twice.',
    };
