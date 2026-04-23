import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_constants.dart';
import '../../core/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _acceptedPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.onboardingDarkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppConstants.onboardingSurface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.onboardingAccent.withValues(alpha: 0.35),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_walk,
                  size: 100,
                  color: AppConstants.onboardingAccent,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to GoGo!',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  color: AppConstants.onboardingTextPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Track your daily steps,\nreach your goals, stay healthy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.onboardingTextPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _acceptedPrivacy,
                contentPadding: EdgeInsets.zero,
                activeColor: AppConstants.onboardingAccent,
                checkColor: AppConstants.onboardingTextPrimary,
                side: BorderSide(
                  color: AppConstants.onboardingTextPrimary.withValues(alpha: 0.75),
                  width: 1.4,
                ),
                onChanged: (value) {
                  setState(() {
                    _acceptedPrivacy = value ?? false;
                  });
                },
                title: Text(
                  'I agree to the Privacy Policy and consent to step data processing.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstants.onboardingTextPrimary.withValues(alpha: 0.9),
                    height: 1.35,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.onboardingAccent,
                    foregroundColor: AppConstants.onboardingTextPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _acceptedPrivacy
                      ? () async {
                    await AppState.instance.completeOnboarding(
                      consentGiven: _acceptedPrivacy,
                    );
                    if (context.mounted) context.go('/home/dashboard');
                  }
                      : null,
                  child: const Text('Get Started',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}