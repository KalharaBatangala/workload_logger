import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/period_report.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/features/summary/providers.dart';

import '../../data/test_database.dart';

Matcher hours(double h) => closeTo(h, 1e-9);

void main() {
  late AppDatabase db;
  late ProviderContainer c;

  setUp(() async {
    db = openTestDatabase();
    c = testContainer(db);
    await c.read(demoSeederProvider).seed();
    c.listen(summaryViewProvider, (_, _) {});
    await settle();
  });
  tearDown(() => db.close());

  Future<SummaryView> view() async {
    await settle();
    return c.read(summaryViewProvider.future);
  }

  test('categories, bars and zero chips (SPEC §8.7)', () async {
    final v = await view();
    expect(v.total.total, hours(79.7));
    expect(v.barCategories, [
      Category.caMarking,
      Category.examMarking,
      Category.moderator,
      Category.caPrep,
    ]);
    expect(v.latestCategory, Category.caPrep);
    expect(v.zeroCategories, hasLength(7));
    expect(v.otherWorkMinutes, 120);
  });

  test('role rows: by hours, then "Nothing yet" in workbook order', () async {
    final v = await view();
    expect(
      v.lines.map(
        (l) =>
            '${l.report.row.moduleCode} ${l.report.row.role.name} '
            '${l.nothingYet ? 'nothing' : l.hours.toStringAsFixed(1)}',
      ),
      [
        'EC5406 teacher 50.0',
        'EC3202 teacher 19.3',
        'EE3202 teacher 7.4',
        'EC5207 moderator 2.0',
        'EC5208 teacher 1.0',
        'EC5204 secondExaminer nothing',
        'EC5207 secondExaminer nothing',
        'EC5204 secondExaminer nothing',
      ],
    );
    final ec5204 = v.lines.where((l) => l.report.row.moduleCode == 'EC5204');
    expect(ec5204.every((l) => l.showBatch), isTrue);
    expect(v.lines.first.showBatch, isFalse);
  });

  test(
    'a custom range counts only its entries (plus automatic hours)',
    () async {
      c
          .read(selectedPeriodProvider.notifier)
          .select(const ReportPeriod(label: 'From Oct 30', from: '2026-10-30'));
      final v = await view();
      expect(v.total.total, hours(2.0));
      expect(v.otherWorkMinutes, 0);
    },
  );

  test('closing the year locks it and starts the next', () async {
    await c
        .read(summaryActionsProvider)
        .closeCurrentPeriod(label: '2025/26', nextLabel: '2026/27');

    await settle();
    final current = await c.read(currentYearPeriodProvider.future);
    expect(current.label, '2026/27');
    expect(current.from, '2026-10-30');
    expect((await view()).total.total, hours(2.0), reason: 'Moderator only');

    expect(await c.read(periodsRepositoryProvider).isLocked(testToday), isTrue);
    c.listen(closedPeriodsProvider, (_, _) {});
    await settle();
    final closed = c.read(closedPeriodsProvider).value!.single;
    expect(closed.label, '2025/26');
    expect(closed.to, testToday);

    c.read(selectedPeriodProvider.notifier).select(closed);
    expect((await view()).total.total, hours(79.7));
  });

  test('next year label', () {
    expect(nextYearLabel('2025/26', testNow), '2026/27');
    expect(nextYearLabel('2099/00', testNow), '2100/01');
    expect(nextYearLabel('odd', testNow), '2026/27');
  });
}
