import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/entry_display.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/entry_tile.dart';
import '../../../core/widgets/segmented_choice.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../data/db/app_database.dart';
import '../../../data/providers.dart';
import '../history_items.dart';
import '../providers.dart';
import '../widgets/draft_card.dart';
import '../widgets/other_work_tile.dart';
import '../widgets/progress_card.dart';

/// History (SPEC §8.6): drafts, marking progress, and every entry by day.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _draftsOnly = false;

  void _snack(String text, VoidCallback undo) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          action: SnackBarAction(label: 'Undo', onPressed: undo),
        ),
      );
  }

  Future<void> _discard(EntryRow draft) async {
    final actions = ref.read(historyActionsProvider);
    await actions.deleteEntry(draft.id);
    _snack('Draft discarded', () => actions.undoDeleteEntry(draft.id));
  }

  Future<void> _otherWorkSheet(OtherWorkRow work, String category) async {
    final delete = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(category, style: AppText.cardTitle),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Other work is kept for your own record and never credited.',
                style: AppText.caption,
              ),
              const SizedBox(height: AppSpacing.l),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
    if (delete != true) return;
    final actions = ref.read(historyActionsProvider);
    await actions.deleteOtherWork(work);
    _snack('Other work deleted', () => actions.restoreOtherWork(work));
  }

  @override
  Widget build(BuildContext context) {
    final drafts = ref.watch(draftsProvider).value ?? const <EntryRow>[];
    final days = ref.watch(historyDaysProvider);
    final progress = ref.watch(markingProgressProvider);
    final rows = ref.watch(allRoleRowsProvider).value ?? const {};
    final categories = ref.watch(otherCategoryNamesProvider).value ?? const {};
    final rates = ref.watch(currentRatesProvider);

    Widget draftCard(EntryRow draft) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: DraftCard(
        draft: draft,
        code: rows[draft.roleRowId]?.moduleCode,
        onFinish: () => context.push(AppRoutes.editEntry(draft.id)),
        onDiscard: () => _discard(draft),
      ),
    );

    Widget entryTile(EntryRow entry) {
      final row = rows[entry.roleRowId];
      var display = describeEntry(entry, rates);
      if (row != null && !row.isActive) {
        display = EntryDisplay(
          title: display.title,
          detail: '${display.detail} · module no longer in workbook',
          credit: display.credit,
          isDraft: display.isDraft,
        );
      }
      return EntryTile(
        code: row?.moduleCode ?? '—',
        display: display,
        onTap: () => context.push(AppRoutes.editEntry(entry.id)),
      );
    }

    final children = <Widget>[
      SegmentedChoice<bool>(
        options: const [false, true],
        selected: _draftsOnly,
        labelOf: (isDrafts) =>
            isDrafts ? 'Drafts · ${drafts.length}' : 'All entries',
        onSelected: (value) => setState(() => _draftsOnly = value),
      ),
      const SizedBox(height: AppSpacing.l),
      if (_draftsOnly) ...[
        if (drafts.isEmpty)
          const EmptyState(message: 'No drafts. Everything is complete.'),
        for (final draft in drafts) draftCard(draft),
      ] else ...[
        for (final draft in drafts) draftCard(draft),
        for (final p in progress) ...[
          ProgressCard(progress: p),
          const SizedBox(height: AppSpacing.m),
        ],
        if (days.isEmpty && drafts.isEmpty)
          const EmptyState(message: 'Nothing logged yet.'),
        for (final day in days) ...[
          const SizedBox(height: AppSpacing.s),
          SectionLabel(day.header),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, item) in day.items.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  switch (item) {
                    EntryItem(:final entry) => entryTile(entry),
                    OtherWorkItem(:final work) => OtherWorkTile(
                      work: work,
                      category: categories[work.categoryId] ?? 'Other work',
                      onTap: () => _otherWorkSheet(
                        work,
                        categories[work.categoryId] ?? 'Other work',
                      ),
                    ),
                  },
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ],
    ];

    return TabPage(title: 'History', children: children);
  }
}
