import 'package:go_router/go_router.dart';
import 'app_state.dart';
import '../features/landing/landing_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/home_dashboard.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/goals/goal_setting_screen.dart';
import '../features/shell/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: AppState.instance,
  redirect: (context, state) {
    // Show splash while initializing
    if (!AppState.instance.isInitialized) {
      return '/';
    }

    final loggedIn = AppState.instance.isLoggedIn;
    final onboarded = AppState.instance.isOnboarded;
    final path = state.uri.path;
    final atLanding = path == '/';
    final atLogin = path == '/login';
    final atOnboarding = path == '/onboarding';
    final isPublic = atLanding || atLogin || atOnboarding;

    // Keep landing as the first stop for signed-out users.
    if (!loggedIn) {
      if (atLanding) return null;
      if (atLogin) {
        final fromLanding = state.uri.queryParameters['from'] == 'landing';
        return fromLanding ? null : '/';
      }
      return '/';
    }

    if (loggedIn && atLogin) {
      return onboarded ? '/home/dashboard' : '/onboarding';
    }

    if (onboarded && isPublic) return '/home/dashboard';
    if (!onboarded && !isPublic) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/onboarding',
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
