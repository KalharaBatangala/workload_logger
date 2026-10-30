import 'dart:typed_data';

import '../../core/activity_labels.dart';
import '../../domain/credit_calculator.dart';
import '../../domain/dates.dart';
import '../../domain/enums.dart';
import '../../domain/rates.dart';
import '../db/app_database.dart';
import '../period_report.dart';
import '../repositories/entries_repository.dart';
import '../repositories/other_work_repository.dart';
import '../repositories/periods_repository.dart';
import '../repositories/pg_supervision_repository.dart';
import '../repositories/photos_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/rates_repository.dart';
import '../repositories/role_rows_repository.dart';
import 'export_builder.dart';

/// Hands a finished file to the user (write + share sheet). Replaced in
/// tests to capture the bytes.
typedef ExportSink = Future<void> Function(String fileName, Uint8List bytes);

/// Produces the export files for a period (SPEC §7.3).
class ExportService {
  ExportService(this._db, this._sink, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final ExportSink _sink;
  final DateTime Function() _now;

  /// "Workload_Mr_Kalhara_Batangala_2026-10-29.xlsx": all four sheets.
  Future<String> exportWorkload(ReportPeriod period) async {
    final data = await _gather(period);
    final fileName = _fileName('Workload', data.staffName);
    await _sink(
      fileName,
      buildWorkloadWorkbook(
        staffName: data.staffName,
        periodLabel: period.label,
        exportedOn: isoDate(_now()),
        rows: [
          for (final report in data.report)
            ExportRoleRow(
              info: report.row.toInfo(),
              staffName: data.staffName,
              credits: report.row.credits,
              inputs: report.inputs,
              hours: report.hours,
            ),
        ],
        evidence: data.evidence,
        otherWork: data.otherWork,
        pg: PgLine(
          academicYear: data.academicYear,
          students: data.pgStudents,
          hours: pgSupervisionHours(data.pgStudents, data.rates),
        ),
      ),
    );
    return fileName;
  }

  /// "Evidence_Mr_Kalhara_Batangala_2026-10-29.xlsx": every entry.
  Future<String> exportEvidence(ReportPeriod period) async {
    final data = await _gather(period);
    final fileName = _fileName('Evidence', data.staffName);
    await _sink(fileName, buildEvidenceWorkbook(data.evidence));
    return fileName;
  }

  String _fileName(String kind, String staffName) {
    final safe = staffName
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return '${kind}_${safe}_${isoDate(_now())}.xlsx';
  }

  Future<_ExportData> _gather(ReportPeriod period) async {
    final profile = await ProfileRepository(_db).get();
    final rates = await RatesRepository(_db).getRateSet();
    final rows = await RoleRowsRepository(_db).getAll();
    final byId = {for (final r in rows) r.id: r};
    final entries =
        (await EntriesRepository(_db, PeriodsRepository(_db)).getRange(
          from: period.from,
          to: period.to,
        )).where((e) => e.status == EntryStatus.complete).toList();
    final photos = await PhotosRepository(_db).countsByEntry();
    final otherWorkRepo = OtherWorkRepository(_db);
    final categories = {
      for (final c in await otherWorkRepo.getCategories()) c.id: c.name,
    };
    final other = await otherWorkRepo.getRange(
      from: period.from,
      to: period.to,
    );
    final year = profile?.academicYearLabel ?? period.label;

    // Oldest first reads naturally in a spreadsheet.
    final ordered = [...entries]
      ..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        return byDate != 0 ? byDate : a.createdAt.compareTo(b.createdAt);
      });

    return _ExportData(
      staffName: profile?.staffName ?? 'Unknown',
      academicYear: year,
      rates: rates,
      report: buildPeriodReport(rows, entries, rates),
      evidence: [
        for (final e in ordered)
          _evidence(e, byId[e.roleRowId], rates, photos[e.id] ?? 0),
      ],
      otherWork: [
        for (final o in other.reversed)
          OtherWorkLine(
            date: o.date,
            category: categories[o.categoryId] ?? '',
            note: o.note ?? '',
          ),
      ],
      pgStudents: await PgSupervisionRepository(_db).students(year),
    );
  }

  EvidenceLine _evidence(EntryRow e, RoleRow? row, RateSet rates, int photos) {
    double credited;
    try {
      credited = entryCredit(e.toInput(), rates);
    } on ArgumentError {
      credited = 0;
    }
    final logged = e.createdAt.toLocal();
    return EvidenceLine(
      date: e.date,
      module: row?.moduleCode ?? '',
      batch: row?.batch ?? '',
      role: row?.role.workbookLabel ?? '',
      activity: ActivityLabels.title(e.activity),
      type: e.subtype == null ? '' : ActivityLabels.subtype(e.subtype!),
      count: e.count,
      questionsPerPaper: e.questionsPerPaper,
      credited: credited,
      note: e.note ?? '',
      photos: photos,
      loggedAt:
          '${isoDate(logged)} '
          '${logged.hour.toString().padLeft(2, '0')}:'
          '${logged.minute.toString().padLeft(2, '0')}',
    );
  }
}

class _ExportData {
  const _ExportData({
    required this.staffName,
    required this.academicYear,
    required this.rates,
    required this.report,
    required this.evidence,
    required this.otherWork,
    required this.pgStudents,
  });

  final String staffName;
  final String academicYear;
  final RateSet rates;
  final List<RoleRowReport> report;
  final List<EvidenceLine> evidence;
  final List<OtherWorkLine> otherWork;
  final int pgStudents;
}
