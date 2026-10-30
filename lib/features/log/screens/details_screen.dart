import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/count_stepper.dart';
import '../../../core/widgets/credit_strip.dart';
import '../../../core/widgets/date_chips.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../core/widgets/segmented_choice.dart';
import '../../../core/widgets/step_header.dart';
import '../../../data/providers.dart';
import '../../../domain/activity_catalogue.dart';
import '../../../domain/entry_validation.dart';
import '../../../core/activity_labels.dart';
import '../credit_explanation.dart';
import '../warning_text.dart';
import '../providers.dart';

/// Step 3 — type and count (SPEC §8.4).
class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  late final TextEditingController _note = TextEditingController(
    text: ref.read(logFlowProvider).note,
  );
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final ok = await ref.read(logFlowProvider.notifier).save();
    if (!mounted) return;
    setState(() => _saving = false);
    if (!ok) return;
    if (ref.read(logFlowProvider).isEditing) {
      final messenger = ScaffoldMessenger.of(context);
      context.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Entry updated')));
    } else {
      context.go(AppRoutes.logSaved);
    }
  }

  /// Edit mode: delete, go back, and offer Undo.
  Future<void> _delete() async {
    final messenger = ScaffoldMessenger.of(context);
    final entries = ref.read(entriesRepositoryProvider);
    final id = await ref.read(logFlowProvider.notifier).deleteEditing();
    if (id == null || !mounted) return;
    context.pop();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Entry deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => entries.undoDelete(id),
        ),
      ),
    );
  }

  Future<void> _pickSpent(int? current) async {
    const options = [15, 30, 45, 60, 90, 120, 180, 240];
    final picked = await showModalBottomSheet<int>(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Time actually spent', style: AppText.cardTitle),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Private. It never changes the credited hours.',
                style: AppText.caption,
              ),
              const SizedBox(height: AppSpacing.l),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final minutes in options)
                    ChoiceChip(
                      label: Text(formatMinutes(minutes)),
                      selected: minutes == current,
                      onSelected: (_) => Navigator.pop(context, minutes),
                    ),
                ],
              ),
              if (current != null) ...[
                const SizedBox(height: AppSpacing.m),
                TextButton(
                  onPressed: () => Navigator.pop(context, 0),
                  child: const Text('Clear'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    if (picked != null) {
      ref
          .read(logFlowProvider.notifier)
          .setSpentMinutes(picked == 0 ? null : picked);
    }
  }

  Future<void> _addPhoto() async {
    final camera = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
    if (camera != null) {
      await ref.read(logFlowProvider.notifier).addPhoto(camera: camera);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logFlowProvider);
    final flow = ref.read(logFlowProvider.notifier);
    final rates = ref.watch(currentRatesProvider);
    final today = ref.watch(todayProvider);
    final activity = state.activity;
    final kind = state.countKind;

    if (activity == null || kind == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                StepHeader(step: 3, onLeading: () => context.pop()),
                const EmptyState(
                  message: 'Pick a module and an activity first.',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final credit = state.creditWith(rates);
    final warnings = ref.watch(logWarningsProvider).value ?? const [];
    final isHours = kind == CountKind.hours;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.m,
                  AppSpacing.screenPadding,
                  AppSpacing.xxl,
                ),
                children: [
                  StepHeader(
                    step: 3,
                    title: state.isEditing ? 'Edit entry' : 'Log work',
                    showProgress: !state.isEditing,
                    onLeading: () => context.pop(),
                    action: state.isEditing && !state.readOnly
                        ? IconButton(
                            tooltip: 'Delete entry',
                            onPressed: _delete,
                            icon: const Icon(Icons.delete_outline_rounded),
                          )
                        : null,
                  ),
                  if (state.readOnly) ...[
                    const SizedBox(height: AppSpacing.l),
                    AppCard(
                      color: AppColors.goldTint,
                      borderColor: AppColors.goldBorder,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.goldTextDeep,
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              'This period is closed. Entries in it can\'t be '
                              'changed.',
                              style: AppText.bodySmall.copyWith(
                                color: AppColors.goldTextDeep,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  IgnorePointer(
                    ignoring: state.readOnly,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.l),
                        Row(
                          children: [
                            ModuleBadge(
                              state.moduleCode ?? '',
                              style: ModuleBadgeStyle.navy,
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Expanded(
                              child: Text(
                                ActivityLabels.title(activity),
                                style: AppText.stepTitle,
                              ),
                            ),
                          ],
                        ),
                        if (state.subtypes.length > 1) ...[
                          const SizedBox(height: AppSpacing.l),
                          const SectionLabel('Type'),
                          SegmentedChoice(
                            options: state.subtypes,
                            selected: state.subtype,
                            labelOf: ActivityLabels.subtype,
                            onSelected: flow.setSubtype,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.l),
                        AppCard(
                          radius: AppRadii.cardLarge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CountStepper(
                                label: ActivityLabels.countLabel(kind),
                                value: state.count,
                                step: isHours ? 0.5 : 1,
                                max: isHours ? maxLectureHours : null,
                                quickValues: ActivityLabels.quickCounts(kind),
                                onChanged: flow.setCount,
                              ),
                              if (state.needsQpp) ...[
                                const SizedBox(height: AppSpacing.l),
                                const Divider(),
                                const SizedBox(height: AppSpacing.m),
                                CountStepper(
                                  compact: true,
                                  label: 'Questions per paper',
                                  value: state.questionsPerPaper ?? 0,
                                  max: maxQuestionsPerPaper.toDouble(),
                                  quickValues: const [1, 2, 3, 5, 10],
                                  onChanged: (v) => flow.setQuestionsPerPaper(
                                    v > 0 ? v : null,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.l),
                              CreditStrip(
                                explanation: creditExplanation(state, rates),
                                hours: credit,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        const SectionLabel('When'),
                        DateChips(
                          selected: state.date,
                          today: today,
                          onSelected: flow.setDate,
                        ),
                        const SizedBox(height: AppSpacing.l),
                        const SectionLabel('Optional'),
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _OptionalRow(
                                label: 'Time actually spent',
                                value: state.spentMinutes == null
                                    ? 'Add'
                                    : formatMinutes(state.spentMinutes!),
                                onTap: () => _pickSpent(state.spentMinutes),
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.l,
                                ),
                                child: Row(
                                  children: [
                                    const Text('Note', style: AppText.body),
                                    const SizedBox(width: AppSpacing.l),
                                    Expanded(
                                      child: TextField(
                                        controller: _note,
                                        onChanged: flow.setNote,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'e.g. Quiz 2, Flutter state management',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              _OptionalRow(
                                icon: Icons.photo_camera_outlined,
                                label: 'Add a photo as evidence',
                                onTap: _addPhoto,
                              ),
                              for (final (i, _) in state.photoPaths.indexed)
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.image_outlined),
                                  title: Text('Photo ${i + 1}'),
                                  trailing: IconButton(
                                    tooltip: 'Remove photo ${i + 1}',
                                    onPressed: () => flow.removePhoto(i),
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (state.error != null) ...[
                          const SizedBox(height: AppSpacing.m),
                          Text(
                            state.error!,
                            style: AppText.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        // SPEC §12: worth a second look, but Save still works.
                        if (warnings.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.m),
                          AppCard(
                            color: AppColors.goldTint,
                            borderColor: AppColors.goldBorder,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final w in warnings)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.info_outline_rounded,
                                          size: 18,
                                          color: AppColors.goldTextDeep,
                                        ),
                                        const SizedBox(width: AppSpacing.s),
                                        Expanded(
                                          child: Text(
                                            warningText(
                                              w,
                                              moduleCode:
                                                  state.moduleCode ?? '',
                                            ),
                                            style: AppText.bodySmall.copyWith(
                                              color: AppColors.goldTextDeep,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!state.readOnly)
              _SaveBar(
                complete: state.isComplete,
                credit: credit,
                busy: _saving,
                onSave: _save,
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionalRow extends StatelessWidget {
  const _OptionalRow({
    required this.label,
    required this.onTap,
    this.value,
    this.icon,
  });

  final String label;
  final String? value;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.navy),
                const SizedBox(width: AppSpacing.s),
              ],
              Expanded(child: Text(label, style: AppText.body)),
              if (value != null)
                Text(
                  value!,
                  style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sticky footer: navy "Save" with a gold "+1.0 h" pill, or "Save as draft".
class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.complete,
    required this.credit,
    required this.busy,
    required this.onSave,
  });

  final bool complete;
  final double credit;
  final bool busy;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.m,
          AppSpacing.screenPadding,
          AppSpacing.m,
        ),
        child: SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: busy ? null : onSave,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.cardSmall),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  complete ? 'Save' : 'Save as draft',
                  style: AppText.body.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (complete) ...[
                  const SizedBox(width: AppSpacing.s),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppRadii.badge),
                    ),
                    child: Text(
                      formatCredit(credit),
                      style: AppText.badge.copyWith(color: AppColors.navyDeep),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
