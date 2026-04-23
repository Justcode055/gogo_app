import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_constants.dart';
import '../../core/app_state.dart';
import 'landing_copy.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const _selectedTone = LandingTone.fitnessCoach;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = LandingCopy.bundle(context, tone: _selectedTone);

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        if (!AppState.instance.isInitialized) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppConstants.brandSurface, Colors.white],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppConstants.brandSurfaceAlt),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.brandPrimary.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Image.asset(
                          'assets/branding/app_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      copy.appName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppConstants.brandGreenDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 28,
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        color: AppConstants.brandPrimary,
                        backgroundColor: AppConstants.brandSurfaceAlt,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppConstants.brandSurface, Colors.white],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth > 720
                      ? 560.0
                      : constraints.maxWidth;

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 106,
                                height: 106,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppConstants.brandSurfaceAlt,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.brandPrimary
                                          .withValues(alpha: 0.16),
                                      blurRadius: 26,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Image.asset(
                                    'assets/branding/app_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              copy.appName,
                              style: textTheme.displaySmall?.copyWith(
                                color: AppConstants.brandGreenDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              copy.headline,
                              style: textTheme.titleMedium?.copyWith(
                                color: AppConstants.brandTextPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              copy.intro,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppConstants.brandTextMuted,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _StaggeredEntrance(
                              delay: const Duration(milliseconds: 70),
                              child: _OverviewMetricRow(copy: copy),
                            ),
                            const SizedBox(height: 18),
                            _StaggeredEntrance(
                              delay: const Duration(milliseconds: 130),
                              child: _FeatureTile(
                                icon: Icons.track_changes,
                                title: copy.featureTrackingTitle,
                                description: copy.featureTrackingDescription,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _StaggeredEntrance(
                              delay: const Duration(milliseconds: 200),
                              child: _FeatureTile(
                                icon: Icons.flag_outlined,
                                title: copy.featureGoalTitle,
                                description: copy.featureGoalDescription,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _StaggeredEntrance(
                              delay: const Duration(milliseconds: 270),
                              child: _FeatureTile(
                                icon: Icons.history,
                                title: copy.featureHistoryTitle,
                                description: copy.featureHistoryDescription,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppConstants.brandSurfaceAlt,
                                ),
                              ),
                              child: Text(
                                copy.ctaSupportText,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppConstants.brandTextPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: FilledButton.icon(
                                onPressed: () =>
                                    context.go('/login?from=landing'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppConstants.brandGreenDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_forward),
                                label: Text(
                                  copy.primaryCta,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () =>
                                    context.go('/login?from=landing'),
                                child: Text(copy.secondaryCta),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OverviewMetricRow extends StatelessWidget {
  final LandingCopyBundle copy;

  const _OverviewMetricRow({required this.copy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(value: '1', label: copy.metricDashboardLabel),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(value: '7', label: copy.metricHistoryLabel),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(value: '24/7', label: copy.metricMotivationLabel),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;

  const _MetricCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConstants.brandSurfaceAlt),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppConstants.brandGreenDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.brandTextMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConstants.brandSurfaceAlt),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppConstants.brandSurface,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 20, color: AppConstants.brandPrimary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppConstants.brandTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.brandTextMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _StaggeredEntrance({required this.child, required this.delay});

  @override
  State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<_StaggeredEntrance> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.04),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOut,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
