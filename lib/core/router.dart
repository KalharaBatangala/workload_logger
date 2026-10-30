import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/db/app_database.dart';
import '../data/providers.dart';
import '../features/history/screens/history_screen.dart';
import '../features/log/screens/activity_screen.dart';
import '../features/log/screens/details_screen.dart';
import '../features/log/screens/module_screen.dart';
import '../features/log/providers.dart';
import '../features/log/screens/other_work_screen.dart';
import '../features/log/screens/prepared_details_screen.dart';
import '../features/log/screens/saved_screen.dart';
import '../features/onboarding/screens/load_workbook_screen.dart';
import '../features/onboarding/screens/pick_name_screen.dart';
import '../features/onboarding/screens/reminder_time_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/setup/screens/setup_screen.dart';
import '../features/summary/screens/summary_screen.dart';
import '../features/today/screens/today_screen.dart';
import 'widgets/app_scaffold.dart';

/// Route paths, so screens never hard-code strings.
abstract final class AppRoutes {
  static const today = '/today';
  static const history = '/history';
  static const summary = '/summary';
  static const setup = '/setup';
  static const log = '/log';
  static String logModule(String code) => '/log/m/$code';
  static String logDetails(String code) => '/log/m/$code/details';
  static const logSaved = '/log/saved';
  static const logOther = '/log/other';
  static String logLecture(String code, int roleRowId) =>
      '/log/m/$code/lecture/$roleRowId';
  static String editEntry(String id) => '/edit/$id';

  /// Shown for a moment while the profile loads at start-up.
  static const loading = '/loading';

  static const onboarding = '/onboarding';
  static const onboardingWorkbook = '/onboarding/workbook';
  static const onboardingName = '/onboarding/name';
  static const onboardingReminder = '/onboarding/reminder';
}

/// One router per [ProviderScope], so each test gets a fresh navigation state.
/// It re-checks [onboardingRedirect] whenever the profile changes.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(profileProvider, (_, _) => refresh.value++);
  final router = createRouter(
    refreshListenable: refresh,
    redirect: (location) =>
        onboardingRedirect(ref.read(profileProvider), location),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

/// Keeps the user in onboarding until it is finished, and out of it after.
String? onboardingRedirect(AsyncValue<ProfileRow?> profile, String location) {
  if (!profile.hasValue && !profile.hasError) {
    return location == AppRoutes.loading ? null : AppRoutes.loading;
  }
  final done = profile.value?.onboardingDone ?? false;
  final inOnboarding = location.startsWith(AppRoutes.onboarding);
  if (!done) return inOnboarding ? null : AppRoutes.onboarding;
  if (inOnboarding || location == AppRoutes.loading) return AppRoutes.today;
  return null;
}

GoRouter createRouter({
  Listenable? refreshListenable,
  String? Function(String location)? redirect,
}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.today,
    refreshListenable: refreshListenable,
    redirect: redirect == null
        ? null
        : (context, state) => redirect(state.matchedLocation),
    routes: [
      // The four tabs keep their own navigation stacks (indexedStack), so
      // switching tabs preserves scroll position and state.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: [
          _branch(AppRoutes.today, const TodayScreen()),
          _branch(AppRoutes.history, const HistoryScreen()),
          _branch(AppRoutes.summary, const SummaryScreen()),
          _branch(AppRoutes.setup, const SetupScreen()),
        ],
      ),
      // The log flow is full-screen, above the shell (no bottom bar).
      GoRoute(
        path: AppRoutes.log,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(fullscreenDialog: true, child: ModuleScreen()),
        routes: [
          GoRoute(
            path: 'm/:code',
            builder: (context, state) =>
                ActivityScreen(code: state.pathParameters['code']!),
            routes: [
              GoRoute(
                path: 'details',
                builder: (context, state) => const DetailsScreen(),
              ),
              // Today's timetable card → "Other hours": Step 3 for a lecture.
              GoRoute(
                path: 'lecture/:row',
                builder: (context, state) {
                  final rowId = int.parse(state.pathParameters['row']!);
                  return PreparedDetailsScreen(
                    prepare: (ref) async {
                      final row = await ref
                          .read(roleRowsRepositoryProvider)
                          .byId(rowId);
                      if (row == null) return false;
                      await ref
                          .read(logFlowProvider.notifier)
                          .startLecture(row);
                      return true;
                    },
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'saved',
            builder: (context, state) => const SavedScreen(),
          ),
          GoRoute(
            path: 'other',
            builder: (context, state) => const OtherWorkScreen(),
          ),
        ],
      ),
      // Editing an entry opens Step 3 over the current tab; back returns there.
      GoRoute(
        path: '/edit/:id', // AppRoutes.editEntry
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return MaterialPage(
            fullscreenDialog: true,
            child: PreparedDetailsScreen(
              prepare: (ref) async {
                final entry = await ref
                    .read(entriesRepositoryProvider)
                    .byId(id);
                if (entry == null || entry.deletedAt != null) return false;
                final row = entry.roleRowId == null
                    ? null
                    : await ref
                          .read(roleRowsRepositoryProvider)
                          .byId(entry.roleRowId!);
                final locked = await ref
                    .read(periodsRepositoryProvider)
                    .isLocked(entry.date);
                ref
                    .read(logFlowProvider.notifier)
                    .loadEntry(entry, row, readOnly: locked);
                return true;
              },
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const Scaffold(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const WelcomeScreen(),
        routes: [
          GoRoute(
            path: 'workbook',
            builder: (context, state) => const LoadWorkbookScreen(),
          ),
          GoRoute(
            path: 'name',
            builder: (context, state) => const PickNameScreen(),
          ),
          GoRoute(
            path: 'reminder',
            builder: (context, state) => const ReminderTimeScreen(),
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, Widget screen) {
  return StatefulShellBranch(
    routes: [GoRoute(path: path, builder: (context, state) => screen)],
  );
}
