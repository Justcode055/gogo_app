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

  StreamSubscription<StepCount>? _sub;

  int get stepsToday => (_rawTotal - _baseSteps).clamp(0, 999999);
  bool get isAvailable => _available;

  static String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> init({
    required int savedBase,
    required String savedDate,
    required Function(String date, int steps) onNewDay,
  }) async {
    _todayKey = _todayString();

    // On web, pedometer is not supported
    if (kIsWeb) {
      _available = false;
      return;
    }

    try {
      final status = await Permission.activityRecognition.request();
      if (!status.isGranted) {
        _available = false;
        return;
      }
    } catch (_) {
      _available = false;
      return;
    }

    // If date changed since last run, save yesterday then reset base
    if (savedDate != _todayKey && savedDate.isNotEmpty && savedBase > 0) {
      onNewDay(savedDate, _rawTotal - savedBase);
    }

    if (savedDate == _todayKey) {
      _baseSteps = savedBase;
    }

    _sub = Pedometer.stepCountStream.listen(
      (StepCount event) {
        final today = _todayString();
        if (today != _todayKey) {
          // Midnight rolled over
          onNewDay(_todayKey, stepsToday);
          _baseSteps = event.steps;
          _todayKey = today;
        }
        _rawTotal = event.steps;
        if (_baseSteps == 0) _baseSteps = event.steps;
        notifyListeners();
      },
      onError: (error) {
        _available = false;
        notifyListeners();
      },
      cancelOnError: false,
    );
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
