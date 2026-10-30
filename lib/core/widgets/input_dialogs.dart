import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Asks for a number. Owns its text controller, so it is disposed only once
/// the dialog has finished closing. Pops with the number (0 if empty).
class NumberDialog extends StatefulWidget {
  const NumberDialog({
    super.key,
    required this.label,
    required this.initial,
    this.decimals = false,
  });

  final String label;
  final String initial;
  final bool decimals;

  @override
  State<NumberDialog> createState() => _NumberDialogState();
}

class _NumberDialogState extends State<NumberDialog> {
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

/// Asks for a short text (e.g. a category name). Pops with the trimmed text,
/// or nothing when cancelled or left empty.
class TextDialog extends StatefulWidget {
  const TextDialog({super.key, required this.label, this.initial = ''});

  final String label;
  final String initial;

  @override
  State<TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    Navigator.pop(context, text.isEmpty ? null : text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
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
