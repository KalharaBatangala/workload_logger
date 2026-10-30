import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Header of the logging flow (SPEC §8.2): close or back button, "Log work",
/// an optional navy date chip, and three 4 px progress bars.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.step,
    required this.onLeading,
    this.isClose = false,
    this.title = 'Log work',
    this.dateLabel,
    this.onDateTap,
    this.action,
    this.steps = 3,
    this.showProgress = true,
  });

  /// 1-based; bars up to and including this step are filled gold.
  final int step;
  final int steps;

  /// False for screens outside the numbered steps (e.g. "Edit entry").
  final bool showProgress;
  final String title;

  /// Close (X) on the first step, back arrow after.
  final bool isClose;
  final VoidCallback onLeading;

  /// e.g. "Today"; no chip when null.
  final String? dateLabel;
  final VoidCallback? onDateTap;

  /// Shown on the right when there is no date chip (e.g. Delete).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 52,
          child: Row(
            children: [
              _SquareButton(
                icon: isClose
                    ? Icons.close_rounded
                    : Icons.chevron_left_rounded,
                tooltip: isClose ? 'Close' : 'Back',
                onPressed: onLeading,
              ),
              Expanded(
                child: Text(
                  title,
                  style: AppText.section,
                  textAlign: TextAlign.center,
                ),
              ),
              if (dateLabel != null)
                _DateChip(label: dateLabel!, onTap: onDateTap)
              else
                action ?? const SizedBox(width: 52),
            ],
          ),
        ),
        if (showProgress) ...[
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              for (var i = 1; i <= steps; i++) ...[
                if (i > 1) const SizedBox(width: AppSpacing.xs + 2),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= step ? AppColors.gold : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
      ),
      icon: Icon(icon),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: 'Date: $label. Change',
      excludeSemantics: true,
      child: Material(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.surface,
                  ),
                  const SizedBox(width: AppSpacing.s - 2),
                  Text(
                    label,
                    style: AppText.body.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
