import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoggedIn = false;
  bool keepSignedIn = true;
  String userId = '';
  List<StepEntry> history = [];
  int _lastPersistedBase = 0;
  bool _cloudEnabled = false;

  // ── Initialization ────────────────────────────────────
  Future<void> init({bool cloudEnabled = true}) async {
    _cloudEnabled = cloudEnabled;
    goalSteps = await _storage.getGoal();
    isDarkMode = await _storage.getDarkMode();
    isOnboarded = await _storage.isOnboarded();
    hasPrivacyConsent = await _storage.getPrivacyConsent();
    keepSignedIn = await _storage.getKeepSignedIn();
    userId = await _resolveRuntimeUserId(cloudEnabled: cloudEnabled);
    history = await _storage.getHistory();

    final savedBase = await _storage.getTodayBase();
    final savedDate = await _storage.getTodayDate();
    _lastPersistedBase = savedBase;

    await StepService.instance.init(
      userId: userId,
      goalSteps: goalSteps,
      savedBase: savedBase,
      savedDate: savedDate,
      cloudEnabled: _cloudEnabled && isLoggedIn,
      onNewDay: _onNewDay,
    );

    StepService.instance.addListener(_onStepUpdate);
    notifyListeners();
  }

  Future<String> _resolveRuntimeUserId({required bool cloudEnabled}) async {
    final localId = await _storage.getOrCreateUserId();
    if (!cloudEnabled) return localId;

    try {
      final auth = FirebaseAuth.instance;
      if (!keepSignedIn && auth.currentUser != null) {
        await auth.signOut();
        isLoggedIn = false;
        return localId;
      }

      final currentUser = auth.currentUser;
      final uid = currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        isLoggedIn = false;
        return localId;
      }

      isLoggedIn = true;
      return uid;
    } catch (err, stack) {
      debugPrint('Auth check failed, fallback to local user id: $err');
      debugPrintStack(stackTrace: stack);
      isLoggedIn = false;
      return localId;
    }
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
    required bool rememberSignedIn,
  }) async {
    if (!_cloudEnabled) return 'Cloud auth is unavailable right now.';

    try {
      await _storage.setKeepSignedIn(rememberSignedIn);
      keepSignedIn = rememberSignedIn;

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null || uid.isEmpty) {
        return 'Sign-in failed. Please try again.';
      }

      isLoggedIn = true;
      userId = uid;
      await StepService.instance.updateUserContext(
        userId: uid,
        goalSteps: goalSteps,
        cloudEnabled: true,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (err) {
      return _mapAuthError(err, fallback: 'Unable to sign in.');
    } catch (_) {
      return 'Unable to sign in right now.';
    }
  }

  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required bool rememberSignedIn,
  }) async {
    if (!_cloudEnabled) return 'Cloud auth is unavailable right now.';

    try {
      await _storage.setKeepSignedIn(rememberSignedIn);
      keepSignedIn = rememberSignedIn;

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null || uid.isEmpty) {
        return 'Registration failed. Please try again.';
      }

      isLoggedIn = true;
      userId = uid;
      await StepService.instance.updateUserContext(
        userId: uid,
        goalSteps: goalSteps,
        cloudEnabled: true,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (err) {
      return _mapAuthError(err, fallback: 'Unable to register.');
    } catch (_) {
      return 'Unable to register right now.';
    }
  }

  Future<String?> sendPasswordReset(String email) async {
    if (!_cloudEnabled) return 'Cloud auth is unavailable right now.';

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (err) {
      return _mapAuthError(err, fallback: 'Unable to send reset email.');
    } catch (_) {
      return 'Unable to send reset email right now.';
    }
  }

  Future<void> signOut() async {
    try {
      if (_cloudEnabled) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (_) {
      // Keep local sign-out flow resilient even if Firebase sign-out fails.
    }

    final localId = await _storage.getOrCreateUserId();
    isLoggedIn = false;
    userId = localId;
    keepSignedIn = false;
    await _storage.setKeepSignedIn(false);
    await StepService.instance.updateUserContext(
      userId: localId,
      goalSteps: goalSteps,
      cloudEnabled: false,
    );
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
    final safeGoal = goal.clamp(
      AppConstants.minDailyGoal,
      AppConstants.maxDailyGoal,
    );

    await _storage.saveGoal(safeGoal);
    final persistedGoal = await _storage.getGoal();
    goalSteps = persistedGoal;

    // Keep UI responsive: local persistence is authoritative, cloud sync is best-effort.
    unawaited(
      StepService.instance.syncGoal(persistedGoal).catchError((Object err, StackTrace stack) {
        debugPrint('Goal cloud sync failed: $err');
        debugPrintStack(stackTrace: stack);
      }),
    );

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
    isLoggedIn = false;
    history = [];
    userId = freshUserId;

    await StepService.instance.updateUserContext(
      userId: userId,
      goalSteps: goalSteps,
      cloudEnabled: false,
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

  String _mapAuthError(FirebaseAuthException err, {required String fallback}) {
    switch (err.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      case 'configuration-not-found':
        return 'Firebase Auth is not fully configured for this app yet. Please complete Android SHA setup and re-download google-services.json.';
      default:
        final message = err.message ?? fallback;
        if (message.contains('CONFIGURATION_NOT_FOUND')) {
          return 'Firebase Auth configuration is missing for this app. Check Android SHA fingerprints and Authentication settings in Firebase.';
        }
        return message;
    }
  }
}
