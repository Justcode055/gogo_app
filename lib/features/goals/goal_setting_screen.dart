import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_constants.dart';
import '../../core/app_state.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Preset quick-select options
  static const _presets = AppConstants.goalPresets;

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
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final raw = _controller.text;
    final sanitized = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final goal = int.parse(sanitized);

    setState(() => _isSaving = true);
    try {
      await AppState.instance.updateGoal(goal);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal saved! 🎯'),
          backgroundColor: AppConstants.brandPrimary,
        ),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipBg = isDark
        ? AppConstants.onboardingSurface
        : AppConstants.brandPrimary;
    final chipFg = isDark
        ? AppConstants.onboardingTextPrimary
        : Colors.white;

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
                  'The recommended daily goal is ${AppConstants.defaultDailyGoal} steps.',
                  style: TextStyle(color: AppConstants.brandTextMuted),
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
                    final sanitized =
                        (val ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                    final n = int.tryParse(sanitized);
                    if (n == null || n < AppConstants.minDailyGoal) {
                      return 'Please enter a valid number (min ${AppConstants.minDailyGoal})';
                    }
                    if (n > AppConstants.maxDailyGoal) {
                      return 'Maximum goal is ${AppConstants.maxDailyGoal}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Quick select:',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                    color: AppConstants.brandTextMuted)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _presets.map((p) {
                    return ActionChip(
                      avatar: Icon(
                        Icons.bolt,
                        size: 16,
                        color: chipFg,
                      ),
                      label: Text(
                          p >= 1000
                              ? '${p ~/ 1000}k'
                              : '$p',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: chipFg,
                          )),
                      backgroundColor: chipBg,
                      side: BorderSide(color: chipBg),
                      elevation: 0,
                      pressElevation: 0,
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
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.brandPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _isSaving ? 'Saving...' : 'Save Goal',
                      style: const TextStyle(fontSize: 18),
                    ),
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