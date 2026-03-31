import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/app_constants.dart';
import '../../core/app_state.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final steps = AppState.instance.todaySteps;
        final goal = AppState.instance.goalSteps;
        final available = AppState.instance.stepsAvailable;
        final safeGoal = goal <= 0 ? 1 : goal;
        final percent = (steps / safeGoal).clamp(0.0, 1.0);

        return Scaffold(
          appBar: AppBar(
            title: const Text('GoGo',
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.flag_outlined),
                tooltip: 'Change Goal',
                onPressed: () => context.push('/goals'),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  DailyProgressRing(
                    available: available,
                    steps: steps,
                    percent: percent,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.my_location,
                        label: 'Goal',
                        value: '$goal',
                        unit: 'steps',
                        color: AppConstants.brandTextPrimary,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.check_circle_outline,
                        label: 'Done',
                        value: '${(percent * 100).toStringAsFixed(0)}%',
                        unit: 'of goal',
                        color: AppConstants.brandPrimary,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.local_fire_department,
                        label: 'Calories',
                        value: (steps * 0.04).toStringAsFixed(0),
                        unit: 'kcal',
                        color: AppConstants.brandWarning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConstants.brandPrimary,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppConstants.brandPrimary,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _motivationalText(percent),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.onboardingDarkBg),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!available) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.brandSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppConstants.brandWarning),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: AppConstants.brandWarning),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Step counting unavailable on this device or permission denied.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (AppState.instance.canRequestStepPermission) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final granted = await AppState.instance.requestStepPermission();
                            if (context.mounted && !granted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permission is required to count steps.'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.lock_open),
                          label: const Text('Allow Activity Permission'),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/home/history'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.brandPrimary,
                        foregroundColor: AppConstants.onboardingDarkBg,
                        side: const BorderSide(
                          color: AppConstants.brandPrimary,
                          width: 1.2,
                        ),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.history),
                      label: const Text('View History',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _motivationalText(double percent) {
    if (percent >= 1.0) return 'Goal reached! Amazing work today! 🎉';
    if (percent >= 0.75) return "Almost there! You're crushing it! 💪";
    if (percent >= 0.5) return 'Halfway done — keep the momentum going!';
    if (percent >= 0.25) return 'Good start! Every step counts. 🚶';
    return 'Start walking to reach your goal today!';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.brandSurfaceAlt,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(unit,
                style: TextStyle(
                    fontSize: 11,
                    color: AppConstants.onboardingDarkBg.withValues(alpha: 0.8))),
          ],
        ),
      ),
    );
  }
}

class DailyProgressRing extends StatelessWidget {
  final bool available;
  final int steps;
  final double percent;

  const DailyProgressRing({
    super.key,
    required this.available,
    required this.steps,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 130.0,
      lineWidth: 16.0,
      percent: percent,
      center: Container(
        width: 188,
        height: 188,
        decoration: BoxDecoration(
          color: AppConstants.brandPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppConstants.brandPrimary,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              available ? '$steps' : '--',
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: AppConstants.onboardingDarkBg,
              ),
            ),
            Text(
              'steps',
              style: TextStyle(
                  fontSize: 18,
                  color: AppConstants.onboardingDarkBg.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      progressColor: AppConstants.brandPrimary,
      backgroundColor: AppConstants.brandSurfaceAlt,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animateFromLastPercent: true,
    );
  }
}
