import 'package:flutter/material.dart';

import '../entry_display.dart';
import '../theme/tokens.dart';
import 'credit_strip.dart';
import 'module_badge.dart';

/// One entry in a list (SPEC §8.1 "Logged today", §8.6 History): module
/// badge, title, detail line and the credit on the right.
class EntryTile extends StatelessWidget {
  const EntryTile({
    super.key,
    required this.code,
    required this.display,
    this.onTap,
  });

  final String code;
  final EntryDisplay display;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget trailing;
    if (display.isDraft) {
      trailing = Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: AppColors.goldSoft,
          borderRadius: BorderRadius.circular(AppRadii.badge),
        ),
        child: Text(
          'Draft',
          style: AppText.badge.copyWith(color: AppColors.goldTextDeep),
        ),
      );
    } else if (display.credit != null) {
      trailing = CreditText(display.credit!);
    } else {
      trailing = const Text('Recorded', style: AppText.caption);
    }

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          child: Row(
            children: [
              ModuleBadge(code),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      display.title,
                      style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(display.detail, style: AppText.captionSmall),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
