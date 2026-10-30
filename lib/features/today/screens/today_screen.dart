import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/tab_page.dart';

/// Placeholder until M5 (SPEC §8.1).
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPage(
      title: 'Today',
      children: [
        EmptyState(icon: Icons.home_outlined, message: 'Today arrives in M5.'),
      ],
    );
  }
}
