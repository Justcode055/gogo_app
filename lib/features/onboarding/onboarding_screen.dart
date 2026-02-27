import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200,
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.directions_walk,
                    size: 100, color: Colors.green),
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to GoGo!',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Track your daily steps,\nreach your goals, stay healthy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    await AppState.instance.completeOnboarding();
                    if (context.mounted) context.go('/home/dashboard');
                  },
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