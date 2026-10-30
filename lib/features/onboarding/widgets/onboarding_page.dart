import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';

/// Layout shared by the onboarding steps: optional back button and step
/// counter, a title, a scrollable body and buttons pinned to the bottom.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.step,
    this.showBack = true,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;

  /// e.g. 2 for "Step 2 of 3"; null on the welcome screen.
  final int? step;
  final bool showBack;
  final Widget body;

  /// Buttons at the bottom, full width, top to bottom.
  final List<Widget> actions;

  static const steps = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.m,
                AppSpacing.screenPadding,
                0,
              ),
              child: SizedBox(
                height: AppSpacing.minTouchTarget,
                child: Row(
                  children: [
                    if (showBack && context.canPop())
                      IconButton(
                        tooltip: 'Back',
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    const Spacer(),
                    if (step != null)
                      Text('Step $step of $steps', style: AppText.caption),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.l,
                  AppSpacing.screenPadding,
                  AppSpacing.xxl,
                ),
                children: [
                  Text(title, style: AppText.screenTitle),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.s),
                    Text(subtitle!, style: AppText.bodySmall),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  body,
                ],
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.m,
                  AppSpacing.screenPadding,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, action) in actions.indexed) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.m),
                      SizedBox(height: 52, child: action),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A white rounded card used on the onboarding steps.
class OnboardingCard extends StatelessWidget {
  const OnboardingCard({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.cardLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(padding: const EdgeInsets.all(AppSpacing.l), child: child),
    );
  }
}
