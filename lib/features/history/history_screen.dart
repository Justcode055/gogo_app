import 'package:flutter/material.dart';
import '../../core/app_constants.dart';
import '../../core/app_state.dart';
import '../../models/step_entry.dart';
import '../../services/step_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<StepEntry>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = StepService.instance.fetchHistory();
  }

  Future<void> _refresh() async {
    final latest = await StepService.instance.fetchHistory();
    if (!mounted) return;
    setState(() {
      _historyFuture = Future.value(latest);
    });
  }

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
            initialData: AppState.instance.history,
            future: _historyFuture,
            builder: (context, snapshot) {
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
                      Icon(
                        Icons.history,
                        size: 64,
                        color: AppConstants.brandTextMuted,
                      ),
                      SizedBox(height: 12),
                      Text('No history yet. Start walking!',
                          style: TextStyle(color: AppConstants.brandTextMuted)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
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
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  reached ? Icons.check_circle : Icons.directions_walk,
                  size: 22,
                  color: reached
                      ? AppConstants.brandPrimary
                      : AppConstants.brandTextMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.displayDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '${entry.steps} steps',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: reached
                        ? AppConstants.brandPrimary
                        : AppConstants.brandWarning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 9,
                backgroundColor: AppConstants.brandSurfaceAlt,
                valueColor: AlwaysStoppedAnimation<Color>(
                  reached ? AppConstants.brandPrimary : AppConstants.brandWarning,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reached
                  ? 'Goal reached!'
                  : '${(percent * 100).toStringAsFixed(0)}% of $goal goal',
              style: TextStyle(
                fontSize: 12.5,
                color: reached
                    ? AppConstants.brandPrimary
                    : AppConstants.brandTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}