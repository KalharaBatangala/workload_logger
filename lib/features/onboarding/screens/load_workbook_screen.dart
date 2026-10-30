import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../providers.dart';
import '../widgets/onboarding_page.dart';

class LoadWorkbookScreen extends ConsumerWidget {
  const LoadWorkbookScreen({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(onboardingControllerProvider.notifier)
        .pickWorkbook();
    if (ok && context.mounted) context.push(AppRoutes.onboardingName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    return OnboardingPage(
      step: 1,
      title: 'Load the workload workbook',
      subtitle:
          'Choose the DEIE Workload Model (.xlsx) from the department. '
          'The app reads your rows and the rates; the file is not changed.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingCard(
            child: Row(
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
                  child: state.isBusy
                      ? const Row(
                          children: [
                            SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: AppSpacing.m),
                            Text('Reading the workbook…', style: AppText.body),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.fileName ?? 'No file chosen yet',
                              style: AppText.body,
                            ),
                            const Text(
                              'e.g. DEIE_Workload_Model_V10_1.xlsx',
                              style: AppText.caption,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          if (state.error != null) ...[
            const SizedBox(height: AppSpacing.l),
            OnboardingCard(
              color: AppColors.goldSoft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.goldTextDeep,
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.goldTextDeep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: state.isBusy ? null : () => _pick(context, ref),
          icon: const Icon(Icons.folder_open_rounded),
          label: const Text('Choose .xlsx file'),
        ),
      ],
    );
  }
}
