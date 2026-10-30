import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/tab_page.dart';

/// Placeholder until M8 (SPEC §8.8).
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPage(
      title: 'Setup',
      children: [
        EmptyState(icon: Icons.tune_rounded, message: 'Setup arrives in M8.'),
      ],
    );
  }
}
