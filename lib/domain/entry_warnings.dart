/// Things worth a second look before saving (SPEC §12). They never block
/// saving. Pure Dart.
library;

import 'activity_catalogue.dart';
import 'enums.dart';

/// The minimum of an entry the checks need.
class WarningEntry {
  const WarningEntry({
    required this.roleRowId,
    required this.activity,
    required this.subtype,
    required this.date,
    required this.count,
    this.id,
    this.createdAt,
    this.isComplete = true,
  });

  final String? id;
  final int roleRowId;
  final Activity activity;
  final Subtype? subtype;
  final String date;
  final double count;
  final DateTime? createdAt;
  final bool isComplete;

  bool _sameKind(WarningEntry other) =>
      other.roleRowId == roleRowId &&
      other.activity == activity &&
      other.subtype == subtype;
}

sealed class EntryWarning {
  const EntryWarning();
}

/// The papers or students for this role row, activity and type would be
/// more than the module's students.
class MoreThanStudents extends EntryWarning {
  const MoreThanStudents({
    required this.total,
    required this.students,
    required this.kind,
  });

  final double total;
  final int students;
  final CountKind kind;
}

/// The same thing was logged a few minutes ago.
class LikelyDuplicate extends EntryWarning {
  const LikelyDuplicate(this.ago);

  final Duration ago;
}

/// How recent an identical entry must be to look like a duplicate.
const duplicateWindow = Duration(minutes: 10);

/// Warnings for [candidate] given the role row's other entries [existing]
/// (deleted ones already left out) and its module's [students] (0 = unknown,
/// so not checked). An entry being edited is recognised by its id and not
/// compared with itself.
List<EntryWarning> entryWarnings({
  required WarningEntry candidate,
  required Iterable<WarningEntry> existing,
  required int students,
  required DateTime now,
}) {
  final others = [
    for (final e in existing)
      if (e.id == null || e.id != candidate.id) e,
  ];
  final warnings = <EntryWarning>[];

  final kind = countKindFor(candidate.activity, candidate.subtype);
  if (students > 0 &&
      (kind == CountKind.papers || kind == CountKind.students)) {
    final total =
        candidate.count +
        others
            .where((e) => e.isComplete && e._sameKind(candidate))
            .fold<double>(0, (sum, e) => sum + e.count);
    if (total > students) {
      warnings.add(
        MoreThanStudents(total: total, students: students, kind: kind!),
      );
    }
  }

  for (final e in others) {
    final created = e.createdAt;
    if (created == null || !e._sameKind(candidate)) continue;
    final ago = now.difference(created);
    if (e.date == candidate.date &&
        e.count == candidate.count &&
        !ago.isNegative &&
        ago <= duplicateWindow) {
      warnings.add(LikelyDuplicate(ago));
      break;
    }
  }
  return warnings;
}
