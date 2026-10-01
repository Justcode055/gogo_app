# GoGo React Native — Agent Instructions

## 1. Project Overview

GoGo is a React Native and TypeScript step-tracking application inspired by the Flutter prototype in `Justcode055/gogo_app`.

Core capabilities:

- First-run onboarding
- Daily step tracking
- Configurable daily step goal
- Circular progress dashboard
- Step history
- Dark mode
- Local persistence
- Android and iOS activity-recognition permissions
- Optional future Firebase synchronization

## 2. Recommended Architecture

For the first release, keep the project as a single React Native application. A separate API is not required because step data comes from the device and preferences/history can be stored locally.

Use service interfaces so cloud services or a custom backend can be added later without rewriting screens:

```text
React Native app
├── Native activity service
├── AsyncStorage persistence
├── Zustand application state
└── Optional Firebase service
```

Required service boundaries:

- `ActivityService`: device pedometer integration
- `StorageRepository`: local persistence through AsyncStorage
- `RemoteStepRepository`: optional future Firebase or API synchronization

Do not add a Node.js, Express, NestJS, or database API for the first milestone.

## 3. Suggested Implementation Steps

### Phase 1 — Local-first MVP

1. Create the React Native TypeScript project.
2. Configure strict TypeScript, ESLint, Prettier, Jest, and React Native Testing Library.
3. Add React Navigation with a root stack and bottom tab navigator.
4. Add a theme system for light and dark mode.
5. Add reusable components such as `AppButton`, `AppCard`, `ProgressRing`, `StatCard`, and `EmptyState`.
6. Implement a Zustand store for onboarding, goal, theme, activity state, and history.
7. Implement `StorageRepository` using AsyncStorage.
8. Build onboarding and persist completion.
9. Build the dashboard using mocked activity data first.
10. Build goal settings with validation and presets.
11. Build history with a 30-day maximum.
12. Build settings and dark mode.
13. Add unit and component tests.

### Phase 2 — Native activity tracking

1. Select and install a maintained React Native pedometer/activity-recognition library.
2. Implement the `ActivityService` interface.
3. Request Android activity-recognition permission.
4. Request the required iOS motion/activity permission.
5. Calculate daily steps from the cumulative sensor value and persisted day base.
6. Handle app resume and calendar-day rollover.
7. Handle unavailable sensors, denied permissions, and stream errors.
8. Test with a mock activity service and physical devices.

### Phase 3 — Optional cloud synchronization

Add cloud functionality only when product requirements need it:

1. Add Firebase Authentication if user accounts are required.
2. Add Firestore for cross-device synchronization.
3. Keep local writes as the primary operation.
4. Queue or retry remote synchronization when offline.
5. Add conflict resolution by date and last update time.
6. Add security rules and tests.

### Phase 4 — Separate API, only if necessary

Create a separate API only when the app needs server-side capabilities such as:

- Custom authentication or authorization
- Social features or leaderboards
- Shared challenges
- Admin dashboards
- Subscription or payment logic
- Server-generated notifications
- External wearable integrations
- Complex analytics or server-side business rules

If required, use a structure such as:

```text
gogo/
  mobile/          # React Native + TypeScript
  api/             # Node.js API, only when justified
  infrastructure/  # deployment and environment configuration
```

## 4. Project Structure

```text
src/
  app/
    App.tsx
    navigation/
      RootNavigator.tsx
      MainTabNavigator.tsx
      routeTypes.ts
  components/
  config/
  core/
    constants/
    theme/
    utils/
  domain/
    models/
  features/
    onboarding/
    dashboard/
    history/
    goals/
    settings/
    shell/
  services/
    activity/
    persistence/
    firebase/
  store/
  types/
__tests__/
  unit/
  components/
  integration/
```

## 5. Coding Rules

- Use TypeScript strict mode.
- Avoid `any`.
- Keep business logic outside screen components.
- Do not access AsyncStorage directly from screens.
- Do not access native pedometer APIs directly from screens.
- Use typed navigation parameters.
- Centralize date formatting and goal validation.
- Handle loading, empty, error, and unavailable states.
- Preserve offline functionality.
- Never commit secrets or Firebase private credentials.
- Prefer small, testable functions and feature-focused modules.

## 6. Testing and Verification

Before completing a task, run:

```bash
npm run format
npm run lint
npm run typecheck
npm test
```

When native code changes, also verify:

```bash
npx pod-install ios
npx react-native run-android
npx react-native run-ios
```

Test at minimum:

- First launch and onboarding
- Returning-user navigation
- Goal validation and persistence
- Dark-mode persistence
- Dashboard calculations
- History rendering
- Activity permission denial
- Unsupported activity sensors
- Date rollover
- Corrupted local storage

## 7. Definition of Done

A change is complete when the requested behavior works, tests are added or updated, TypeScript and linting pass, platform implications are handled, documentation is updated when necessary, and no unrelated functionality is broken.
