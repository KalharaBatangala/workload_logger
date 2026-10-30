import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/entry_display.dart';
import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/entry_tile.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../data/providers.dart';
import '../../../domain/enums.dart';

import '../providers.dart';
import '../widgets/quick_log_chips.dart';
import '../widgets/timetable_card_view.dart';
import '../widgets/zero_rows_nudge.dart';

/// Today, the home tab (SPEC §8.1).
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  static String greetingFor(DateTime now) => now.hour < 12
      ? 'Good morning'
      : now.hour < 17
      ? 'Good afternoon'
      : 'Good evening';

  Future<void> _yes(
    BuildContext context,
    WidgetRef ref,
    TimetableCard card,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(todayActionsProvider);
    final yes = await actions.answerYes(card);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          card.isLab
              ? 'Saved ${formatCount(card.hours)} h lab as other work'
              : 'Logged ${formatCount(card.hours)} h lecture',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => actions.undoYes(yes),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(todayProvider); // rebuild when the day changes
    final now = ref.watch(clockProvider)();
    final profile = ref.watch(profileProvider).value;
    final totals = ref.watch(totalsProvider).value;
    final entries = ref.watch(todayLoggedEntriesProvider).value ?? const [];
    final cards = ref.watch(timetableCardsProvider).value ?? const [];
    final codes = ref.watch(quickLogCodesProvider);
    final zeroRows = ref.watch(zeroRowsProvider);
    final rows = ref.watch(roleRowsByIdProvider);
    final rates = ref.watch(currentRatesProvider);
    final completeToday = entries
        .where((e) => e.status == EntryStatus.complete)
        .length;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.l,
          AppSpacing.screenPadding,
          MediaQuery.paddingOf(context).bottom + AppSpacing.xxl,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM').format(now),
                      style: AppText.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${greetingFor(now)}, ${profile?.displayName ?? ''}',
                      style: AppText.greeting,
                    ),
                  ],
                ),
              ),
              IconButton.outlined(
                tooltip: 'Reminder settings',
                onPressed: () => context.go(AppRoutes.setup),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  minimumSize: const Size(48, 48),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                ),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          HeroCard(
            overline: 'Credited today',
            value: (totals?.today ?? 0).toStringAsFixed(1),
            unit: 'hours',
            cornerNote: completeToday == 1
                ? '1 entry'
                : '$completeToday entries',
            stats: [
              (value: formatHours(totals?.week ?? 0), label: 'this week'),
              (
                value: formatHours(totals?.year.total.total ?? 0),
                label: 'this academic year',
              ),
            ],
          ),
          for (final card in cards) ...[
            const SizedBox(height: AppSpacing.section),
            TimetableCardView(
              card: card,
              onYes: () => _yes(context, ref, card),
              onOtherHours: card.isLab
                  ? null
                  : () => context.push(
                      AppRoutes.logLecture(card.row.moduleCode, card.row.id),
                    ),
              onNo: () => ref.read(todayActionsProvider).answerNo(card),
            ),
          ],
          const SizedBox(height: AppSpacing.section),
          Row(
            children: [
              const Expanded(
                child: Text('Logged today', style: AppText.section),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.history),
                child: const Text('See all'),
              ),
            ],
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: entries.isEmpty
                ? const EmptyState(message: 'Nothing logged yet today.')
                : Column(
                    children: [
                      for (final (i, entry) in entries.indexed) ...[
                        if (i > 0) const Divider(height: 1),
                        EntryTile(
                          code: rows[entry.roleRowId]?.moduleCode ?? '—',
                          display: describeEntry(entry, rates),
                          onTap: () =>
                              context.push(AppRoutes.editEntry(entry.id)),
                        ),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.section),
          const Text('Quick log', style: AppText.section),
          const SizedBox(height: AppSpacing.m),
          QuickLogChips(
            codes: codes,
            onCode: (code) => context.push(AppRoutes.logModule(code)),
            onAll: () => context.push(AppRoutes.log),
          ),
          if (zeroRows.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.section),
            ZeroRowsNudge(
              rows: zeroRows,
              onTap: () => context.go(AppRoutes.summary),
            ),
          ],
        ],
      ),
    );
  }
}
