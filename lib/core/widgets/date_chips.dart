import 'package:flutter/material.dart';

import '../../domain/dates.dart';
import '../format.dart';
import '../theme/tokens.dart';

/// Opens the system date picker; future dates are not allowed (SPEC §12).
Future<String?> pickPastDate(
  BuildContext context, {
  required String selected,
  required String today,
}) async {
  final todayDate = parseIsoDate(today);
  final picked = await showDatePicker(
    context: context,
    initialDate: parseIsoDate(selected),
    firstDate: DateTime(todayDate.year - 1, todayDate.month, todayDate.day),
    lastDate: todayDate,
  );
  return picked == null ? null : isoDate(picked);
}

/// Bottom sheet behind the header's date chip: Today / Yesterday / calendar.
Future<String?> showDateSheet(
  BuildContext context, {
  required String selected,
  required String today,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          0,
          AppSpacing.screenPadding,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Which day was it?', style: AppText.cardTitle),
            const SizedBox(height: AppSpacing.l),
            DateChips(
              selected: selected,
              today: today,
              onSelected: (date) => Navigator.pop(sheetContext, date),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Today / Yesterday / Pick date (SPEC §8.4 WHEN). The selected chip has a
/// 2 px navy border; a picked date shows on the third chip.
class DateChips extends StatelessWidget {
  const DateChips({
    super.key,
    required this.selected,
    required this.today,
    required this.onSelected,
  });

  final String selected;
  final String today;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final yesterday = addDays(today, -1);
    final isOther = selected != today && selected != yesterday;
    return Row(
      children: [
        Expanded(
          child: _DateChip(
            label: 'Today',
            selected: selected == today,
            onTap: () => onSelected(today),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: _DateChip(
            label: 'Yesterday',
            selected: selected == yesterday,
            onTap: () => onSelected(yesterday),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: _DateChip(
            label: isOther
                ? formatDayLabel(selected, today: today)
                : 'Pick date',
            selected: isOther,
            onTap: () async {
              final picked = await pickPastDate(
                context,
                selected: selected,
                today: today,
              );
              if (picked != null) onSelected(picked);
            },
          ),
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.buttonSmall),
      side: BorderSide(
        color: selected ? AppColors.navy : AppColors.border,
        width: selected ? 2 : 1,
      ),
    );
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.surface,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: SizedBox(
            height: AppSpacing.minTouchTarget + 4,
            child: Center(
              child: Text(
                label,
                style: AppText.bodySmall.copyWith(
                  color: AppColors.navy,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
