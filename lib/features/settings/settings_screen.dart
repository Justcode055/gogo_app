import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isDark = AppState.instance.isDarkMode;
        final goal = AppState.instance.goalSteps;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // ── Appearance ───────────────────────────
              const _SectionHeader(title: 'Appearance'),
              Card(
                child: SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: isDark ? Colors.indigo : Colors.amber,
                  ),
                  title: const Text('Dark Mode'),
                  subtitle: Text(isDark ? 'Dark theme on' : 'Light theme on'),
                  value: isDark,
                  activeThumbColor: Colors.green,
                  onChanged: (_) => AppState.instance.toggleDarkMode(),
                ),
              ),
              const SizedBox(height: 16),
              // ── Goal ──────────────────────────────────
              const _SectionHeader(title: 'Step Goal'),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.flag, color: Colors.green),
                  title: const Text('Daily Step Goal'),
                  subtitle: Text('$goal steps per day'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/goals'),
                ),
              ),
              const SizedBox(height: 16),
              // ── About ─────────────────────────────────
              const _SectionHeader(title: 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline,
                          color: Colors.blue),
                      title: const Text('Version'),
                      trailing: const Text('1.0.0',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.directions_walk, color: Colors.green),
                      title: const Text('GoGo Step Tracker'),
                      subtitle: const Text(
                          'Stay active, reach your goals!'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}