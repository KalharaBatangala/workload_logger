import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/toggle_row.dart';
import '../../../data/db/app_database.dart';
import '../../../data/providers.dart';
import '../../../domain/enums.dart';
import '../../reminders/providers.dart';
import '../providers.dart';
import '../setup_actions.dart';

/// App version shown in About.
const appVersion = '1.0.0';

/// Setup (SPEC §8.8). The BACKUP section of the design is phase 2 (SPEC §15)
/// and is not shown.
class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = SetupActions(ref);
    final profile = ref.watch(profileProvider).value;
    final rows = ref.watch(roleRowsProvider).value ?? const <RoleRow>[];
    final rates = ref.watch(currentRatesProvider);
    final slots = ref.watch(timetableSlotsProvider).value ?? const [];
    final reminders = ref.watch(reminderSettingsProvider).value ?? const {};
    final pg = ref.watch(pgStudentsProvider).value ?? 0;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final hasDemo = ref.watch(hasDemoDataProvider).value ?? false;
    final allowed = ref.watch(notificationsAllowedProvider).value ?? true;
    final byId = {for (final r in rows) r.id: r};
    final teacherRows = rows.where((r) => r.role == Role.teacher).toList();
    // Demo data uses the SPEC defaults on purpose: no warning for those.
    final defaults = (profile?.isDemo ?? false) ? 0 : defaultRateCount(rates);

    return TabPage(
      title: 'Setup',
      children: [
        const SectionLabel('Workload file'),
        AppCard(
          onTap: () => context.push(AppRoutes.setupRates),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(AppRadii.buttonSmall),
                    ),
                    child: const Icon(
                      Icons.table_chart_outlined,
                      color: AppColors.cream,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.isDemo ?? false
                              ? 'Demo data'
                              : profile?.workbookFileName ?? 'No workbook',
                          style: AppText.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${rows.length} role rows for you · rates from '
                          'Admin_Config'
                          '${defaults == 0 ? '' : ' · $defaults use defaults'}',
                          style: AppText.captionSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              OutlinedButton(
                onPressed: () => actions.loadNewerWorkbook(context),
                child: const Text('Load a newer workbook'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionLabel('My timetable'),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final slot in slots) ...[
                _SlotRow(
                  slot: slot,
                  code: byId[slot.roleRowId]?.moduleCode ?? '—',
                  onTap: () => actions.editSlot(context, teacherRows, slot),
                ),
                const Divider(height: 1),
              ],
              TextButton.icon(
                onPressed: () => actions.editSlot(context, teacherRows),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add a class slot'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionLabel('Reminders'),
        if (!allowed) ...[
          AppCard(
            color: AppColors.goldTint,
            borderColor: AppColors.goldBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Notifications are off for this app. If nothing happens '
                  'below, allow them in Android Settings → Apps → '
                  'Workload Logger → Notifications.',
                  style: AppText.bodySmall.copyWith(
                    color: AppColors.goldTextDeep,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                OutlinedButton(
                  onPressed: () async {
                    await ref
                        .read(notificationServiceProvider)
                        .requestPermission();
                    ref.invalidate(notificationsAllowedProvider);
                  },
                  child: const Text('Allow notifications'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (i, kind) in ReminderKind.values.indexed)
                if (reminders[kind] case final setting?) ...[
                  if (i > 0) const Divider(height: 1),
                  ToggleRow(
                    title: reminderTitle(kind),
                    subtitle: reminderSubtitle(
                      setting,
                      submissionDate: profile?.submissionDate,
                    ),
                    value: setting.enabled,
                    onChanged: (on) =>
                        actions.setReminderEnabled(context, setting, on),
                    onTapText: () => actions.editReminder(context, setting),
                  ),
                ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionLabel('More'),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MoreRow(
                title: 'Postgraduate supervision',
                value: pg == 1 ? '1 student' : '$pg students',
                onTap: () => actions.editPgStudents(context, pg),
              ),
              const Divider(height: 1),
              _MoreRow(
                title: 'Other-work categories',
                value: '${categories.length}',
                onTap: () => context.push(AppRoutes.setupCategories),
              ),
              const Divider(height: 1),
              _MoreRow(
                title: 'Submission date',
                value: profile?.submissionDate == null
                    ? 'Not set'
                    : formatShortDate(profile!.submissionDate!),
                onTap: () => actions.editSubmissionDate(context),
                onLongPress: profile?.submissionDate == null
                    ? null
                    : actions.clearSubmissionDate,
              ),
              if (hasDemo) ...[
                const Divider(height: 1),
                _MoreRow(
                  title: 'Remove demo data',
                  onTap: () => actions.removeDemoData(context),
                ),
              ],
              const Divider(height: 1),
              _MoreRow(
                title: 'About',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Workload Logger',
                  applicationVersion: appVersion,
                  applicationLegalese:
                      'Your data stays on this phone; nothing is sent '
                      'anywhere. Built for the DEIE Workload Model, '
                      'University of Ruhuna.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({required this.slot, required this.code, required this.onTap});

  final TimetableSlot slot;
  final String code;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final day = weekdayNames[slot.weekday - 1].substring(0, 3);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: Row(
            children: [
              ModuleBadge(code),
              const SizedBox(width: AppSpacing.m),
              // Stacked, so long times never overflow at large text sizes.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot.kind == SlotKind.lecture ? 'Lecture' : 'Lab',
                        style: AppText.body,
                      ),
                      Text(
                        '$day ${slot.startTime} – ${slot.endTime}',
                        style: AppText.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreRow extends StatelessWidget {
  const _MoreRow({
    required this.title,
    required this.onTap,
    this.value,
    this.onLongPress,
  });

  final String title;
  final String? value;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: Row(
            children: [
              Expanded(child: Text(title, style: AppText.body)),
              if (value != null) Text(value!, style: AppText.caption),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
