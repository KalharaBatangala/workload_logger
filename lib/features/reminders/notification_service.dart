import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/reminder_planner.dart';

/// A tap on a reminder or one of its buttons.
class ReminderTap {
  const ReminderTap(this.payload, [this.action]);

  final ReminderPayload payload;

  /// Null when the notification itself was tapped.
  final ReminderAction? action;
}

/// Shows and schedules reminders. The real one wraps
/// flutter_local_notifications; tests use [FakeNotificationService].
abstract class NotificationService {
  /// Sets up the plugin; [onTap] receives taps while the app runs.
  Future<void> init({required void Function(ReminderTap) onTap});

  /// Android 13+: asks for permission. True when notifications may show.
  Future<bool> requestPermission();

  Future<bool> areEnabled();

  /// Cancels everything scheduled and schedules [reminders].
  Future<void> replaceAll(List<PlannedReminder> reminders);

  /// The tap that launched the app from a closed state, if any.
  Future<ReminderTap?> launchTap();
}

/// Timezone used when the device's cannot be read (SPEC §12).
const fallbackTimezone = 'Asia/Colombo';

class LocalNotificationService implements NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationDetails(
    'reminders',
    'Reminders',
    channelDescription: 'Evening check-in, catch-up and review reminders',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@drawable/ic_launcher_foreground',
  );

  static const _actionLabels = {
    ReminderAction.logWork: 'Log work',
    ReminderAction.lectureDone: 'Lecture done',
    ReminderAction.nothing: 'Nothing',
  };

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> init({required void Function(ReminderTap) onTap}) async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation(fallbackTimezone));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(
          '@drawable/ic_launcher_foreground',
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final tap = _toTap(response.payload, response.actionId);
        if (tap != null) onTap(tap);
      },
    );
  }

  static ReminderTap? _toTap(String? payload, String? actionId) {
    final decoded = ReminderPayload.decode(payload);
    if (decoded == null) return null;
    final action = ReminderAction.values
        .where((a) => a.name == actionId)
        .firstOrNull;
    return ReminderTap(decoded, action);
  }

  @override
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? true;

  @override
  Future<bool> areEnabled() async =>
      await _android?.areNotificationsEnabled() ?? true;

  @override
  Future<void> replaceAll(List<PlannedReminder> reminders) async {
    await _plugin.cancelAll();
    for (final r in reminders) {
      await _plugin.zonedSchedule(
        id: r.id,
        title: r.title,
        body: r.body,
        payload: r.payload.encode(),
        scheduledDate: tz.TZDateTime(
          tz.local,
          r.at.year,
          r.at.month,
          r.at.day,
          r.at.hour,
          r.at.minute,
        ),
        // No exact-alarm permission needed (SPEC §9).
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.channelId,
            _channel.channelName,
            channelDescription: _channel.channelDescription,
            importance: _channel.importance,
            priority: _channel.priority,
            icon: _channel.icon,
            styleInformation: BigTextStyleInformation(r.body),
            actions: [
              for (final action in r.actions)
                AndroidNotificationAction(
                  action.name,
                  _actionLabels[action]!,
                  // Decided with the owner: buttons open the app, which
                  // records the answer (no background database writes).
                  showsUserInterface: true,
                ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Future<ReminderTap?> launchTap() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    final response = details.notificationResponse;
    return _toTap(response?.payload, response?.actionId);
  }
}

/// Records what would be scheduled; used in tests.
class FakeNotificationService implements NotificationService {
  List<PlannedReminder> scheduled = const [];
  bool permissionGranted = true;
  int replaceCalls = 0;
  void Function(ReminderTap)? onTap;
  ReminderTap? pendingLaunchTap;

  @override
  Future<void> init({required void Function(ReminderTap) onTap}) async =>
      this.onTap = onTap;

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<bool> areEnabled() async => permissionGranted;

  @override
  Future<void> replaceAll(List<PlannedReminder> reminders) async {
    replaceCalls++;
    scheduled = List.unmodifiable(reminders);
  }

  @override
  Future<ReminderTap?> launchTap() async {
    final tap = pendingLaunchTap;
    pendingLaunchTap = null;
    return tap;
  }

  /// Simulates the user tapping a notification or button.
  @visibleForTesting
  void tap(ReminderTap tap) => onTap?.call(tap);
}
