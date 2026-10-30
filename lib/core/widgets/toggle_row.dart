import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A setting with a switch (SPEC §8.8): tapping the text opens [onTapText]
/// (e.g. a time picker), the switch turns it on or off.
class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.onTapText,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTapText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              container: true,
              button: onTapText != null,
              label: '$title, $subtitle${onTapText != null ? '. Change' : ''}',
              excludeSemantics: true,
              child: InkWell(
                onTap: onTapText,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                      vertical: AppSpacing.m,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppText.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(subtitle, style: AppText.captionSmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Accessible name for the switch itself.
          Semantics(
            label: title,
            child: Switch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
