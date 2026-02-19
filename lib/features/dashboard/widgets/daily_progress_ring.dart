import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DailyProgressRing extends StatelessWidget {
  const DailyProgressRing({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
  });

  final int currentSteps;
  final int goalSteps;

  @override
  Widget build(BuildContext context) {
    final int safeGoal = goalSteps <= 0 ? 1 : goalSteps;
    final double percent = (currentSteps / safeGoal).clamp(0, 1).toDouble();

    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 15.0,
      percent: percent,
      progressColor: Colors.green,
      backgroundColor: Colors.green.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$currentSteps',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Steps',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
