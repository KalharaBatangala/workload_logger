import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/data/repositories/role_rows_repository.dart';
import 'package:workload_logger/domain/activity_catalogue.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/features/log/providers.dart';

import '../../data/test_database.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late LogFlowController flow;

  setUp(() async {
    db = openTestDatabase();
    container = testContainer(db);
    await container.read(demoSeederProvider).seed();
    // Keep the auto-disposed flow alive for the whole test.
    container.listen(logFlowProvider, (_, _) {});
    flow = container.read(logFlowProvider.notifier);
  });
  tearDown(() => db.close());

  Future<void> chooseEc3202Marking() async {
    final row = (await container.read(roleRowsRepositoryProvider).getAll())
        .firstWhere((r) => r.moduleCode == 'EC3202');
    await flow.chooseActivity(
      roleRowId: row.id,
      roleRow: row.toInfo(),
      option: activitiesFor(row.toInfo())
          .firstWhere((o) => o.activity == Activity.examMarking),
    );
  }

  LogFlowState state() => container.read(logFlowProvider);

  test('paper marking is complete only with Qs/paper', () async {
    await chooseEc3202Marking();
    // No marking was logged by hand before, so the first type is chosen and
    // nothing is remembered (opening balances do not count as memory).
    expect(state().subtype, Subtype.mcq);
    expect(state().questionsPerPaper, isNull);

    flow.setCount(100);
    expect(state().isComplete, isFalse);
    flow.setQuestionsPerPaper(40);
    expect(state().isComplete, isTrue);
    expect(state().creditWith(RateSet.defaults()), closeTo(8.0, 1e-9));
  });

  test('a date in a closed period gives a plain message', () async {
    final periods = container.read(periodsRepositoryProvider);
    final id = await periods.create(
      label: 'Semester 1',
      startDate: '2026-08-01',
      endDate: '2026-10-28',
    );
    await periods.close(id);

    await chooseEc3202Marking();
    flow.setDate('2026-10-28');
    flow.setCount(10);
    flow.setQuestionsPerPaper(1);

    expect(await flow.save(), isFalse);
    expect(state().error, contains('closed period'));
    expect(state().saved, isNull);

    flow.setDate(testToday);
    expect(state().error, isNull);
    expect(await flow.save(), isTrue);
    expect(state().saved!.isDraft, isFalse);
  });

  test('undo soft-deletes and keeps the values', () async {
    await chooseEc3202Marking();
    flow.setCount(50);
    flow.setQuestionsPerPaper(2);
    await flow.save();
    final id = state().saved!.id;

    await flow.undo();
    expect(state().saved, isNull);
    expect(state().count, 50);
    final entry = await container.read(entriesRepositoryProvider).byId(id);
    expect(entry!.deletedAt, isNotNull);
  });
}
