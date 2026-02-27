import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_state.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  // Preset quick-select options
  static const _presets = [5000, 7500, 10000, 12000, 15000];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: '${AppState.instance.goalSteps}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final goal = int.parse(_controller.text.trim());
    await AppState.instance.updateGoal(goal);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal saved! 🎯'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Daily Goal')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How many steps per day?',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The recommended daily goal is 10,000 steps.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Daily step goal',
                    suffixText: 'steps',
                    prefixIcon: Icon(Icons.directions_walk),
                  ),
                  validator: (val) {
                    final n = int.tryParse(val?.trim() ?? '');
                    if (n == null || n < 100) {
                      return 'Please enter a valid number (min 100)';
                    }
                    if (n > 100000) return 'Maximum goal is 100,000';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Quick select:',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: _presets.map((p) {
                    return ActionChip(
                      label: Text(
                          p >= 1000
                              ? '${p ~/ 1000}k'
                              : '$p',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.green.shade50,
                      side: BorderSide(color: Colors.green.shade300),
                      onPressed: () =>
                          _controller.text = '$p',
                    );
                  }).toList(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Goal',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}