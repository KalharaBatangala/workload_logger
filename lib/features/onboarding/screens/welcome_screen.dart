import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../providers.dart';
import '../widgets/onboarding_page.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _tryDemo(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingControllerProvider.notifier).startDemo();
    if (context.mounted) context.push(AppRoutes.onboardingReminder);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(
      onboardingControllerProvider.select((s) => s.isBusy),
    );
    return OnboardingPage(
      title: 'Log your workload in seconds',
      subtitle:
          'Record academic work on the day you do it. At the end of the '
          'period, the app produces your rows of the DEIE workload workbook.',
      showBack: false,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AppMark(),
          SizedBox(height: AppSpacing.xxl),
          _Point(
            icon: Icons.tag_rounded,
            title: 'Count, don\'t time',
            text:
                '10 quiz questions are credited 1.0 h, however long they took.',
          ),
          _Point(
            icon: Icons.school_outlined,
            title: 'Only your modules and roles',
            text: 'Read from the workbook, so you never type a module code.',
          ),
          _Point(
            icon: Icons.wifi_off_rounded,
            title: 'Stays on your phone',
            text: 'Works without signal. Nothing is sent anywhere.',
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: busy
              ? null
              : () => context.push(AppRoutes.onboardingWorkbook),
          child: const Text('Load my workbook'),
        ),
        OutlinedButton(
          onPressed: busy ? null : () => _tryDemo(context, ref),
          child: const Text('Try with demo data'),
        ),
      ],
    );
  }
}

class _AppMark extends StatelessWidget {
  const _AppMark();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(AppRadii.logButton),
        ),
        child: const Icon(Icons.check_rounded, color: AppColors.gold, size: 36),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
            child: Icon(icon, color: AppColors.goldText, size: 22),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.body),
                const SizedBox(height: 2),
                Text(text, style: AppText.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
