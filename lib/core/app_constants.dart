import 'package:flutter/material.dart';

class AppConstants {
  static const int defaultDailyGoal = 10000;
  static const int minDailyGoal = 100;
  static const int maxDailyGoal = 100000;
  static const List<int> goalPresets = [5000, 7500, 10000, 12000, 15000];
  static const int maxHistoryDays = 30;

  static const String usersCollection = 'users';
  static const String historyCollection = 'history';

  static const Color brandPrimary = Color.fromRGBO(12, 98, 55, 1);
  static const Color brandPrimaryDark = Color(0xFF084C2C);
  static const Color brandSurface = Color(0xFFF3F8F5);
  static const Color brandSurfaceAlt = Color(0xFFE1EEE7);
  static const Color brandTextPrimary = Color(0xFF102018);
  static const Color brandTextMuted = Color(0xFF5E7068);
  static const Color brandWarning = Color(0xFFB07A2C);
  static const Color brandDanger = Color(0xFFB33A3A);

  static const Color brandGreenDark = brandPrimaryDark;
  static const Color progressGreen = brandPrimary;

  static const Color onboardingDarkBg = Color(0xFF0D1A14);
  static const Color onboardingSurface = Color(0xFF142A22);
  static const Color onboardingAccent = brandPrimary;
  static const Color onboardingAccentDark = brandPrimaryDark;
  static const Color onboardingTextPrimary = Color(0xFFE8F2EC);
  static const Color onboardingTextSecondary = Color(0xFFB7C6BE);
}