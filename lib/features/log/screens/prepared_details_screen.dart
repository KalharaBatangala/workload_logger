import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'details_screen.dart';

/// Step 3 opened from outside the flow: [prepare] fills the flow first
/// (an entry to edit, or a lecture from a timetable card), then the normal
/// [DetailsScreen] shows.
class PreparedDetailsScreen extends ConsumerStatefulWidget {
  const PreparedDetailsScreen({super.key, required this.prepare});

  /// Returns false if there is nothing to show (e.g. the entry is gone).
  final Future<bool> Function(WidgetRef ref) prepare;

  @override
  ConsumerState<PreparedDetailsScreen> createState() =>
      _PreparedDetailsScreenState();
}

class _PreparedDetailsScreenState extends ConsumerState<PreparedDetailsScreen> {
  bool? _ready;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ok = await widget.prepare(ref);
      if (mounted) setState(() => _ready = ok);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the auto-disposed flow alive while preparing.
    ref.watch(logFlowProvider);
    return switch (_ready) {
      null => const Scaffold(body: Center(child: CircularProgressIndicator())),
      true => const DetailsScreen(),
      false => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This entry no longer exists.')),
      ),
    };
  }
}
