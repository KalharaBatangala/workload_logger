import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/tab_page.dart';

/// Placeholder until M7 (SPEC §8.7).
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPage(
      title: 'Summary',
      children: [
        EmptyState(
          icon: Icons.bar_chart_rounded,
          message: 'Summary arrives in M7.',
        ),
      ],
    );
  }
}
