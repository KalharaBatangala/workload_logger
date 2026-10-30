import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/date_chips.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../core/widgets/step_header.dart';
import '../../../data/providers.dart';
import '../../../domain/module_groups.dart';
import '../providers.dart';

/// Step 1 — Which module? (SPEC §8.2)
class ModuleScreen extends ConsumerWidget {
  const ModuleScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, ModuleGroup group) {
    ref.read(logFlowProvider.notifier).chooseModule(group);
    context.push(AppRoutes.logModule(group.code));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(logFlowProvider.select((s) => s.date));
    final today = ref.watch(todayProvider);
    final groups = ref.watch(moduleGroupsProvider).value;
    final recentCode = ref.watch(recentModuleCodeProvider).value;
    final recent = groups?.where((g) => g.code == recentCode).firstOrNull;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.m,
            AppSpacing.screenPadding,
            AppSpacing.xxl,
          ),
          children: [
            StepHeader(
              step: 1,
              isClose: true,
              // After "Log another" the flow is the whole stack, so there may
              // be nothing to pop back to.
              onLeading: () => context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.today),
              dateLabel: formatDayLabel(date, today: today),
              onDateTap: () async {
                final picked = await showDateSheet(
                  context,
                  selected: date,
                  today: today,
                );
                if (picked != null) {
                  ref.read(logFlowProvider.notifier).setDate(picked);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('Which module?', style: AppText.stepTitle),
            const SizedBox(height: AppSpacing.l),
            const _QuickEntryField(),
            if (recent != null) ...[
              const SizedBox(height: AppSpacing.xl),
              const SectionLabel('Recent'),
              _ModuleCard(
                group: recent,
                onTap: () => _open(context, ref, recent),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            const SectionLabel('All your modules'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (groups != null && groups.isEmpty)
                    const EmptyState(
                      message: 'No modules yet. Load your workbook in Setup.',
                    ),
                  for (final group in groups ?? const <ModuleGroup>[]) ...[
                    _ModuleRow(
                      badge: ModuleBadge(group.code),
                      title: group.name,
                      subtitle: group.subtitle,
                      onTap: () => _open(context, ref, group),
                    ),
                    const Divider(height: 1),
                  ],
                  _ModuleRow(
                    badge: const ModuleBadge(
                      'Other',
                      style: ModuleBadgeStyle.dashed,
                    ),
                    title: 'Work outside the model',
                    subtitle: 'Research, advising, committees, labs conducted',
                    onTap: () => context.push(AppRoutes.logOther),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick text entry is phase 2 (SPEC §10): shown, but disabled.
class _QuickEntryField extends StatelessWidget {
  const _QuickEntryField();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Or type: EC5208 quiz 10 questions',
              helperText: 'Coming soon',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppRadii.button),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        IconButton.filledTonal(
          tooltip: 'Voice entry (coming soon)',
          onPressed: null,
          style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
          icon: const Icon(Icons.mic_none_rounded),
        ),
      ],
    );
  }
}

/// The RECENT card: navy badge, gold border.
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.group, required this.onTap});

  final ModuleGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: AppColors.gold,
      borderWidth: 2,
      child: Row(
        children: [
          ModuleBadge(group.code, style: ModuleBadgeStyle.navy),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name, style: AppText.cardTitle),
                Text(group.subtitle, style: AppText.captionSmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
        ],
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget badge;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Align(alignment: Alignment.centerLeft, child: badge),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(subtitle, style: AppText.captionSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
