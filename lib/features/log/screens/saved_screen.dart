import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../data/providers.dart';
import '../../../domain/credit_calculator.dart';
import '../../../domain/enums.dart';
import '../credit_explanation.dart';
import '../providers.dart';

/// Shown after saving (SPEC §8.5).
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  Future<void> _undo(BuildContext context, WidgetRef ref) async {
    final state = ref.read(logFlowProvider);
    final code = state.moduleCode;
    final moderation = state.activity == Activity.moderationDone;
    await ref.read(logFlowProvider.notifier).undo();
    if (!context.mounted || code == null) return;
    context.go(
      moderation ? AppRoutes.logModule(code) : AppRoutes.logDetails(code),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logFlowProvider);
    final rates = ref.watch(currentRatesProvider);
    final today = ref.watch(todayProvider);
    final totals = ref.watch(totalsProvider).value;
    final saved = state.saved;
    final activity = state.activity;

    if (saved == null || activity == null) {
      return const Scaffold(backgroundColor: AppColors.navy);
    }

    final credit = state.creditWith(rates);
    final moderation = activity == Activity.moderationDone;
    final (headline, caption) = switch ((saved.isDraft, moderation)) {
      (true, _) => ('Saved as draft', 'Finish it later in History'),
      (_, true) => (
        'Moderation recorded',
        'Moderator hours are credited automatically',
      ),
      _ => (
        formatCredit(credit),
        'credited to ${categoryOf(activity)?.label ?? 'your workload'}',
      ),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.today);
      },
      child: Scaffold(
        backgroundColor: AppColors.navy,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: AppColors.navyDeep,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: AppText.display.copyWith(
                    fontSize: saved.isDraft || moderation ? 30 : 44,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: AppText.body.copyWith(color: AppColors.cream),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _DetailCard(
                  code: state.moduleCode ?? '',
                  name: state.roleRow?.moduleName ?? '',
                  summary: entrySummary(
                    state,
                    dayLabel: formatDayLabel(state.date, today: today),
                  ),
                  comparison: saved.isDraft || credit == 0
                      ? null
                      : _comparison(state.spentMinutes, credit),
                ),
                const SizedBox(height: AppSpacing.l),
                Row(
                  children: [
                    _Stat(value: totals?.today, label: 'today'),
                    const SizedBox(width: AppSpacing.s),
                    _Stat(value: totals?.week, label: 'this week'),
                    const SizedBox(width: AppSpacing.s),
                    _Stat(value: totals?.year.total.total, label: 'this year'),
                  ],
                ),
                const Spacer(flex: 2),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: () => context.go(AppRoutes.today),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.navyDeep,
                    ),
                    child: const Text('Done'),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(logFlowProvider.notifier).restart();
                      context.go(AppRoutes.log);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.onNavyBorder),
                    ),
                    child: const Text('Log another'),
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                TextButton(
                  onPressed: () => _undo(context, ref),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.onNavyMuted,
                  ),
                  child: const Text('Undo'),
                ),
                const SizedBox(height: AppSpacing.m),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// "You spent 1 h; the model credits 1.0 h. The rate matches your real
  /// time." — within ±25 % counts as matching (SPEC §8.5).
  static String? _comparison(int? spentMinutes, double credit) {
    if (spentMinutes == null) return null;
    final spent = spentMinutes / 60;
    final ratio = spent / credit;
    final verdict = ratio > 1.25
        ? 'This took longer than the model assumes.'
        : ratio < 0.75
        ? 'This took less time than the model assumes.'
        : 'The rate matches your real time.';
    return 'You spent ${formatMinutes(spentMinutes)}; the model credits '
        '${formatHours(credit)}. $verdict';
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.code,
    required this.name,
    required this.summary,
    this.comparison,
  });

  final String code;
  final String name;
  final String summary;
  final String? comparison;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.onNavyCard,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.onNavyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ModuleBadge(code, style: ModuleBadgeStyle.gold),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  name,
                  style: AppText.body.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            summary,
            style: AppText.bodySmall.copyWith(color: AppColors.onNavyMuted),
          ),
          if (comparison != null) ...[
            const SizedBox(height: AppSpacing.m),
            const Divider(color: AppColors.onNavyBorder),
            const SizedBox(height: AppSpacing.s),
            Text(
              comparison!,
              style: AppText.bodySmall.copyWith(color: AppColors.surface),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final double? value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        decoration: BoxDecoration(
          color: AppColors.onNavyCard,
          borderRadius: BorderRadius.circular(AppRadii.buttonSmall),
        ),
        child: Column(
          children: [
            Text(
              value == null ? '–' : formatHours(value!),
              style: AppText.cardTitle.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: AppText.captionSmall.copyWith(
                color: AppColors.onNavyMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
