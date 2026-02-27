import 'package:flutter/material.dart';
import '../models/step_entry.dart';
import '../services/storage_service.dart';
import '../services/step_service.dart';

/// Global app state — singleton ChangeNotifier.
/// Access as [AppState.instance].
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  final _storage = StorageService();

  int goalSteps = 10000;
  bool isDarkMode = false;
  bool isOnboarded = false;
  List<StepEntry> history = [];

  // ── Initialization ────────────────────────────────────
  Future<void> init() async {
    goalSteps = await _storage.getGoal();
    isDarkMode = await _storage.getDarkMode();
    isOnboarded = await _storage.isOnboarded();
    history = await _storage.getHistory();

    final savedBase = await _storage.getTodayBase();
    final savedDate = await _storage.getTodayDate();

    await StepService.instance.init(
      savedBase: savedBase,
      savedDate: savedDate,
      onNewDay: _onNewDay,
    );

    StepService.instance.addListener(_onStepUpdate);
    notifyListeners();
  }

  void _onStepUpdate() => notifyListeners();

  void _onNewDay(String date, int steps) async {
    if (steps > 0) {
      // Remove existing entry for that date then insert new one
      history.removeWhere((e) => e.date == date);
      history.insert(0, StepEntry(date: date, steps: steps));
      if (history.length > 30) history = history.take(30).toList();
      await _storage.saveHistory(history);
    }
    // Reset today base
    final base = StepService.instance.stepsToday;
    await _storage.saveTodayBase(base);
    await _storage.saveTodayDate(_todayString());
    notifyListeners();
  }

  // ── Today's steps ─────────────────────────────────────
  int get todaySteps => StepService.instance.stepsToday;
  bool get stepsAvailable => StepService.instance.isAvailable;
  bool get canRequestStepPermission => StepService.instance.canRequestPermission;

  Future<bool> requestStepPermission() async {
    final granted = await StepService.instance.requestPermissionAndStart();
    notifyListeners();
    return granted;
  }

  // ── Goal ──────────────────────────────────────────────
  Future<void> updateGoal(int goal) async {
    goalSteps = goal;
    await _storage.saveGoal(goal);
    notifyListeners();
  }

  // ── Dark mode ─────────────────────────────────────────
  Future<void> toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    await _storage.saveDarkMode(isDarkMode);
    notifyListeners();
  }

  // ── Onboarding ────────────────────────────────────────
  Future<void> completeOnboarding() async {
    isOnboarded = true;
    await _storage.setOnboarded();
    notifyListeners();
  }

  // ── Save today progress on app pause ─────────────────
  Future<void> saveSession() async {
    final base = StepService.instance.baseSteps;
    await _storage.saveTodayBase(base == 0 ? await _storage.getTodayBase() : base);
    await _storage.saveTodayDate(_todayString());
  }

  static String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
