import 'dart:async';
import 'package:flutter/material.dart';
import 'app_constants.dart';
import '../models/step_entry.dart';
import '../services/storage_service.dart';
import '../services/step_service.dart';

/// Global app state — singleton ChangeNotifier.
/// Access as [AppState.instance].
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  final _storage = StorageService();

  int goalSteps = AppConstants.defaultDailyGoal;
  bool isDarkMode = false;
  bool isOnboarded = false;
  bool hasPrivacyConsent = false;
  String userId = '';
  List<StepEntry> history = [];
  int _lastPersistedBase = 0;

  // ── Initialization ────────────────────────────────────
  Future<void> init({bool cloudEnabled = true}) async {
    goalSteps = await _storage.getGoal();
    isDarkMode = await _storage.getDarkMode();
    isOnboarded = await _storage.isOnboarded();
    hasPrivacyConsent = await _storage.getPrivacyConsent();
    userId = await _storage.getOrCreateUserId();
    history = await _storage.getHistory();

    final savedBase = await _storage.getTodayBase();
    final savedDate = await _storage.getTodayDate();
    _lastPersistedBase = savedBase;

    await StepService.instance.init(
      userId: userId,
      goalSteps: goalSteps,
      savedBase: savedBase,
      savedDate: savedDate,
      cloudEnabled: cloudEnabled,
      onNewDay: _onNewDay,
    );

    StepService.instance.addListener(_onStepUpdate);
    notifyListeners();
  }

  void _onStepUpdate() {
    unawaited(_persistTodayBaseIfNeeded());
    notifyListeners();
  }

  Future<void> _persistTodayBaseIfNeeded() async {
    final currentBase = StepService.instance.baseSteps;
    if (currentBase > 0 && currentBase != _lastPersistedBase) {
      await _storage.saveTodayBase(currentBase);
      await _storage.saveTodayDate(_todayString());
      _lastPersistedBase = currentBase;
    }
  }

  void _onNewDay(String date, int steps, int newBaseRaw) async {
    if (steps > 0) {
      // Remove existing entry for that date then insert new one
      history.removeWhere((e) => e.date == date);
      history.insert(0, StepEntry(date: date, steps: steps));
      if (history.length > AppConstants.maxHistoryDays) {
        history = history.take(AppConstants.maxHistoryDays).toList();
      }
      await _storage.saveHistory(history);
    }
    // Reset today base
    await _storage.saveTodayBase(newBaseRaw);
    await _storage.saveTodayDate(_todayString());
    _lastPersistedBase = newBaseRaw;
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
    try {
      await StepService.instance.syncGoal(goal);
    } catch (err, stack) {
      debugPrint('Goal cloud sync failed: $err');
      debugPrintStack(stackTrace: stack);
    }
    notifyListeners();
  }

  // ── Dark mode ─────────────────────────────────────────
  Future<void> toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    await _storage.saveDarkMode(isDarkMode);
    notifyListeners();
  }

  // ── Onboarding ────────────────────────────────────────
  Future<void> completeOnboarding({required bool consentGiven}) async {
    isOnboarded = true;
    hasPrivacyConsent = consentGiven;
    await _storage.setOnboarded();
    await _storage.setPrivacyConsent(consentGiven);
    notifyListeners();
  }

  Future<void> deleteAccountAndData() async {
    await StepService.instance.deleteAccountAndData();
    final freshUserId = await _storage.resetForFreshStart();

    goalSteps = AppConstants.defaultDailyGoal;
    isDarkMode = false;
    isOnboarded = false;
    hasPrivacyConsent = false;
    history = [];
    userId = freshUserId;

    await StepService.instance.updateUserContext(
      userId: freshUserId,
      goalSteps: goalSteps,
    );

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
