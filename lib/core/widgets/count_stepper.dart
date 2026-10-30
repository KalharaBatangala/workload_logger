import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../format.dart';
import '../theme/tokens.dart';

/// Big number between − and + with quick-set chips (SPEC §8.4). Tapping the
/// number opens a numeric input. 0 shows as "0" in a muted colour (not set).
class CountStepper extends StatelessWidget {
  const CountStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.max,
    this.quickValues = const [],
    this.compact = false,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  /// 1 for counts, 0.5 for lecture hours.
  final double step;
  final double? max;
  final List<double> quickValues;

  /// Smaller variant (questions per paper).
  final bool compact;

  double _clamp(double v) {
    if (v < 0) return 0;
    if (max != null && v > max!) return max!;
    return v;
  }

  Future<void> _type(BuildContext context) async {
    final typed = await showDialog<double>(
      context: context,
      builder: (context) => _TypeNumberDialog(
        label: label,
        initial: value > 0 ? formatCount(value) : '',
        decimals: step < 1,
      ),
    );
    if (typed != null) onChanged(_clamp(typed));
  }

  @override
  Widget build(BuildContext context) {
    final number = compact ? AppText.greeting : AppText.countBig;
    final buttonSize = compact ? 44.0 : 52.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: compact ? AppText.bodySmall : AppText.body),
        SizedBox(height: compact ? AppSpacing.xs : AppSpacing.s),
        Row(
          children: [
            _StepButton(
              size: buttonSize,
              icon: Icons.remove_rounded,
              tooltip: 'Decrease $label',
              filled: false,
              onPressed: value <= 0
                  ? null
                  : () => onChanged(_clamp(value - step)),
            ),
            Expanded(
              child: Semantics(
                container: true,
                button: true,
                label: '$label: ${formatCount(value)}. Tap to type',
                excludeSemantics: true,
                child: InkWell(
                  onTap: () => _type(context),
                  borderRadius: BorderRadius.circular(AppRadii.button),
                  child: Center(
                    child: Text(
                      formatCount(value),
                      style: number.copyWith(
                        color: value > 0
                            ? AppColors.navy
                            : AppColors.borderStrong,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _StepButton(
              size: buttonSize,
              icon: Icons.add_rounded,
              tooltip: 'Increase $label',
              filled: true,
              onPressed: max != null && value >= max!
                  ? null
                  : () => onChanged(_clamp(value + step)),
            ),
          ],
        ),
        if (quickValues.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.m),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final v in quickValues)
                _QuickChip(
                  label: formatCount(v),
                  selected: v == value,
                  onTap: () => onChanged(_clamp(v)),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.size,
    required this.icon,
    required this.tooltip,
    required this.filled,
    required this.onPressed,
  });

  final double size;
  final IconData icon;
  final String tooltip;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.button),
    );
    final style = IconButton.styleFrom(
      minimumSize: Size.square(size),
      shape: shape,
      backgroundColor: filled ? AppColors.navy : AppColors.surface,
      foregroundColor: filled ? AppColors.surface : AppColors.navy,
      disabledBackgroundColor: filled ? AppColors.chip : AppColors.surface,
      side: filled ? null : const BorderSide(color: AppColors.borderStrong),
    );
    return IconButton(
      tooltip: tooltip,
      style: style,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: 'Set to $label',
      excludeSemantics: true,
      child: Material(
        color: selected ? AppColors.chip : AppColors.surface,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? AppColors.navy : AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: AppText.bodySmall.copyWith(color: AppColors.navy),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Typing a number. Owns its text controller, so it is disposed only once
/// the dialog has finished closing.
class _TypeNumberDialog extends StatefulWidget {
  const _TypeNumberDialog({
    required this.label,
    required this.initial,
    required this.decimals,
  });

  final String label;
  final String initial;
  final bool decimals;

  @override
  State<_TypeNumberDialog> createState() => _TypeNumberDialogState();
}

class _TypeNumberDialogState extends State<_TypeNumberDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() =>
      Navigator.pop(context, double.tryParse(_controller.text) ?? 0);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.decimals),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(widget.decimals ? r'[0-9.]' : r'[0-9]'),
          ),
        ],
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('OK')),
      ],
    );
  }
}
