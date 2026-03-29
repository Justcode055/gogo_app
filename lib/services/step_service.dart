import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/app_constants.dart';
import '../models/step_entry.dart';

/// Wraps the [pedometer] package.
/// Exposes [stepsToday] — steps walked since midnight.
class StepService extends ChangeNotifier {
  static final StepService instance = StepService._();
  StepService._();

  bool _cloudEnabled = false;

  int _rawTotal = 0;   // cumulative from pedometer (since last boot)
  int _baseSteps = 0;  // raw total at start of today
  String _todayKey = '';
  String _userId = '';
  int _goalSteps = AppConstants.defaultDailyGoal;
  bool _available = true;
  bool _supported = true;
  bool _permissionGranted = false;
  bool _pendingInitialRollover = false;
  int _pendingSavedBase = 0;
  String _pendingSavedDate = '';

  late Function(String date, int steps, int newBaseRaw) _onNewDay;

  StreamSubscription<StepCount>? _sub;

  int get stepsToday => (_rawTotal - _baseSteps).clamp(0, 999999);
  bool get isAvailable => _available;
  bool get canRequestPermission => _supported && !_permissionGranted;
  int get baseSteps => _baseSteps;

  Stream<int> get liveStepsStream {
    final userDoc = _userDoc;
    if (_userId.isEmpty || userDoc == null) {
      return Stream<int>.value(stepsToday);
    }
    return userDoc.snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return stepsToday;
      final liveToday = data['todayKey'] == _todayString()
          ? (data['todaySteps'] as int? ?? 0)
          : 0;
      return liveToday;
    }).distinct();
  }

  FirebaseFirestore? get _firestore {
    if (!_cloudEnabled || Firebase.apps.isEmpty) return null;
    return FirebaseFirestore.instance;
  }

  DocumentReference<Map<String, dynamic>>? get _userDoc {
    final firestore = _firestore;
    if (firestore == null || _userId.isEmpty) return null;
    return firestore.collection(AppConstants.usersCollection).doc(_userId);
  }

  static String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> init({
    required String userId,
    required int goalSteps,
    required int savedBase,
    required String savedDate,
    required bool cloudEnabled,
    required Function(String date, int steps, int newBaseRaw) onNewDay,
  }) async {
    _userId = userId;
    _goalSteps = goalSteps;
    _onNewDay = onNewDay;
    _cloudEnabled = cloudEnabled;
    _todayKey = _todayString();

    await _ensureUserDoc();

    // On web, pedometer is not supported
    if (kIsWeb) {
      _supported = false;
      _available = false;
      notifyListeners();
      return;
    }

    _baseSteps = 0;
    if (savedDate == _todayKey) {
      _baseSteps = savedBase;
    } else if (savedDate.isNotEmpty && savedBase > 0) {
      _pendingSavedDate = savedDate;
      _pendingSavedBase = savedBase;
      _pendingInitialRollover = true;
    }

    await requestPermissionAndStart();
  }

  Future<void> updateUserContext({
    required String userId,
    required int goalSteps,
  }) async {
    _userId = userId;
    _goalSteps = goalSteps;
    await _ensureUserDoc();
    await _syncLiveDataToFirestore();
    notifyListeners();
  }

  Future<void> syncGoal(int goalSteps) async {
    _goalSteps = goalSteps;
    final userDoc = _userDoc;
    if (_userId.isEmpty || userDoc == null) return;
    await userDoc.set(
      {
        'goalSteps': goalSteps,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<List<StepEntry>> fetchHistory() async {
    final userDoc = _userDoc;
    if (_userId.isEmpty || userDoc == null) return [];

    final historySnap = await userDoc
        .collection(AppConstants.historyCollection)
        .orderBy('date', descending: true)
        .limit(AppConstants.maxHistoryDays)
        .get();

    final entries = historySnap.docs
        .map((d) => StepEntry.fromJson(d.data()))
        .toList();

    final liveDoc = await userDoc.get();
    final liveData = liveDoc.data();
    if (liveData != null) {
      final liveDate = liveData['todayKey'] as String? ?? _todayString();
      final liveSteps = liveData['todaySteps'] as int? ?? 0;
      if (liveSteps > 0 && entries.every((e) => e.date != liveDate)) {
        entries.insert(0, StepEntry(date: liveDate, steps: liveSteps));
      }
    }

    return entries;
  }

  Future<void> deleteAccountAndData() async {
    final userDoc = _userDoc;
    final firestore = _firestore;
    if (_userId.isEmpty || userDoc == null || firestore == null) return;

    final history = await userDoc.collection(AppConstants.historyCollection).get();
    final batch = firestore.batch();

    for (final doc in history.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(userDoc);
    await batch.commit();
  }

  Future<bool> requestPermissionAndStart() async {
    if (!_supported || kIsWeb) {
      _available = false;
      notifyListeners();
      return false;
    }

    try {
      var status = await Permission.activityRecognition.status;
      if (status.isDenied) {
        status = await Permission.activityRecognition.request();
      }
      if (!status.isGranted) {
        _permissionGranted = false;
        _available = false;
        notifyListeners();
        return false;
      }
    } catch (_) {
      _permissionGranted = false;
      _available = false;
      notifyListeners();
      return false;
    }

    _permissionGranted = true;
    _available = true;

    if (_sub != null) {
      notifyListeners();
      return true;
    }

    _sub = Pedometer.stepCountStream.listen(
      (StepCount event) {
        _rawTotal = event.steps;

        if (_pendingInitialRollover) {
          final previousDaySteps = (event.steps - _pendingSavedBase).clamp(0, 999999);
          _onNewDay(_pendingSavedDate, previousDaySteps, event.steps);
          unawaited(_saveHistoryToFirestore(_pendingSavedDate, previousDaySteps));
          _pendingInitialRollover = false;
        }

        final today = _todayString();
        if (today != _todayKey) {
          // Midnight rolled over
          final previousDate = _todayKey;
          final previousDaySteps = stepsToday;
          _baseSteps = event.steps;
          _todayKey = today;
          _onNewDay(previousDate, previousDaySteps, _baseSteps);
          unawaited(_saveHistoryToFirestore(previousDate, previousDaySteps));
        }

        if (_baseSteps == 0) _baseSteps = event.steps;
        unawaited(_syncLiveDataToFirestore());
        notifyListeners();
      },
      onError: (error) {
        _available = false;
        _sub = null;
        notifyListeners();
      },
      cancelOnError: false,
    );

    notifyListeners();
    return true;
  }

  void setBase(int base) {
    _baseSteps = base;
    unawaited(_syncLiveDataToFirestore());
    notifyListeners();
  }

  Future<void> _ensureUserDoc() async {
    final userDoc = _userDoc;
    if (_userId.isEmpty || userDoc == null) return;
    await userDoc.set(
      {
        'goalSteps': _goalSteps,
        'todayKey': _todayString(),
        'todaySteps': stepsToday,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> _syncLiveDataToFirestore() async {
    final userDoc = _userDoc;
    if (_userId.isEmpty || userDoc == null) return;
    await userDoc.set(
      {
        'goalSteps': _goalSteps,
        'todayKey': _todayString(),
        'todaySteps': stepsToday,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> _saveHistoryToFirestore(String date, int steps) async {
    final userDoc = _userDoc;
    if (_userId.isEmpty || userDoc == null || steps <= 0) return;
    await userDoc
        .collection(AppConstants.historyCollection)
        .doc(date)
        .set({'date': date, 'steps': steps});
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
