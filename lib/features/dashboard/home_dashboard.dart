import 'package:flutter/material.dart';
import 'widgets/daily_progress_ring.dart'; // Importing your new component!

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data to test the ring
    const int todaySteps = 6430;
    const int dailyGoal = 10000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GoGo Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // TESTING THE COMPLEX COMPONENT
            const DailyProgressRing(
              currentSteps: todaySteps,
              goalSteps: dailyGoal,
            ),
            
            const SizedBox(height: 40),
            
            const Text(
              "Goal: $dailyGoal steps",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}