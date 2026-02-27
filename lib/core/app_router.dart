import 'package:go_router/go_router.dart';
import 'app_state.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/home_dashboard.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/goals/goal_setting_screen.dart';
import '../features/shell/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final onboarded = AppState.instance.isOnboarded;
    final atOnboarding = state.uri.path == '/';
    if (onboarded && atOnboarding) return '/home/dashboard';
    if (!onboarded && !atOnboarding) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/dashboard',
              builder: (context, state) => const HomeDashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/goals',
      builder: (context, state) => const GoalSettingScreen(),
    ),
  ],
);