import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/messenger.dart';
import '../../core/widgets/input_dialogs.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../data/workbook/workbook_parser.dart';
import '../../data/workbook/xlsx_reader.dart';
import '../../domain/dates.dart';
import '../../domain/enums.dart';
import '../onboarding/providers.dart'
    show parseWorkbookProvider, pickWorkbookProvider;
import '../reminders/providers.dart';
import 'providers.dart';
import 'widgets/slot_sheet.dart';

/// The Setup screen's actions. Each opens what it needs (pickers, dialogs)
/// and then writes through the repositories.
class SetupActions {
  SetupActions(this.ref);

  final WidgetRef ref;

  void _say(String text, {SnackBarAction? action}) => ref
      .read(scaffoldMessengerKeyProvider)
      .currentState
      ?.showSnackBar(SnackBar(content: Text(text), action: action));

  // -------------------------------------------------------------------------
  // Workload file

  /// "Load a newer workbook" (SPEC §7.2 step 5).
  Future<void> loadNewerWorkbook(BuildContext context) async {
    final picked = await ref.read(pickWorkbookProvider)();
    if (picked == null) return;

    final ParsedWorkbook parsed;
    try {
      parsed = await ref.read(parseWorkbookProvider)(picked.bytes);
    } on WorkbookFormatException catch (e) {
      _say(e.message);
      return;
    } on XlsxFormatException catch (e) {
      _say(e.message);
      return;
    }

    final profile = await ref.read(profileRepositoryProvider).get();
    final staff = profile?.staffName;
    if (staff == null || parsed.rowsFor(staff).isEmpty) {
      _say('${staff ?? 'You'} is not in this workbook\'s Data_Entry sheet.');
      return;
    }

    final importer = ref.read(importServiceProvider);
    var replace = false;
    if (await importer.hasPreviousImport()) {
      if (!context.mounted) return;
      final answer = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Replace opening balances?'),
          content: const Text(
            'The workbook may hold newer values than when you first loaded '
            'it. Replace the opening balances with this workbook\'s values? '
            'Work you logged in the app is kept either way.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Replace'),
            ),
          ],
        ),
      );
      if (answer == null) return;
      replace = answer;
    }

    final result = await importer.apply(
      parsed: parsed,
      staffName: staff,
      academicYearLabel: profile!.isDemo
          ? (parsed.academicYearHint ?? profile.academicYearLabel)
          : profile.academicYearLabel,
      fileName: picked.name,
      replaceOpeningBalances: replace,
    );
    final gone = result.deactivatedRoleRows;
    _say(
      'Workbook loaded: ${result.roleRows} role rows'
      '${gone == 0 ? '' : ' · $gone no longer in it'}',
    );
  }

  // -------------------------------------------------------------------------
  // Timetable

  Future<void> editSlot(
    BuildContext context,
    List<RoleRow> teacherRows, [
    TimetableSlot? slot,
  ]) async {
    final result = await showSlotSheet(
      context,
      teacherRows: teacherRows,
      slot: slot,
    );
    final repo = ref.read(timetableRepositoryProvider);
    switch (result) {
      case null:
        return;
      case SlotDeleted() when slot != null:
        await repo.remove(slot.id);
        _say(
          'Class slot deleted',
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => repo.add(
              roleRowId: slot.roleRowId,
              kind: slot.kind,
              weekday: slot.weekday,
              startTime: slot.startTime,
              endTime: slot.endTime,
            ),
          ),
        );
      case SlotDeleted():
        return;
      case final SlotSaved s when slot != null:
        await repo.save(
          slot.copyWith(
            roleRowId: s.roleRowId,
            kind: s.kind,
            weekday: s.weekday,
            startTime: s.startTime,
            endTime: s.endTime,
          ),
        );
      case final SlotSaved s:
        await repo.add(
          roleRowId: s.roleRowId,
          kind: s.kind,
          weekday: s.weekday,
          startTime: s.startTime,
          endTime: s.endTime,
        );
    }
  }

  // -------------------------------------------------------------------------
  // Reminders

  Future<void> setReminderEnabled(
    BuildContext context,
    ReminderSetting setting,
    bool enabled,
  ) async {
    if (enabled) {
      final allowed = await ref
          .read(notificationServiceProvider)
          .requestPermission();
      ref.invalidate(notificationsAllowedProvider);
      if (!allowed) {
        _say('Notifications are off for this app in Android settings.');
      }
      if (setting.key == ReminderKind.submission) {
        final profile = await ref.read(profileRepositoryProvider).get();
        if (profile?.submissionDate == null) {
          if (!context.mounted) return;
          await editSubmissionDate(context);
        }
      }
    }
    await ref
        .read(reminderSettingsRepositoryProvider)
        .save(setting.copyWith(enabled: enabled));
  }

  /// Tapping a reminder's text: its time (and the day, for the weekly one;
  /// the date, for the submission one).
  Future<void> editReminder(BuildContext context, ReminderSetting s) async {
    if (s.key == ReminderKind.submission) {
      final profile = await ref.read(profileRepositoryProvider).get();
      if (!context.mounted) return;
      final choice = await showModalBottomSheet<String>(
        context: context,
        // Above the bottom bar, not inside the tab.
        useRootNavigator: true,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.event_outlined),
                title: const Text('Change submission date'),
                onTap: () => Navigator.pop(context, 'date'),
              ),
              ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('Change reminder time'),
                onTap: () => Navigator.pop(context, 'time'),
              ),
              if (profile?.submissionDate != null)
                ListTile(
                  leading: const Icon(Icons.event_busy_outlined),
                  title: const Text('Clear submission date'),
                  onTap: () => Navigator.pop(context, 'clear'),
                ),
            ],
          ),
        ),
      );
      if (!context.mounted) return;
      switch (choice) {
        case 'date':
          await editSubmissionDate(context);
          return;
        case 'clear':
          await clearSubmissionDate();
          return;
        case 'time':
          break; // fall through to the time picker below
        default:
          return;
      }
    }
    if (!context.mounted) return;
    final parts = s.time.split(':');
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (time == null) return;
    var weekday = s.weekday;
    if (s.key == ReminderKind.weekly) {
      if (!context.mounted) return;
      weekday =
          await showDialog<int>(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text('Which day?'),
              children: [
                for (var d = 1; d <= 7; d++)
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, d),
                    child: Text(weekdayNames[d - 1]),
                  ),
              ],
            ),
          ) ??
          weekday;
    }
    await ref
        .read(reminderSettingsRepositoryProvider)
        .save(
          s.copyWith(
            time:
                '${time.hour.toString().padLeft(2, '0')}:'
                '${time.minute.toString().padLeft(2, '0')}',
            weekday: Value(weekday),
          ),
        );
  }

  // -------------------------------------------------------------------------
  // More

  Future<void> editSubmissionDate(BuildContext context) async {
    final profile = await ref.read(profileRepositoryProvider).get();
    if (!context.mounted) return;
    final today = parseIsoDate(ref.read(todayProvider));
    final current = profile?.submissionDate;
    final picked = await showDatePicker(
      context: context,
      helpText: 'Submission date',
      initialDate: current == null ? today : parseIsoDate(current),
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 2),
    );
    if (picked != null) {
      await ref
          .read(profileRepositoryProvider)
          .setSubmissionDate(isoDate(picked));
    }
  }

  Future<void> clearSubmissionDate() =>
      ref.read(profileRepositoryProvider).setSubmissionDate(null);

  Future<void> editPgStudents(BuildContext context, int current) async {
    final profile = await ref.read(profileRepositoryProvider).get();
    if (profile == null || !context.mounted) return;
    final value = await showDialog<double>(
      context: context,
      builder: (context) => NumberDialog(
        label: 'PG students supervised in ${profile.academicYearLabel}',
        initial: '$current',
      ),
    );
    if (value == null) return;
    await ref
        .read(pgSupervisionRepositoryProvider)
        .setStudents(profile.academicYearLabel, value.round());
  }

  Future<void> removeDemoData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove demo data?'),
        content: const Text(
          'The demo role rows, entries, timetable and other work are deleted, '
          'including anything you logged against demo modules.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // With no profile left, the router returns to onboarding by itself.
    await ref.read(demoSeederProvider).remove();
    _say('Demo data removed');
  }

  Future<void> addCategory(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const TextDialog(label: 'New category'),
    );
    if (name != null) {
      await ref.read(otherWorkRepositoryProvider).addCategory(name);
    }
  }

  Future<void> renameCategory(
    BuildContext context,
    OtherCategory category,
  ) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) =>
          TextDialog(label: 'Rename category', initial: category.name),
    );
    if (name != null) {
      await ref
          .read(otherWorkRepositoryProvider)
          .renameCategory(category.id, name);
    }
  }
}
