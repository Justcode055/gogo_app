import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
	const HistoryCard({
		super.key,
		required this.date,
		required this.steps,
	});

	final String date;
	final int steps;

	@override
	Widget build(BuildContext context) {
		final Color accent = Colors.green.shade700; // darker shade for contrast

		return Card(
			elevation: 2,
			child: ListTile(
				leading: Icon(Icons.directions_walk, color: accent),
				title: Text(
					date,
					style: const TextStyle(fontWeight: FontWeight.w600),
				),
				trailing: Text(
					'$steps steps',
					style: TextStyle(
						color: accent,
						fontWeight: FontWeight.w600,
					),
				),
			),
		);
	}
}
