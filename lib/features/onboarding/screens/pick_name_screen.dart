import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../providers.dart';
import '../widgets/onboarding_page.dart';

class PickNameScreen extends ConsumerStatefulWidget {
  const PickNameScreen({super.key});

  @override
  ConsumerState<PickNameScreen> createState() => _PickNameScreenState();
}

class _PickNameScreenState extends ConsumerState<PickNameScreen> {
  String _query = '';
  late final TextEditingController _year = TextEditingController(
    text: ref.read(onboardingControllerProvider).academicYearLabel,
  );

  @override
  void dispose() {
    _year.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final ok = await ref
        .read(onboardingControllerProvider.notifier)
        .confirmImport();
    if (ok && mounted) context.push(AppRoutes.onboardingReminder);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final names = state.workbook?.staffNames ?? const <String>[];
    final query = _query.trim().toLowerCase();
    final visible = query.isEmpty
        ? names
        : names.where((n) => n.toLowerCase().contains(query)).toList();
    final preview = state.preview;

    return OnboardingPage(
      step: 2,
      title: 'Which one is you?',
      subtitle: 'Pick your name as it appears in the Staff_List sheet.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search names',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppRadii.button),
                ),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: AppSpacing.m),
          OnboardingCard(
            child: Column(
              children: [
                for (final (i, name) in visible.indexed) ...[
                  if (i > 0) const Divider(),
                  _NameRow(
                    name: name,
                    selected: name == state.selectedName,
                    onTap: () => controller.selectName(name),
                  ),
                ],
                if (visible.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.m),
                    child: Text('No matching name', style: AppText.caption),
                  ),
              ],
            ),
          ),
          if (preview != null) ...[
            const SizedBox(height: AppSpacing.l),
            _PreviewCard(preview: preview),
            const SizedBox(height: AppSpacing.l),
            TextField(
              controller: _year,
              decoration: const InputDecoration(
                labelText: 'Academic year',
                helperText: 'A label for this workbook, e.g. 2025/26',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setAcademicYear,
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
      actions: [
        FilledButton(
          onPressed: preview == null || preview.roleRows == 0 || state.isBusy
              ? null
              : _confirm,
          child: Text(state.isBusy ? 'Saving…' : 'Use this workbook'),
        ),
      ],
    );
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: selected
                      ? AppText.body
                      : AppText.body.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: AppColors.navy),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.preview});

  final ImportPreview preview;

  @override
  Widget build(BuildContext context) {
    final hasRows = preview.roleRows > 0;
    return OnboardingCard(
      color: hasRows ? AppColors.goldSoft : AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasRows
                ? '${preview.roleRows} role rows for you'
                : 'No Data_Entry rows for this name',
            style: AppText.cardTitle,
          ),
          if (hasRows) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${formatHours(preview.openingHours)} already in the workbook',
              style: AppText.bodySmall.copyWith(color: AppColors.goldTextDeep),
            ),
          ],
          for (final row in preview.skippedRows)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s),
              child: Text(
                'Row ${row.sheetRow} skipped: ${row.reason}',
                style: AppText.caption,
              ),
            ),
          for (final warning in preview.rateWarnings)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s),
              child: Text(warning, style: AppText.caption),
            ),
        ],
      ),
    );
  }
}
