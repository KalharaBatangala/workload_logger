import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/app_database.dart';

/// Work outside the workload model, and its categories. Never credited.
class OtherWorkRepository {
  OtherWorkRepository(
    this._db, {
    DateTime Function()? now,
    this._uuid = const Uuid(),
  }) : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid;

  Stream<List<OtherWorkRow>> watchRange({String? from, String? to}) =>
      (_db.select(_db.otherWork)
            ..where(
              (o) => Expression.and([
                if (from != null) o.date.isBiggerOrEqualValue(from),
                if (to != null) o.date.isSmallerOrEqualValue(to),
              ]),
            )
            ..orderBy([
              (o) => OrderingTerm.desc(o.date),
              (o) => OrderingTerm.desc(o.createdAt),
            ]))
          .watch();

  Future<String> add({
    required String date,
    required int categoryId,
    required int spentMinutes,
    String? note,
    bool isDemo = false,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.otherWork)
        .insert(
          OtherWorkCompanion.insert(
            id: id,
            date: date,
            categoryId: categoryId,
            spentMinutes: spentMinutes,
            note: Value(note),
            createdAt: _now(),
            isDemo: Value(isDemo),
          ),
        );
    return id;
  }

  Future<void> remove(String id) =>
      (_db.delete(_db.otherWork)..where((o) => o.id.equals(id))).go();

  // Categories

  SimpleSelectStatement<$OtherCategoriesTable, OtherCategory> get _categories =>
      _db.select(_db.otherCategories)
        ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]);

  Stream<List<OtherCategory>> watchCategories() => _categories.watch();

  Future<List<OtherCategory>> getCategories() => _categories.get();

  Future<int> addCategory(String name) async {
    final last = _db.otherCategories.sortOrder.max();
    final maxOrder = await (_db.selectOnly(
      _db.otherCategories,
    )..addColumns([last])).map((row) => row.read(last)).getSingle();
    return _db
        .into(_db.otherCategories)
        .insert(
          OtherCategoriesCompanion.insert(
            name: name,
            sortOrder: (maxOrder ?? -1) + 1,
          ),
        );
  }

  Future<void> renameCategory(int id, String name) =>
      (_db.update(_db.otherCategories)..where((c) => c.id.equals(id))).write(
        OtherCategoriesCompanion(name: Value(name)),
      );
}
