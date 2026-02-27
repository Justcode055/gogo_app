import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../models/step_entry.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final goal = AppState.instance.goalSteps;
        final today = AppState.instance.todaySteps;
        final todayKey = _todayString();

        // Merge persisted history with today's live steps
        final List<StepEntry> all = [
          StepEntry(date: todayKey, steps: today),
          ...AppState.instance.history
              .where((e) => e.date != todayKey),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Step History'),
          ),
          body: all.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No history yet. Start walking!',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: all.length,
                  itemBuilder: (context, index) {
                    final entry = all[index];
                    final percent =
                        (entry.steps / goal).clamp(0.0, 1.0);
                    final reached = entry.steps >= goal;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  reached
                                      ? Icons.check_circle
                                      : Icons.directions_walk,
                                  color: reached
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    entry.displayDate,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  '${entry.steps} steps',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: reached
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  reached ? Colors.green : Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              reached
                                  ? 'Goal reached! 🎉'
                                  : '${(percent * 100).toStringAsFixed(0)}% of $goal goal',
                              style: TextStyle(
                                fontSize: 12,
                                color: reached
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  static String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}