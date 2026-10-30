import 'dart:isolate';

import 'package:drift/drift.dart';

import '../../domain/dates.dart';
import '../../domain/enums.dart';
import '../../domain/roll_up.dart';
import '../db/app_database.dart';
import '../demo_seed.dart';
import '../repositories/entries_repository.dart';
import '../repositories/periods_repository.dart';
import '../repositories/pg_supervision_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/rates_repository.dart';
import '../repositories/role_rows_repository.dart';
import 'workbook_parser.dart';

/// Thrown when an import cannot be applied (e.g. no rows for the name).
class ImportException implements Exception {
  ImportException(this.message);

  final String message;

  @override
  String toString() => 'ImportException: $message';
}

/// What an import changed.
class ImportResult {
  const ImportResult({
    required this.roleRows,
    required this.deactivatedRoleRows,
    required this.openingBalanceEntries,
  });

  final int roleRows;

  /// Role rows that were in the previous workbook but not in this one.
  final int deactivatedRoleRows;

  /// Opening-balance entries created (0 when they were kept).
  final int openingBalanceEntries;
}

/// Loads a workbook into the database (SPEC §7.2).
class ImportService {
  ImportService(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  /// Parses the workbook on a background isolate so the UI stays smooth.
  static Future<ParsedWorkbook> parse(Uint8List bytes) =>
      Isolate.run(() => parseWorkbook(bytes));

  /// Whether a real (non-demo) workbook was imported before. If so, the
  /// caller should ask before replacing opening balances.
  Future<bool> hasPreviousImport() async {
    final row =
        await (_db.select(_db.roleRows)
              ..where((r) => r.isDemo.equals(false))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Applies [parsed] for [staffName]:
  /// - demo data is removed first;
  /// - rates are replaced;
  /// - role rows are matched by (code, batch, role); rows no longer in the
  ///   workbook are deactivated, never deleted, and manual entries are kept;
  /// - opening balances are created on the first import, and replaced on a
  ///   re-import only when [replaceOpeningBalances] is true.
  Future<ImportResult> apply({
    required ParsedWorkbook parsed,
    required String staffName,
    required String academicYearLabel,
    required String fileName,
    bool replaceOpeningBalances = false,
  }) async {
    final rows = parsed.rowsFor(staffName);
    if (rows.isEmpty) {
      throw ImportException(
        'The workbook has no Data_Entry rows for "$staffName".',
      );
    }
    final name = normalizeStaffName(staffName);
    final today = isoDate(_now());
    final profiles = ProfileRepository(_db);
    final roleRows = RoleRowsRepository(_db);
    final entries = EntriesRepository(
      _db,
      PeriodsRepository(_db, now: _now),
      now: _now,
    );

    return _db.transaction(() async {
      final previousProfile = await profiles.get();
      final firstImport = !await hasPreviousImport();
      await DemoSeeder(_db, now: _now).remove();

      await profiles.save(
        ProfileCompanion.insert(
          staffName: name,
          displayName: displayNameFrom(name),
          academicYearLabel: academicYearLabel,
          workbookFileName: Value(fileName),
          importedAt: Value(_now()),
          submissionDate: Value(previousProfile?.submissionDate),
          onboardingDone: Value(previousProfile?.onboardingDone ?? false),
        ),
      );
      await RatesRepository(_db).replaceAll(parsed.rates);

      final importedIds = <int>[];
      for (final row in rows) {
        importedIds.add(
          await roleRows.upsert(
            RoleRowsCompanion.insert(
              moduleCode: row.info.moduleCode,
              batch: row.info.batch,
              moduleName: row.info.moduleName,
              moduleType: row.info.moduleType,
              credits: Value(row.credits),
              students: Value(row.info.students),
              role: row.info.role,
              sheetRow: Value(row.sheetRow),
              isActive: const Value(true),
              isDemo: const Value(false),
            ),
          ),
        );
      }

      var deactivated = 0;
      for (final existing in await roleRows.getAll()) {
        if (existing.isActive && !importedIds.contains(existing.id)) {
          await roleRows.setActive(existing.id, active: false);
          deactivated++;
        }
      }

      var openingEntries = 0;
      if (firstImport || replaceOpeningBalances) {
        await (_db.delete(
          _db.entries,
        )..where((e) => e.source.equalsValue(EntrySource.import))).go();
        final note = openingBalanceNote(fileName);
        for (final (i, row) in rows.indexed) {
          final roleRowId = importedIds[i];
          for (final entry in inputsToEntries(row.inputs)) {
            await entries.add(
              roleRowId: roleRowId,
              date: today,
              activity: entry.activity,
              subtype: entry.subtype,
              count: entry.count,
              questionsPerPaper: entry.questionsPerPaper,
              note: note,
              source: EntrySource.import,
            );
            openingEntries++;
          }
        }
      }

      await PgSupervisionRepository(_db)
          .setStudents(academicYearLabel, parsed.pgStudentsFor(name));

      return ImportResult(
        roleRows: rows.length,
        deactivatedRoleRows: deactivated,
        openingBalanceEntries: openingEntries,
      );
    });
  }
}

/// "From workbook V10.1" for "DEIE_Workload_Model_V10_1.xlsx"; otherwise
/// "From workbook".
String openingBalanceNote(String fileName) {
  final match = RegExp(
    r'V(\d+(?:[._]\d+)*)',
    caseSensitive: false,
  ).firstMatch(fileName);
  return match == null
      ? 'From workbook'
      : 'From workbook V${match.group(1)!.replaceAll('_', '.')}';
}
