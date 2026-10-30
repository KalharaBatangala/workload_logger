import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum ModuleBadgeStyle {
  /// Pale chip with navy text (lists).
  pale,

  /// Navy chip with white text (RECENT card, Step 3 title).
  navy,

  /// Gold chip with navy text (on navy backgrounds).
  gold,

  /// Dashed outline ("Other").
  dashed,
}

/// A module code badge, e.g. "EC5208" (SPEC §11.4).
class ModuleBadge extends StatelessWidget {
  const ModuleBadge(
    this.label, {
    super.key,
    this.style = ModuleBadgeStyle.pale,
  });

  final String label;
  final ModuleBadgeStyle style;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (style) {
      ModuleBadgeStyle.pale => (AppColors.chip, AppColors.navy),
      ModuleBadgeStyle.navy => (AppColors.navy, AppColors.surface),
      ModuleBadgeStyle.gold => (AppColors.gold, AppColors.navyDeep),
      ModuleBadgeStyle.dashed => (Colors.transparent, AppColors.textBody),
    };
    final text = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs + 1,
      ),
      child: Text(label, style: AppText.badge.copyWith(color: foreground)),
    );
    if (style == ModuleBadgeStyle.dashed) {
      return CustomPaint(painter: _DashedBorderPainter(), child: text);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.badge),
      ),
      child: text,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadii.badge),
        ),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + 4, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + 3;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
