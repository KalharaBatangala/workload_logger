import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';

/// Full-screen placeholder for the logging flow until M4 (SPEC §8.2–8.5).
class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'Close',
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.button),
                      ),
                    ),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Expanded(
                    child: Text(
                      'Log work',
                      style: AppText.section,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Balances the close button so the title stays centred.
                  const SizedBox(width: AppSpacing.minTouchTarget),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              const Text('Which module?', style: AppText.stepTitle),
              const EmptyState(message: 'The logging flow arrives in M4.'),
            ],
          ),
        ),
      ),
    );
  }
}
