import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../data/providers.dart';
import '../providers.dart';

/// "Close this period": locks the current academic year (its entries become
/// read-only) and starts the next one.
Future<void> showClosePeriodSheet(BuildContext context, WidgetRef ref) async {
  final current = await ref.read(currentYearPeriodProvider.future);
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  // The sheet returns the next year's label, or null when cancelled.
  final nextLabel = await showModalBottomSheet<String>(
    context: context,
    // Above the bottom bar, not inside the tab.
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ClosePeriodSheet(
      label: current.label,
      suggestedNext: nextYearLabel(current.label, ref.read(clockProvider)()),
    ),
  );
  if (nextLabel == null) return;

  await ref
      .read(summaryActionsProvider)
      .closeCurrentPeriod(label: current.label, nextLabel: nextLabel);
  messenger.showSnackBar(
    SnackBar(
      content: Text('${current.label} is closed. $nextLabel has begun.'),
    ),
  );
}

/// Owns its text controller, so it is disposed only once the sheet has
/// finished closing.
class _ClosePeriodSheet extends StatefulWidget {
  const _ClosePeriodSheet({required this.label, required this.suggestedNext});

  final String label;
  final String suggestedNext;

  @override
  State<_ClosePeriodSheet> createState() => _ClosePeriodSheetState();
}

class _ClosePeriodSheetState extends State<_ClosePeriodSheet> {
  late final TextEditingController _next = TextEditingController(
    text: widget.suggestedNext,
  );

  @override
  void dispose() {
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Close ${widget.label}?', style: AppText.cardTitle),
          const SizedBox(height: AppSpacing.s),
          const Text(
            'Entries up to and including today will be locked and can no '
            'longer be changed. New work is logged from tomorrow. Export your '
            'Data_Entry rows first if you have not yet.',
            style: AppText.bodySmall,
          ),
          const SizedBox(height: AppSpacing.l),
          TextField(
            controller: _next,
            decoration: const InputDecoration(
              labelText: 'Next academic year',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () {
                final next = _next.text.trim();
                Navigator.pop(context, next.isEmpty ? widget.label : next);
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: Text('Close ${widget.label}'),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
