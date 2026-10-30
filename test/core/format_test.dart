import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/format.dart';
import 'package:workload_logger/domain/rates.dart';

void main() {
  test('friendly rates (SPEC §8.4)', () {
    expect(formatRate(6 / 60), '6 min');
    expect(formatRate(12 / 60), '12 min');
    expect(formatRate(18 / 60), '18 min');
    expect(formatRate(0.002), '0.002 h');
    expect(formatRate(1.5), '1.5 h');
    expect(formatRate(20), '20 h');
    expect(formatRate(2), '2 h');
    expect(formatRate(0), '0 h');
    // Every default rate formats without odd decimals.
    for (final key in RateKey.values) {
      expect(formatRate(key.defaultHours), isNot(contains('.000')));
    }
  });

  test('hours, credits, counts, minutes', () {
    expect(formatHours(78.7), '78.7 h');
    expect(formatHours(1), '1.0 h');
    expect(formatCredit(1.0), '+1.0 h');
    expect(formatCredit(15), '+15.0 h');
    expect(formatCount(10), '10');
    expect(formatCount(1.5), '1.5');
    expect(formatMinutes(60), '1 h');
    expect(formatMinutes(90), '1 h 30 min');
    expect(formatMinutes(45), '45 min');
  });

  test('day labels', () {
    const today = '2026-10-29';
    expect(formatDayLabel(today, today: today), 'Today');
    expect(formatDayLabel('2026-10-28', today: today), 'Yesterday');
    expect(formatDayLabel('2026-10-26', today: today), 'Mon 26 Oct');
    expect(formatDayLabel('2026-02-28', today: '2026-03-01'), 'Yesterday');
  });

  test('clock times', () {
    expect(formatClockTime('20:30'), '8:30 pm');
    expect(formatClockTime('07:30'), '7:30 am');
    expect(formatClockTime('12:00'), '12:00 pm');
    expect(formatClockTime('00:15'), '12:15 am');
  });
}
