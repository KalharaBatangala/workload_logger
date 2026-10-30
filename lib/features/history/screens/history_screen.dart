import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/tab_page.dart';

/// Placeholder until M6 (SPEC §8.6).
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPage(
      title: 'History',
      children: [
        EmptyState(
          icon: Icons.access_time_rounded,
          message: 'History arrives in M6.',
        ),
      ],
    );
  }
}
