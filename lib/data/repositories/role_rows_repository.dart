import 'package:drift/drift.dart';

import '../../domain/role_row.dart';
import '../db/app_database.dart';

extension RoleRowDomain on RoleRow {
  /// The view of this role row that the credit maths uses.
  RoleRowInfo toInfo() => RoleRowInfo(
    moduleCode: moduleCode,
    batch: batch,
    moduleName: moduleName,
    moduleType: moduleType,
    role: role,
    students: students,
  );
}

/// The owner's role rows, in workbook order.
class RoleRowsRepository {
  RoleRowsRepository(this._db);

  final AppDatabase _db;

  Stream<List<RoleRow>> watchActive() =>
      (_db.select(_db.roleRows)
            ..where((r) => r.isActive.equals(true))
            ..orderBy([
              (r) => OrderingTerm.asc(r.sheetRow),
              (r) => OrderingTerm.asc(r.id),
            ]))
          .watch();

  Future<List<RoleRow>> getAll() => _db.select(_db.roleRows).get();

  Future<RoleRow?> byId(int id) => (_db.select(
    _db.roleRows,
  )..where((r) => r.id.equals(id))).getSingleOrNull();

  /// Inserts the row, or updates the existing row with the same
  /// (module code, batch, role) — the identity used on re-import (SPEC §7.2).
  /// Returns the row's id.
  Future<int> upsert(RoleRowsCompanion row) async {
    await _db
        .into(_db.roleRows)
        .insert(
          row,
          onConflict: DoUpdate(
            (_) => row,
            target: [
              _db.roleRows.moduleCode,
              _db.roleRows.batch,
              _db.roleRows.role,
            ],
          ),
        );
    final stored =
        await (_db.select(_db.roleRows)..where(
              (r) =>
                  r.moduleCode.equals(row.moduleCode.value) &
                  r.batch.equals(row.batch.value) &
                  r.role.equalsValue(row.role.value),
            ))
            .getSingle();
    return stored.id;
  }

  Future<void> setActive(int id, {required bool active}) =>
      (_db.update(_db.roleRows)..where((r) => r.id.equals(id))).write(
        RoleRowsCompanion(isActive: Value(active)),
      );
}
