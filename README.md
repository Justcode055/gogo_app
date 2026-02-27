# GoGo App v2
# johnny 
Lightweight step-tracking prototype with onboarding, dashboard, history, goal setting, and settings flows built in Flutter.

## Features
- Onboarding CTA that drives straight into the app.
- Dashboard with circular progress indicator for daily steps and quick links to history and settings.
- Seven-day history list using mocked data for the UI prototype.
- Goal setting screen with inline validation placeholder and success snackbar.
- Settings with dark-mode toggle placeholder and navigation to goal settings.

## Tech Stack
- Flutter (Material 3, Dart 3.11)
- Navigation: go_router
- UI: percent_indicator
- Sensors/permissions (planned): pedometer, permission_handler

## Project Structure
- lib/main.dart: App entrypoint with Material 3 theme and router wiring.
- lib/core/app_router.dart: Route map for onboarding, dashboard, history, settings, and goals.
- lib/features/...: Feature-first screens for onboarding, dashboard, history, settings, and goals.

## Running the App
1) Prereqs: Flutter SDK 3.24+ (Dart 3.11), Android Studio/Xcode tooling, device/emulator.
2) Install deps: `flutter pub get`
3) Run (dev): `flutter run`
4) Run tests: `flutter test`

## Navigation
- / : OnboardingScreen
- /dashboard : HomeDashboardScreen
- /history : HistoryScreen
- /settings : SettingsScreen
- /goals : GoalSettingScreen

## Notes for Week 5 UI Prototype
- Dashboard uses mocked step data (`currentSteps`, `goalSteps`) for presentation.
- History list uses static sample data to showcase list styling and theming.
- Goal save action currently shows a snackbar and pops back; wire to storage/service next.

## Development Tips
- Format Dart: `dart format lib test`
- Analyze: `flutter analyze`
- Update deps: `flutter pub upgrade --major-versions`
