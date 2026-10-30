import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/segmented_choice.dart';
import '../../../data/db/app_database.dart';
import '../../../domain/enums.dart';
import '../providers.dart';

/// What the slot sheet returns.
sealed class SlotSheetResult {
  const SlotSheetResult();
}

class SlotSaved extends SlotSheetResult {
  const SlotSaved({
    required this.roleRowId,
    required this.kind,
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  final int roleRowId;
  final SlotKind kind;
  final int weekday;
  final String startTime;
  final String endTime;
}

class SlotDeleted extends SlotSheetResult {
  const SlotDeleted();
}

/// Adds or edits a weekly class slot (SPEC §8.8 "My timetable").
Future<SlotSheetResult?> showSlotSheet(
  BuildContext context, {
  required List<RoleRow> teacherRows,
  TimetableSlot? slot,
}) => showModalBottomSheet<SlotSheetResult>(
  context: context,
  // Above the bottom bar, not inside the tab.
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) => _SlotSheet(teacherRows: teacherRows, slot: slot),
);

class _SlotSheet extends StatefulWidget {
  const _SlotSheet({required this.teacherRows, this.slot});

  final List<RoleRow> teacherRows;
  final TimetableSlot? slot;

  @override
  State<_SlotSheet> createState() => _SlotSheetState();
}

class _SlotSheetState extends State<_SlotSheet> {
  late int? _rowId =
      widget.slot?.roleRowId ?? widget.teacherRows.firstOrNull?.id;
  late SlotKind _kind = widget.slot?.kind ?? SlotKind.lecture;
  late int _weekday = widget.slot?.weekday ?? DateTime.monday;
  late String _start = widget.slot?.startTime ?? '08:00';
  late String _end = widget.slot?.endTime ?? '10:00';

  static String _hhmm(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<String?> _pick(String current) async {
    final parts = current.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    return picked == null ? null : _hhmm(picked);
  }

  bool get _valid => _rowId != null && _end.compareTo(_start) > 0;

  @override
  Widget build(BuildContext context) {
    final editing = widget.slot != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              editing ? 'Edit class slot' : 'Add a class slot',
              style: AppText.cardTitle,
            ),
            const SizedBox(height: AppSpacing.l),
            if (widget.teacherRows.isEmpty)
              const Text(
                'You have no Teacher role rows, so there are no classes to add.',
                style: AppText.bodySmall,
              )
            else ...[
              const SectionLabel('Module'),
              DropdownButtonFormField<int>(
                initialValue: _rowId,
                isExpanded: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  for (final row in widget.teacherRows)
                    DropdownMenuItem(
                      value: row.id,
                      child: Text(
                        '${row.moduleCode} · ${row.batch} · ${row.moduleName}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (id) => setState(() => _rowId = id),
              ),
              const SizedBox(height: AppSpacing.l),
              const SectionLabel('Kind'),
              SegmentedChoice<SlotKind>(
                options: SlotKind.values,
                selected: _kind,
                labelOf: (k) => k == SlotKind.lecture ? 'Lecture' : 'Lab',
                onSelected: (k) => setState(() => _kind = k),
              ),
              const SizedBox(height: AppSpacing.l),
              const SectionLabel('Day'),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (var d = 1; d <= 7; d++)
                    ChoiceChip(
                      label: Text(weekdayNames[d - 1].substring(0, 3)),
                      selected: d == _weekday,
                      onSelected: (_) => setState(() => _weekday = d),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              const SectionLabel('Time'),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final t = await _pick(_start);
                        if (t != null) setState(() => _start = t);
                      },
                      child: Text('From ${formatClockTime(_start)}'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final t = await _pick(_end);
                        if (t != null) setState(() => _end = t);
                      },
                      child: Text('To ${formatClockTime(_end)}'),
                    ),
                  ),
                ],
              ),
              if (_end.compareTo(_start) <= 0) ...[
                const SizedBox(height: AppSpacing.s),
                Text(
                  'The end must be after the start.',
                  style: AppText.caption.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _valid
                      ? () => Navigator.pop(
                          context,
                          SlotSaved(
                            roleRowId: _rowId!,
                            kind: _kind,
                            weekday: _weekday,
                            startTime: _start,
                            endTime: _end,
                          ),
                        )
                      : null,
                  child: Text(editing ? 'Save' : 'Add slot'),
                ),
              ),
            ],
            if (editing) ...[
              const SizedBox(height: AppSpacing.s),
              TextButton.icon(
                onPressed: () => Navigator.pop(context, const SlotDeleted()),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete slot'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
