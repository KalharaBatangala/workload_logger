import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Standard layout for a main-tab screen: safe area, 20 px side padding and a
/// scrollable column starting with the screen title (SPEC §8).
class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xxl,
          AppSpacing.screenPadding,
          // Keep content clear of the bottom bar (the body extends behind it).
          MediaQuery.paddingOf(context).bottom + AppSpacing.xxl,
        ),
        children: [
          Text(title, style: AppText.screenTitle),
          const SizedBox(height: AppSpacing.section),
          ...children,
        ],
      ),
    );
  }
}
