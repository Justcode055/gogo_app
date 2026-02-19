import 'package:go_router/go_router.dart';

// Import all your screen files
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/home_dashboard.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/goals/goal_setting_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // The app starts here
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const HomeDashboardScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/goals',
      builder: (context, state) => const GoalSettingScreen(),
    ),
  ],
);