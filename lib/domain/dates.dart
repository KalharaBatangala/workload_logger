/// Calendar-date helpers. Dates are stored as local `yyyy-MM-dd` strings,
/// which also sort correctly as text.
library;

String _two(int n) => n.toString().padLeft(2, '0');

/// `yyyy-MM-dd` for the local calendar date of [time].
String isoDate(DateTime time) =>
    '${time.year.toString().padLeft(4, '0')}-${_two(time.month)}-${_two(time.day)}';

/// Local midnight of an `yyyy-MM-dd` string.
DateTime parseIsoDate(String date) {
  final parts = date.split('-');
  if (parts.length != 3) {
    throw FormatException('Expected yyyy-MM-dd', date);
  }
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// [date] shifted by [days] calendar days (DST-safe).
String addDays(String date, int days) {
  final d = parseIsoDate(date);
  return isoDate(DateTime(d.year, d.month, d.day + days));
}

/// Monday of the week containing [date] (weeks run Monday–Sunday).
String weekStart(String date) =>
    addDays(date, -(parseIsoDate(date).weekday - DateTime.monday));

/// A label such as "2025/26" for the academic year that [date] most likely
/// falls in. Only a starting suggestion for the user to edit: the exact
/// academic-year boundaries are an open question (SPEC §14), so this simply
/// assumes years start in August.
String suggestedAcademicYearLabel(DateTime date) {
  final start = date.month >= DateTime.august ? date.year : date.year - 1;
  return '$start/${((start + 1) % 100).toString().padLeft(2, '0')}';
}

/// Length of a timetable slot in hours, rounded to the nearest half hour
/// (lecture hours are logged in 0.5 steps, SPEC §12), at least 0.5.
double slotLengthHours(String startHhmm, String endHhmm) {
  int minutes(String hhmm) {
    final p = hhmm.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  final rounded = ((minutes(endHhmm) - minutes(startHhmm)) / 30).round() / 2;
  return rounded < 0.5 ? 0.5 : rounded;
}
