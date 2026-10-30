/// Display formatting shared across screens.
library;

/// "20:30" → "8:30 pm", "07:05" → "7:05 am" (the designs' style).
String formatClockTime(String hhmm) {
  final parts = hhmm.split(':');
  final hour = int.parse(parts[0]);
  final minute = parts[1].padLeft(2, '0');
  final h12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$h12:$minute ${hour < 12 ? 'am' : 'pm'}';
}

/// Hours with one decimal and "h": 78.7 → "78.7 h" (CLAUDE.md).
String formatHours(double hours) => '${hours.toStringAsFixed(1)} h';

/// A credit with its sign: 1.0 → "+1.0 h" (entries, Save button, Saved).
String formatCredit(double hours) => '+${formatHours(hours)}';

/// A number without a pointless ".0": 10.0 → "10", 1.5 → "1.5".
String formatCount(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toString();

/// A rate per unit in friendly units (SPEC §8.4): from 1 min to under 1 h
/// in minutes ("6 min"); under 1 min in hours with 3 decimals ("0.002 h");
/// 1 h or more in hours ("1.5 h", "20 h").
String formatRate(double hours) {
  if (hours == 0) return '0 h';
  if (hours >= 1) return '${formatCount(_round(hours, 2))} h';
  final minutes = hours * 60;
  if (minutes >= 1 - 1e-9) return '${formatCount(_round(minutes, 1))} min';
  return '${hours.toStringAsFixed(3)} h';
}

double _round(double value, int places) {
  final factor = places == 1 ? 10 : 100;
  return (value * factor).roundToDouble() / factor;
}

/// Time spent: 60 → "1 h", 90 → "1 h 30 min", 45 → "45 min".
String formatMinutes(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '$m min';
  if (m == 0) return '$h h';
  return '$h h $m min';
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// "Today", "Yesterday", or "Mon 26 Oct" for an ISO date.
String formatDayLabel(String date, {required String today}) {
  if (date == today) return 'Today';
  final d = DateTime.parse(date);
  final t = DateTime.parse(today);
  if (DateTime(t.year, t.month, t.day - 1) == d) return 'Yesterday';
  return '${_weekdays[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';
}
