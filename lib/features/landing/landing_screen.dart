import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_constants.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppConstants.brandSurfaceAlt),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.brandPrimary.withValues(alpha: 0.18),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_walk,
                      size: 64,
                      color: AppConstants.brandGreenDark,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'GoGo',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.brandGreenDark,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'A simple way to build healthy walking habits every day.',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppConstants.brandTextPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppConstants.brandSurfaceAlt),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.track_changes, color: AppConstants.brandPrimary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Track steps, set goals, and review progress in one place.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () => context.go('/onboarding'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConstants.brandGreenDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      'Get Started',
                      style: TextStyle(
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
                    onPressed: () => context.go('/onboarding'),
                    child: const Text('Continue to onboarding'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
