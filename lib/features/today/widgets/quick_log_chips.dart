import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Quick log (SPEC §8.1): recent module codes, then a dashed "All modules".
class QuickLogChips extends StatelessWidget {
  const QuickLogChips({
    super.key,
    required this.codes,
    required this.onCode,
    required this.onAll,
  });

  final List<String> codes;
  final ValueChanged<String> onCode;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        for (final code in codes)
          _Chip(
            label: code,
            semanticLabel: 'Log work for $code',
            onTap: () => onCode(code),
          ),
        _Chip(
          label: 'All modules',
          semanticLabel: 'Log work, all modules',
          dashed: true,
          onTap: onAll,
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.semanticLabel,
    required this.onTap,
    this.dashed = false,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback onTap;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: BorderSide(
        color: dashed ? AppColors.borderStrong : AppColors.border,
      ),
    );
    return Semantics(
      container: true,
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: dashed ? AppColors.ground : AppColors.surface,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: AppText.body.copyWith(
                    fontWeight: dashed ? FontWeight.w600 : FontWeight.w800,
                    color: dashed ? AppColors.textBody : AppColors.navy,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
