import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A 128 px activity tile on Step 2 (SPEC §8.3). [highlighted] gives the
/// 2 px gold border of the most likely choice.
class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String hint;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.tile),
      side: BorderSide(
        color: highlighted ? AppColors.gold : AppColors.border,
        width: highlighted ? 2 : 1,
      ),
    );
    return Semantics(
      container: true,
      button: true,
      label: '$title. $hint',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 128),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: highlighted ? AppColors.goldSoft : AppColors.chip,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: highlighted ? AppColors.goldText : AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    title,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(hint, style: AppText.captionSmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
