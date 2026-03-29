import 'package:flutter/material.dart';

class AppConstants {
  static const int defaultDailyGoal = 10000;
  static const int minDailyGoal = 100;
  static const int maxDailyGoal = 100000;
  static const List<int> goalPresets = [5000, 7500, 10000, 12000, 15000];
  static const int maxHistoryDays = 30;

  static const String usersCollection = 'users';
  static const String historyCollection = 'history';

  static const Color brandGreenDark = Color(0xFF1B5E20);
  static const Color progressGreen = Color(0xFF50C878);

  static const Color onboardingDarkBg = Color(0xFF0B1B1A);
  static const Color onboardingSurface = Color(0xFF12332F);
  static const Color onboardingAccent = Color(0xFF39D98A);
  static const Color onboardingAccentDark = Color(0xFF1FA968);
  static const Color onboardingTextPrimary = Color(0xFFE8FFF5);
  static const Color onboardingTextSecondary = Color(0xFFB9C7C5);
}