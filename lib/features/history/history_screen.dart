import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data Array for the assignment
    final List<Map<String, dynamic>> mockHistory = [
      {'date': 'Today', 'steps': 4250},
      {'date': 'Yesterday', 'steps': 8430},
      {'date': 'Monday', 'steps': 10200},
      {'date': 'Sunday', 'steps': 5120},
      {'date': 'Saturday', 'steps': 12050},
      {'date': 'Friday', 'steps': 7890},
      {'date': 'Thursday', 'steps': 9100},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Step History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Past 7 Days",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded( 
              child: ListView.builder(
                itemCount: mockHistory.length,
                itemBuilder: (context, index) {
                  final item = mockHistory[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.pets, color: Colors.green),
                      title: Text(item['date'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        "${item['steps']} steps",
                        style: const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}