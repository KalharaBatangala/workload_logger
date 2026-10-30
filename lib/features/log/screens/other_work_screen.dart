import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/date_chips.dart';
import '../../../core/widgets/step_header.dart';
import '../../../data/providers.dart';
import '../providers.dart';

/// Work outside the workload model (SPEC §5 "other"): category, time spent,
/// note. Kept separate and never credited.
class OtherWorkScreen extends ConsumerStatefulWidget {
  const OtherWorkScreen({super.key});

  @override
  ConsumerState<OtherWorkScreen> createState() => _OtherWorkScreenState();
}

class _OtherWorkScreenState extends ConsumerState<OtherWorkScreen> {
  static const _durations = [15, 30, 45, 60, 90, 120, 180, 240];

  int? _categoryId;
  int? _minutes;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(logFlowProvider.notifier)
        .saveOtherWork(
          categoryId: _categoryId!,
          spentMinutes: _minutes!,
          note: _note.text,
        );
    if (!mounted) return;
    context.go(AppRoutes.today);
    messenger.showSnackBar(
      const SnackBar(content: Text('Saved as other work, not credited')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(logFlowProvider.select((s) => s.date));
    final today = ref.watch(todayProvider);
    final categories = ref.watch(otherCategoriesProvider).value ?? const [];
    final canSave = _categoryId != null && _minutes != null;

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
                    step: 2,
                    steps: 2,
                    title: 'Other work',
                    onLeading: () => context.pop(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    'Work outside the model',
                    style: AppText.stepTitle,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Kept for your own record. It is not part of the workload '
                    'model and is never credited.',
                    style: AppText.caption,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel('What kind of work?'),
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: AppSpacing.s,
                    children: [
                      for (final category in categories)
                        ChoiceChip(
                          label: Text(category.name),
                          selected: category.id == _categoryId,
                          onSelected: (_) =>
                              setState(() => _categoryId = category.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel('Time spent'),
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: AppSpacing.s,
                    children: [
                      for (final minutes in _durations)
                        ChoiceChip(
                          label: Text(formatMinutes(minutes)),
                          selected: minutes == _minutes,
                          onSelected: (_) => setState(() => _minutes = minutes),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel('When'),
                  DateChips(
                    selected: date,
                    today: today,
                    onSelected: ref.read(logFlowProvider.notifier).setDate,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel('Note'),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                    ),
                    child: TextField(
                      controller: _note,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. Paper reading',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.m,
                AppSpacing.screenPadding,
                AppSpacing.m,
              ),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSave ? _save : null,
                  child: const Text('Save other work'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
