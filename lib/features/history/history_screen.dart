import 'package:flutter/material.dart';
import 'widgets/primary_action_button.dart'; 
import 'widgets/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atomic Test Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TESTING THE ATOM (Your Button)
            PrimaryActionButton(
              text: "Test My Custom Button", 
              onPressed: () {
                // This makes a little message pop up at the bottom!
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('The Atom Button Works!')),
                );
              },
            ),
            
            const SizedBox(height: 20),

            // 2. TESTING THE MOLECULE (Your Card)
            const HistoryCard(
              date: "Today", 
              steps: 5432,
            ),
          ],
        ),
      ),
    );
  }
}