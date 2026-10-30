import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/activity_tile.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/date_chips.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../core/widgets/step_header.dart';
import '../../../data/providers.dart';
import '../../../domain/activity_catalogue.dart';
import '../../../domain/credit_calculator.dart';
import '../../../domain/enums.dart';
import '../../../domain/module_groups.dart';
import '../../../domain/rates.dart';
import '../activity_labels.dart';
import '../providers.dart';

/// Step 2 — What did you do? (SPEC §8.3)
class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key, required this.code});

  final String code;

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  bool _showMore = false;

  Future<void> _choose(IdentifiedRow row, ActivityOption option) async {
    final flow = ref.read(logFlowProvider.notifier);
    if (option.activity == Activity.moderationDone) {
      final ok = await flow.logModeration(roleRowId: row.id, roleRow: row.info);
      if (ok && mounted) context.go(AppRoutes.logSaved);
      return;
    }
    await flow.chooseActivity(
      roleRowId: row.id,
      roleRow: row.info,
      option: option,
    );
    if (mounted) context.push(AppRoutes.logDetails(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logFlowProvider);
    final today = ref.watch(todayProvider);
    final rates = ref.watch(currentRatesProvider);
    final groups = ref.watch(moduleGroupsProvider).value ?? const [];
    final group = groups.where((g) => g.code == widget.code).firstOrNull;
    final likely = ref.watch(likelyActivityProvider(widget.code)).value;

    if (group == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Opened directly (e.g. a quick-log chip on Today): adopt this module.
    if (state.moduleCode != group.code) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(logFlowProvider.notifier).chooseModule(group);
      });
    }
    final batch = state.moduleCode == group.code ? state.batch : null;
    final rows = batch == null
        ? const <IdentifiedRow>[]
        : group.rowsForBatch(batch);
    final roles = rows.map((r) => r.info.role).toSet();

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
              step: 2,
              onLeading: () => context.pop(),
              dateLabel: formatDayLabel(state.date, today: today),
              onDateTap: () async {
                final picked = await showDateSheet(
                  context,
                  selected: state.date,
                  today: today,
                );
                if (picked != null) {
                  ref.read(logFlowProvider.notifier).setDate(picked);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('What did you do?', style: AppText.stepTitle),
            const SizedBox(height: AppSpacing.l),
            _ModuleStrip(
              group: group,
              rows: rows,
              batch: batch,
              onChange: () => context.pop(),
            ),
            if (group.batches.length > 1) ...[
              const SizedBox(height: AppSpacing.l),
              const SectionLabel('Which batch?'),
              Row(
                children: [
                  for (final (i, b) in group.batches.indexed) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: _BatchChip(
                        label: '$b batch',
                        selected: b == batch,
                        onTap: () =>
                            ref.read(logFlowProvider.notifier).chooseBatch(b),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            for (final row in rows) ...[
              const SizedBox(height: AppSpacing.l),
              if (rows.length > 1) SectionLabel(row.info.role.workbookLabel),
              ..._roleContent(row, rates, likely),
            ],
            if (rows.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.l),
              Text(
                _footer(group, groups, roles),
                style: AppText.captionSmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (state.error != null) ...[
              const SizedBox(height: AppSpacing.m),
              Text(
                state.error!,
                style: AppText.bodySmall.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _roleContent(
    IdentifiedRow row,
    RateSet rates,
    ({int roleRowId, Activity activity})? likely,
  ) {
    if (row.info.role == Role.coordinator) {
      return [
        AppCard(
          color: AppColors.goldTint,
          borderColor: AppColors.goldBorder,
          child: Text(
            'Coordination is credited automatically: '
            '${formatHours(automaticHours(row.info, rates))}. '
            'Nothing to log for this role.',
            style: AppText.bodySmall.copyWith(color: AppColors.goldTextDeep),
          ),
        ),
      ];
    }
    final options = activitiesFor(row.info);
    final main = options.where((o) => !o.isSecondary).toList();
    final more = options.where((o) => o.isSecondary).toList();

    Widget tile(ActivityOption option) => ActivityTile(
      icon: ActivityLabels.icon(option.activity),
      title: ActivityLabels.title(option.activity),
      hint: ActivityLabels.hint(option.activity, option.subtypes, rates),
      highlighted:
          likely != null &&
          likely.roleRowId == row.id &&
          likely.activity == option.activity,
      onTap: () => _choose(row, option),
    );

    return [
      _TileGrid(children: [for (final o in main) tile(o)]),
      if (row.info.role == Role.moderator)
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s),
          child: Text(
            'Moderator hours (${formatHours(automaticHours(row.info, rates))}) '
            'are credited automatically.',
            style: AppText.captionSmall,
          ),
        ),
      if (more.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.s),
        if (_showMore)
          _TileGrid(children: [for (final o in more) tile(o)])
        else
          TextButton.icon(
            onPressed: () => setState(() => _showMore = true),
            icon: const Icon(Icons.expand_more_rounded),
            label: const Text('More activities'),
          ),
      ],
    ];
  }

  /// "Only Teacher activities are shown for EC5208. Second-marking and
  /// moderation appear when you pick EC5207 or EC5204."
  String _footer(ModuleGroup group, List<ModuleGroup> all, Set<Role> roles) {
    final names = roles.map((r) => r.workbookLabel).join(' and ');
    final missing = <Role>{};
    final codes = <String>[];
    for (final other in all) {
      if (other.code == group.code) continue;
      final extra = other.roles
          .where((r) => r != Role.coordinator && !roles.contains(r))
          .toList();
      if (extra.isNotEmpty) {
        missing.addAll(extra);
        codes.add(other.code);
      }
    }
    final first = 'Only $names activities are shown for ${group.code}.';
    if (missing.isEmpty) return first;
    final what = missing.map(ActivityLabels.roleActivities).join(' and ');
    final where = codes.length <= 2
        ? codes.join(' or ')
        : '${codes.take(2).join(', ')} or others';
    return '$first ${what[0].toUpperCase()}${what.substring(1)} appear when '
        'you pick $where.';
  }
}

class _ModuleStrip extends StatelessWidget {
  const _ModuleStrip({
    required this.group,
    required this.rows,
    required this.batch,
    required this.onChange,
  });

  final ModuleGroup group;
  final List<IdentifiedRow> rows;
  final String? batch;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final roles = (rows.isEmpty ? group.rows : rows)
        .map((r) => r.info.role)
        .toSet()
        .map((r) => r.workbookLabel)
        .join(' + ');
    final subtitle = batch == null ? roles : '$roles · $batch batch';
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.xs,
        AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadii.cardSmall),
      ),
      child: Row(
        children: [
          ModuleBadge(group.code, style: ModuleBadgeStyle.gold),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: AppText.body.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppText.captionSmall.copyWith(
                    color: AppColors.onNavyMuted,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            style: TextButton.styleFrom(foregroundColor: AppColors.cream),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class _BatchChip extends StatelessWidget {
  const _BatchChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      radius: AppRadii.buttonSmall,
      borderColor: selected ? AppColors.navy : AppColors.border,
      borderWidth: selected ? 2 : 1,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      child: Center(
        child: Text(
          label,
          style: AppText.body.copyWith(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Two equal-width columns of tiles.
class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += 2) ...[
          if (i > 0) const SizedBox(height: AppSpacing.m),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: children[i]),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
