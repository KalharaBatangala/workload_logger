import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A centred, muted message for screens or lists with nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 32, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.m),
          ],
          Text(message, style: AppText.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
