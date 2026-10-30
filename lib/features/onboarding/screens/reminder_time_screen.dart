import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../providers.dart';
import '../widgets/onboarding_page.dart';

class ReminderTimeScreen extends ConsumerStatefulWidget {
  const ReminderTimeScreen({super.key});

  @override
  ConsumerState<ReminderTimeScreen> createState() => _ReminderTimeScreenState();
}

class _ReminderTimeScreenState extends ConsumerState<ReminderTimeScreen> {
  /// Null until the user changes it; then overrides the saved time.
  String? _chosen;
  bool _saving = false;

  Future<void> _pickTime(String current) async {
    final parts = current.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (picked != null) {
      setState(() {
        _chosen =
            '${picked.hour.toString().padLeft(2, '0')}:'
            '${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _finish(String time) async {
    setState(() => _saving = true);
    // Finishing onboarding makes the router move on to Today.
    await ref
        .read(onboardingControllerProvider.notifier)
        .finish(eveningTime: time);
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(eveningReminderTimeProvider).value ?? '20:30';
    final time = _chosen ?? saved;
    return OnboardingPage(
      step: 3,
      title: 'When should we remind you?',
      subtitle:
          'Each evening the app can ask whether there is anything to log '
          'for the day. Reminders are switched on in a later update; your '
          'time is saved now.',
      body: OnboardingCard(
        child: Semantics(
          container: true,
          button: true,
          label: 'Evening check-in time, ${formatClockTime(time)}. Change',
          excludeSemantics: true,
          child: InkWell(
            onTap: () => _pickTime(time),
            borderRadius: BorderRadius.circular(AppRadii.card),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: Row(
                children: [
                  const Icon(Icons.notifications_none_rounded),
                  const SizedBox(width: AppSpacing.m),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Evening check-in', style: AppText.body),
                        Text('Every day', style: AppText.caption),
                      ],
                    ),
                  ),
                  Text(formatClockTime(time), style: AppText.cardTitle),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: _saving ? null : () => _finish(time),
          child: const Text('Finish'),
        ),
      ],
    );
  }
}
