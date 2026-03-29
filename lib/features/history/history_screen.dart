import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../models/step_entry.dart';
import '../../services/step_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final goal = AppState.instance.goalSteps;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Step History'),
          ),
          body: FutureBuilder<List<StepEntry>>(
            future: StepService.instance.fetchHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Could not load history from Firestore. Please try again.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final entries = snapshot.data ?? [];
              if (entries.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No history yet. Start walking!',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await StepService.instance.fetchHistory();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return HistoryCard(
                      entry: entries[index],
                      goal: goal,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class HistoryCard extends StatelessWidget {
  final StepEntry entry;
  final int goal;

  const HistoryCard({
    super.key,
    required this.entry,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (entry.steps / goal).clamp(0.0, 1.0);
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
                  reached ? Icons.check_circle : Icons.directions_walk,
                  color: reached ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.displayDate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  '${entry.steps} steps',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: reached ? Colors.green : Colors.orange,
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  reached ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              reached
                  ? 'Goal reached!'
                  : '${(percent * 100).toStringAsFixed(0)}% of $goal goal',
              style: TextStyle(
                fontSize: 12,
                color: reached ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}