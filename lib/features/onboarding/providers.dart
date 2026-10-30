import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../data/workbook/import_service.dart';
import '../../data/workbook/workbook_parser.dart';
import '../../data/workbook/xlsx_reader.dart';
import '../../domain/dates.dart';
import '../../domain/enums.dart';
import '../../domain/roll_up.dart';
import '../../domain/summary.dart';
import '../reminders/providers.dart';

/// A picked file: its name and contents. Null when the user cancels.
typedef PickedWorkbook = ({String name, Uint8List bytes});

/// Opens the system file picker for an .xlsx. Overridden in tests.
final pickWorkbookProvider = Provider<Future<PickedWorkbook?> Function()>(
  (ref) => () async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['xlsx'],
    );
    if (file == null) return null;
    return (name: file.name, bytes: await file.readAsBytes());
  },
);

/// Parses a workbook (on a background isolate). Overridden in tests, where
/// isolates do not run inside the fake clock.
final parseWorkbookProvider =
    Provider<Future<ParsedWorkbook> Function(Uint8List)>(
      (ref) => ImportService.parse,
    );

/// What the user will get from the chosen name (SPEC §7.2 step 3).
class ImportPreview {
  const ImportPreview({
    required this.staffName,
    required this.roleRows,
    required this.openingHours,
    required this.skippedRows,
    required this.rateWarnings,
  });

  final String staffName;
  final int roleRows;

  /// Hours already in the workbook for this person.
  final double openingHours;
  final List<SkippedRow> skippedRows;
  final List<String> rateWarnings;
}

class OnboardingState {
  const OnboardingState({
    this.fileName,
    this.workbook,
    this.isBusy = false,
    this.error,
    this.selectedName,
    this.academicYearLabel = '',
  });

  final String? fileName;
  final ParsedWorkbook? workbook;

  /// Reading the file or saving the import.
  final bool isBusy;

  /// A plain-language problem to show, e.g. "This is not an .xlsx file."
  final String? error;
  final String? selectedName;
  final String academicYearLabel;

  OnboardingState copyWith({
    String? fileName,
    ParsedWorkbook? workbook,
    bool? isBusy,
    String? Function()? error,
    String? Function()? selectedName,
    String? academicYearLabel,
  }) => OnboardingState(
    fileName: fileName ?? this.fileName,
    workbook: workbook ?? this.workbook,
    isBusy: isBusy ?? this.isBusy,
    error: error == null ? this.error : error(),
    selectedName: selectedName == null ? this.selectedName : selectedName(),
    academicYearLabel: academicYearLabel ?? this.academicYearLabel,
  );

  /// Preview for the selected name, or null if none is selected.
  ImportPreview? get preview {
    final workbook = this.workbook;
    final name = selectedName;
    if (workbook == null || name == null) return null;
    final rows = workbook.rowsFor(name);
    final summary = summarize(
      {for (final row in rows) row.sheetRow: row.info},
      {for (final row in rows) row.sheetRow: inputsToEntries(row.inputs)},
      workbook.rates,
    );
    return ImportPreview(
      staffName: name,
      roleRows: rows.length,
      openingHours: summary.total.total,
      skippedRows: workbook.skippedFor(name),
      rateWarnings: workbook.rateWarnings,
    );
  }
}

/// Drives the first-run screens (SPEC §8.9).
class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  /// Lets the user pick a workbook and reads it. Returns true when the
  /// workbook was read and the name step can follow.
  Future<bool> pickWorkbook() async {
    final picked = await ref.read(pickWorkbookProvider)();
    if (picked == null) return false;
    return loadWorkbook(picked.name, picked.bytes);
  }

  Future<bool> loadWorkbook(String fileName, Uint8List bytes) async {
    state = state.copyWith(isBusy: true, error: () => null);
    try {
      final workbook = await ref.read(parseWorkbookProvider)(bytes);
      final now = ref.read(clockProvider)();
      state = OnboardingState(
        fileName: fileName,
        workbook: workbook,
        academicYearLabel:
            workbook.academicYearHint ?? suggestedAcademicYearLabel(now),
      );
      return true;
    } on WorkbookFormatException catch (e) {
      state = state.copyWith(isBusy: false, error: () => e.message);
    } on XlsxFormatException catch (e) {
      state = state.copyWith(isBusy: false, error: () => e.message);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        error: () => 'The workbook could not be read.',
      );
    }
    return false;
  }

  void selectName(String name) =>
      state = state.copyWith(selectedName: () => name);

  void setAcademicYear(String label) =>
      state = state.copyWith(academicYearLabel: label.trim());

  /// Saves the import for the selected name. Returns true on success.
  Future<bool> confirmImport() async {
    final workbook = state.workbook;
    final name = state.selectedName;
    if (workbook == null || name == null) return false;
    state = state.copyWith(isBusy: true, error: () => null);
    try {
      await ref
          .read(importServiceProvider)
          .apply(
            parsed: workbook,
            staffName: name,
            academicYearLabel: state.academicYearLabel.isEmpty
                ? suggestedAcademicYearLabel(ref.read(clockProvider)())
                : state.academicYearLabel,
            fileName: state.fileName ?? 'workbook.xlsx',
          );
      state = state.copyWith(isBusy: false);
      return true;
    } on ImportException catch (e) {
      state = state.copyWith(isBusy: false, error: () => e.message);
      return false;
    }
  }

  /// Loads the demo data instead of a workbook.
  Future<void> startDemo() async {
    state = state.copyWith(isBusy: true, error: () => null);
    await ref.read(demoSeederProvider).seed();
    state = state.copyWith(isBusy: false);
  }

  /// Saves the evening reminder time and finishes onboarding.
  Future<void> finish({required String eveningTime}) async {
    final reminders = ref.read(reminderSettingsRepositoryProvider);
    final evening = await reminders.byKey(ReminderKind.evening);
    await reminders.save(
      evening?.copyWith(time: eveningTime) ??
          ReminderSetting(
            key: ReminderKind.evening,
            enabled: true,
            time: eveningTime,
          ),
    );
    // Android 13+ asks the user; refusing is fine (Setup explains how to
    // turn notifications on later).
    await ref.read(notificationServiceProvider).requestPermission();
    await ref.read(profileRepositoryProvider).setOnboardingDone();
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
      OnboardingController.new,
    );

/// The saved evening reminder time (default 20:30) for the last step.
final eveningReminderTimeProvider = StreamProvider<String>(
  (ref) => ref
      .watch(reminderSettingsRepositoryProvider)
      .watchAll()
      .map((all) => all[ReminderKind.evening]?.time ?? '20:30'),
);
