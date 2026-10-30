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
