import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wraps the [pedometer] package.
/// Exposes [stepsToday] — steps walked since midnight.
class StepService extends ChangeNotifier {
  static final StepService instance = StepService._();
  StepService._();

  int _rawTotal = 0;   // cumulative from pedometer (since last boot)
  int _baseSteps = 0;  // raw total at start of today
  String _todayKey = '';
  bool _available = true;
  bool _supported = true;
  bool _permissionGranted = false;
  bool _pendingInitialRollover = false;
  int _pendingSavedBase = 0;
  String _pendingSavedDate = '';

  late Function(String date, int steps) _onNewDay;

  StreamSubscription<StepCount>? _sub;

  int get stepsToday => (_rawTotal - _baseSteps).clamp(0, 999999);
  bool get isAvailable => _available;
  bool get canRequestPermission => _supported && !_permissionGranted;
  int get baseSteps => _baseSteps;

  static String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> init({
    required int savedBase,
    required String savedDate,
    required Function(String date, int steps) onNewDay,
  }) async {
    _onNewDay = onNewDay;
    _todayKey = _todayString();

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

  Future<bool> requestPermissionAndStart() async {
    if (!_supported || kIsWeb) {
      _available = false;
      notifyListeners();
      return false;
    }

    try {
      final status = await Permission.activityRecognition.request();
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
          _onNewDay(_pendingSavedDate, previousDaySteps);
          _pendingInitialRollover = false;
        }

        final today = _todayString();
        if (today != _todayKey) {
          // Midnight rolled over
          _onNewDay(_todayKey, stepsToday);
          _baseSteps = event.steps;
          _todayKey = today;
        }

        if (_baseSteps == 0) _baseSteps = event.steps;
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
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
