import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_constants.dart';
import '../../core/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _goalFormKey = GlobalKey<FormState>();
  late final TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _goalController =
        TextEditingController(text: '${AppState.instance.goalSteps}');
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    if (!_goalFormKey.currentState!.validate()) return;
    final goal = int.parse(_goalController.text.trim());
    await AppState.instance.updateGoal(goal);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daily goal updated.')),
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Delete account and data?'),
              content: const Text(
                'This will permanently delete your Firestore history and local app data.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppConstants.brandDanger,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) return;

    await AppState.instance.deleteAccountAndData();
    if (!mounted) return;
    context.go('/');
  }

  Future<void> _signOut() async {
    await AppState.instance.signOut();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isDark = AppState.instance.isDarkMode;

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
                    color: isDark
                        ? AppConstants.onboardingTextSecondary
                        : AppConstants.brandWarning,
                  ),
                  title: const Text('Dark Mode'),
                  subtitle: Text(
                    isDark ? 'Dark theme on' : 'Light theme on',
                    style: const TextStyle(color: AppConstants.brandTextMuted),
                  ),
                  value: isDark,
                  activeThumbColor: AppConstants.brandPrimary,
                  onChanged: (_) => AppState.instance.toggleDarkMode(),
                ),
              ),
              const SizedBox(height: 16),
              // ── Goal ──────────────────────────────────
              const _SectionHeader(title: 'Step Goal'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _goalFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Step Goal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _goalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter step goal',
                            suffixText: 'steps',
                          ),
                          validator: (value) {
                            final input = value?.trim() ?? '';
                            if (!RegExp(r'^\d+$').hasMatch(input)) {
                              return 'Only numbers are allowed';
                            }
                            final goalValue = int.parse(input);
                            if (goalValue < AppConstants.minDailyGoal) {
                              return 'Goal must be at least ${AppConstants.minDailyGoal}';
                            }
                            if (goalValue > AppConstants.maxDailyGoal) {
                              return 'Goal must be at most ${AppConstants.maxDailyGoal}';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: _saveGoal,
                            child: const Text('Save goal'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _SectionHeader(title: 'Account'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppConstants.brandWarning),
                  title: const Text('Sign out'),
                  subtitle: const Text(
                    'Log out of this device',
                    style: TextStyle(color: AppConstants.brandTextMuted),
                  ),
                  onTap: _signOut,
                ),
              ),
              const SizedBox(height: 16),
              // ── Privacy ───────────────────────────────
              const _SectionHeader(title: 'Privacy'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.verified_user,
                        color: AppConstants.brandPrimary,
                      ),
                      title: const Text('Privacy Consent'),
                      subtitle: Text(
                        AppState.instance.hasPrivacyConsent
                            ? 'Consent granted'
                            : 'Consent not granted',
                        style: const TextStyle(color: AppConstants.brandTextMuted),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_forever,
                        color: AppConstants.brandDanger,
                      ),
                      title: const Text('Delete Account & Data'),
                      subtitle: const Text(
                        'Remove all Firestore and local data',
                        style: TextStyle(color: AppConstants.brandTextMuted),
                      ),
                      onTap: _deleteAccount,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ── About ─────────────────────────────────
              const _SectionHeader(title: 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: AppConstants.brandPrimary,
                      ),
                      title: const Text('Version'),
                      trailing: const Text('1.0.0',
                          style: TextStyle(color: AppConstants.brandTextMuted)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.directions_walk, color: AppConstants.brandPrimary),
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
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}