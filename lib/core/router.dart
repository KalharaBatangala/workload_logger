import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/history/screens/history_screen.dart';
import '../features/log/screens/log_screen.dart';
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
}

/// One router per [ProviderScope], so each test gets a fresh navigation state.
final routerProvider = Provider<GoRouter>((ref) {
  final router = createRouter();
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createRouter() {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.today,
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
            const MaterialPage(fullscreenDialog: true, child: LogScreen()),
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, Widget screen) {
  return StatefulShellBranch(
    routes: [GoRoute(path: path, builder: (context, state) => screen)],
  );
}
