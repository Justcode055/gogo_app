import 'package:shared_preferences/shared_preferences.dart';
import '../models/step_entry.dart';

class StorageService {
  static const _goalKey = 'daily_goal';
  static const _darkModeKey = 'dark_mode';
  static const _historyKey = 'step_history';
  static const _onboardedKey = 'onboarded';
  static const _todayBaseKey = 'today_base_steps';
  static const _todayDateKey = 'today_date';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ── Goal ──────────────────────────────────────────────
  Future<int> getGoal() async {
    final p = await _prefs;
    return p.getInt(_goalKey) ?? 10000;
  }

  Future<void> saveGoal(int goal) async {
    final p = await _prefs;
    await p.setInt(_goalKey, goal);
  }

  // ── Dark mode ─────────────────────────────────────────
  Future<bool> getDarkMode() async {
    final p = await _prefs;
    return p.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveDarkMode(bool value) async {
    final p = await _prefs;
    await p.setBool(_darkModeKey, value);
  }

  // ── Onboarding ────────────────────────────────────────
  Future<bool> isOnboarded() async {
    final p = await _prefs;
    return p.getBool(_onboardedKey) ?? false;
  }

  Future<void> setOnboarded() async {
    final p = await _prefs;
    await p.setBool(_onboardedKey, true);
  }

  // ── History ───────────────────────────────────────────
  Future<List<StepEntry>> getHistory() async {
    final p = await _prefs;
    final raw = p.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    return StepEntry.listFromJsonString(raw);
  }

  Future<void> saveHistory(List<StepEntry> history) async {
    final p = await _prefs;
    await p.setString(_historyKey, StepEntry.listToJsonString(history));
  }

  // ── Today step base ───────────────────────────────────
  /// Raw cumulative pedometer reading at the start of today.
  Future<int> getTodayBase() async {
    final p = await _prefs;
    return p.getInt(_todayBaseKey) ?? 0;
  }

  Future<void> saveTodayBase(int base) async {
    final p = await _prefs;
    await p.setInt(_todayBaseKey, base);
  }

  Future<String> getTodayDate() async {
    final p = await _prefs;
    return p.getString(_todayDateKey) ?? '';
  }

  Future<void> saveTodayDate(String date) async {
    final p = await _prefs;
    await p.setString(_todayDateKey, date);
  }
}
