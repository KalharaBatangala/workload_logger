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
