import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
	const PrimaryActionButton({
		super.key,
		required this.text,
		required this.onPressed,
	});

	final String text;
	final VoidCallback onPressed;

	@override
	Widget build(BuildContext context) {
		return ElevatedButton(
			style: ElevatedButton.styleFrom(
				backgroundColor: Colors.green,
				foregroundColor: Colors.white,
				padding: const EdgeInsets.all(16),
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(8),
				),
			),
			onPressed: onPressed,
			child: Text(text),
		);
	}
}
