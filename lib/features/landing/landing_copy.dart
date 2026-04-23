import 'package:flutter/material.dart';

enum LandingTone { formal, playful, fitnessCoach }

class LandingCopyBundle {
  final String appName;
  final String headline;
  final String intro;
  final String metricDashboardLabel;
  final String metricHistoryLabel;
  final String metricMotivationLabel;
  final String featureTrackingTitle;
  final String featureTrackingDescription;
  final String featureGoalTitle;
  final String featureGoalDescription;
  final String featureHistoryTitle;
  final String featureHistoryDescription;
  final String ctaSupportText;
  final String primaryCta;
  final String secondaryCta;

  const LandingCopyBundle({
    required this.appName,
    required this.headline,
    required this.intro,
    required this.metricDashboardLabel,
    required this.metricHistoryLabel,
    required this.metricMotivationLabel,
    required this.featureTrackingTitle,
    required this.featureTrackingDescription,
    required this.featureGoalTitle,
    required this.featureGoalDescription,
    required this.featureHistoryTitle,
    required this.featureHistoryDescription,
    required this.ctaSupportText,
    required this.primaryCta,
    required this.secondaryCta,
  });
}

class LandingCopy {
  const LandingCopy._();

  // Localization-ready key map. Replace with AppLocalizations lookups later.
  static const Map<LandingTone, Map<String, String>> _enByTone = {
    LandingTone.formal: {
      'appName': 'GoGo',
      'headline': 'A daily walking companion for structured habit building.',
      'intro':
          'GoGo presents your daily progress, personal goals, and recent history in one clear and focused experience.',
      'metricDashboardLabel': 'Dashboard for today',
      'metricHistoryLabel': 'Days of quick history',
      'metricMotivationLabel': 'Motivation that scales',
      'featureTrackingTitle': 'Daily Tracking Overview',
      'featureTrackingDescription':
          'Monitor current step totals and progress toward your daily target.',
      'featureGoalTitle': 'Goal Management',
      'featureGoalDescription':
          'Set and revise your target based on your routine and capacity.',
      'featureHistoryTitle': 'Recent Activity History',
      'featureHistoryDescription':
          'Review prior days to understand trends and sustain consistency.',
      'ctaSupportText':
          'Create an account to preserve your activity and continue your progress securely across sessions.',
      'primaryCta': 'Get Started',
      'secondaryCta': 'Continue to login',
    },
    LandingTone.playful: {
      'appName': 'GoGo',
      'headline': 'Your pocket cheerleader for everyday walking wins.',
      'intro':
          'From first step to streak mode, GoGo keeps your goals, progress, and history in one happy place.',
      'metricDashboardLabel': 'Today in focus',
      'metricHistoryLabel': 'Quick 7-day lookback',
      'metricMotivationLabel': 'Unlimited good vibes',
      'featureTrackingTitle': 'Step-by-Step Tracking',
      'featureTrackingDescription':
          'Watch your step count climb and cheer on your daily target.',
      'featureGoalTitle': 'Flexible Goal Setting',
      'featureGoalDescription':
          'Pick a goal that feels right and tweak it whenever life changes.',
      'featureHistoryTitle': 'Progress Story',
      'featureHistoryDescription':
          'See your recent days at a glance and keep your momentum rolling.',
      'ctaSupportText':
          'Jump in, make an account, and keep your progress synced whenever you come back.',
      'primaryCta': 'Let\'s Go',
      'secondaryCta': 'Head to login',
    },
    LandingTone.fitnessCoach: {
      'appName': 'GoGo',
      'headline': 'Your daily walking coach for stronger, consistent habits.',
      'intro':
          'GoGo keeps your daily target, live progress, and recent performance in one focused flow so you keep moving forward.',
      'metricDashboardLabel': 'Dashboard for today',
      'metricHistoryLabel': 'Days of quick history',
      'metricMotivationLabel': 'Motivation to keep moving',
      'featureTrackingTitle': 'Live Daily Tracking',
      'featureTrackingDescription':
          'Monitor your current steps and stay on pace for your target.',
      'featureGoalTitle': 'Goal Planning',
      'featureGoalDescription':
          'Set a realistic target, then raise it as your stamina improves.',
      'featureHistoryTitle': 'Progress History',
      'featureHistoryDescription':
          'Review recent performance, spot trends, and train with intent.',
      'ctaSupportText':
          'Start now to create your account, save your activity, and keep your progress across sessions.',
      'primaryCta': 'Get Started',
      'secondaryCta': 'Continue to login',
    },
  };

  static LandingCopyBundle bundle(
    BuildContext context, {
    LandingTone tone = LandingTone.fitnessCoach,
  }) {
    final strings = _enByTone[tone]!;
    return LandingCopyBundle(
      appName: strings['appName']!,
      headline: strings['headline']!,
      intro: strings['intro']!,
      metricDashboardLabel: strings['metricDashboardLabel']!,
      metricHistoryLabel: strings['metricHistoryLabel']!,
      metricMotivationLabel: strings['metricMotivationLabel']!,
      featureTrackingTitle: strings['featureTrackingTitle']!,
      featureTrackingDescription: strings['featureTrackingDescription']!,
      featureGoalTitle: strings['featureGoalTitle']!,
      featureGoalDescription: strings['featureGoalDescription']!,
      featureHistoryTitle: strings['featureHistoryTitle']!,
      featureHistoryDescription: strings['featureHistoryDescription']!,
      ctaSupportText: strings['ctaSupportText']!,
      primaryCta: strings['primaryCta']!,
      secondaryCta: strings['secondaryCta']!,
    );
  }
}
