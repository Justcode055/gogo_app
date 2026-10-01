# GoGo React Native Application Specification

## 1. Product Summary

GoGo is a lightweight mobile step-tracking application built with React Native and TypeScript. It is based on the existing Flutter prototype in `Justcode055/gogo_app` and provides onboarding, daily step tracking, goal management, history, settings, dark mode, and local persistence.

## 2. Architecture Decision

### Initial release: no separate API

The first release should be a single React Native application with a local-first architecture:

```text
React Native mobile app
├── Device pedometer/activity service
├── Zustand state store
├── AsyncStorage local persistence
└── Optional Firebase integration later
```

A custom API is not required for the initial feature set. The app receives steps from the device and can store goals, preferences, and history locally.

### Future extension points

Define these interfaces from the beginning:

```ts
interface ActivityService {
  initialize(input: {
    savedBaseSteps: number;
    savedDate: string;
    onNewDay: (date: string, steps: number) => Promise<void>;
  }): Promise<void>;
  getStepsToday(): number;
  isAvailable(): boolean;
  subscribe(listener: (steps: number) => void): () => void;
  dispose(): void;
}

interface StorageRepository {
  getOnboarded(): Promise<boolean>;
  setOnboarded(value: boolean): Promise<void>;
  getGoal(): Promise<number>;
  setGoal(value: number): Promise<void>;
  getDarkMode(): Promise<boolean>;
  setDarkMode(value: boolean): Promise<void>;
  getHistory(): Promise<StepEntry[]>;
  setHistory(value: StepEntry[]): Promise<void>;
  getTodayBase(): Promise<number>;
  setTodayBase(value: number): Promise<void>;
  getTodayDate(): Promise<string>;
  setTodayDate(value: string): Promise<void>;
}

interface RemoteStepRepository {
  syncEntry(entry: StepEntry): Promise<void>;
}
```

`RemoteStepRepository` should remain optional until cloud synchronization is needed.

## 3. Implementation Roadmap

### Milestone 1 — Foundation

- Initialize React Native with TypeScript.
- Enable strict TypeScript.
- Configure ESLint, Prettier, Jest, and React Native Testing Library.
- Add React Navigation.
- Add Safe Area Context.
- Add the theme provider and design tokens.
- Add reusable buttons, cards, text, progress, and empty-state components.

### Milestone 2 — Onboarding and navigation

- Add the onboarding screen.
- Show the onboarding screen for new users.
- Persist `isOnboarded`.
- Add a root navigator that waits for initialization.
- Add bottom tabs for Dashboard, History, and Settings.
- Add a pushed Goal Settings screen.

### Milestone 3 — Local state and persistence

- Add the Zustand app store.
- Add the AsyncStorage repository.
- Persist the daily goal, theme, onboarding status, history, current date, and today base steps.
- Add safe defaults for missing or malformed data.
- Add tests for serialization and corrupted storage.

### Milestone 4 — Dashboard

- Display current steps or `--` when unavailable.
- Display a circular progress ring.
- Display daily goal, percentage, and estimated calories.
- Add motivational messages.
- Add a link to history.
- Add an action to change the goal.
- Ensure progress is clamped between 0% and 100%.

### Milestone 5 — Goals, history, and settings

- Add goal input validation.
- Support goals from 100 to 100,000 steps.
- Add presets: 5,000, 7,500, 10,000, 12,000, and 15,000.
- Add a history list with a maximum of 30 entries.
- Merge today’s live steps into the history view.
- Add an empty history state.
- Add dark-mode settings.
- Add app version and product information.

### Milestone 6 — Native activity tracking

- Select a maintained pedometer/activity-recognition package.
- Implement the `ActivityService` adapter.
- Request Android activity-recognition permission.
- Request iOS motion/activity permission.
- Calculate daily steps using:

```text
stepsToday = max(0, rawCumulativeSteps - todayBaseSteps)
```

- Detect date rollover on app start, app resume, and sensor events.
- Save the previous day before resetting the base.
- Handle unavailable devices, denied permissions, and stream errors.
- Keep the app usable when step tracking is unavailable.

### Milestone 7 — Quality and release readiness

- Add unit tests for domain logic.
- Add component tests for major screens.
- Add integration tests for onboarding and navigation.
- Verify Android and iOS builds.
- Add accessibility labels and screen-reader descriptions.
- Test light mode, dark mode, small screens, and large text.
- Document permissions and local development setup.

## 4. Separate API Decision Criteria

Do not create a separate backend for the MVP. Introduce one only if one or more of the following becomes a requirement:

- User accounts and cross-device synchronization
- Leaderboards or shared challenges
- Admin functionality
- Server-side analytics
- Payments or subscriptions
- Server-triggered notifications
- Wearable or third-party integrations
- Business logic that must not run on the client

If cloud sync is the only requirement, prefer Firebase Authentication and Firestore before building a custom API.

If a custom API is eventually required, use:

```text
gogo/
  mobile/          # React Native app
  api/             # Node.js API
  infrastructure/  # deployment configuration
```

The mobile app should communicate through a typed client and continue to support local-first offline behavior.

## 5. Required Screens

### Onboarding

Content:

```text
Welcome to GoGo!
Track your daily steps,
reach your goals, stay healthy.

Get Started
```

### Dashboard

Display:

- Current steps
- Circular progress
- Daily goal
- Completion percentage
- Estimated calories
- Motivational message
- Sensor availability warning
- View History action
- Change Goal action

### History

Display each entry with:

- Date label
- Step count
- Progress bar
- Goal percentage
- Goal completion state

Use `Today`, `Yesterday`, and formatted calendar dates.

### Goal Settings

- Current value prefilled
- Numeric input
- Preset buttons
- Inline validation
- Save action
- Success feedback

### Settings

- Dark-mode switch
- Current goal
- Link to goal settings
- App version
- App description

## 6. Data Models

```ts
export type StepEntry = {
  date: string; // yyyy-MM-dd
  steps: number;
};

export type AppPreferences = {
  isOnboarded: boolean;
  goalSteps: number;
  isDarkMode: boolean;
};

export type ActivityState = {
  rawTotalSteps: number;
  todayBaseSteps: number;
  todayDate: string;
  stepsToday: number;
  isAvailable: boolean;
  permissionStatus:
    | 'unknown'
    | 'granted'
    | 'denied'
    | 'blocked'
    | 'unavailable';
};
```

Defaults:

```text
isOnboarded = false
goalSteps = 10000
isDarkMode = false
history = []
todayBaseSteps = 0
todayDate = ""
```

## 7. Persistence Keys

```text
gogo.onboarded
gogo.dailyGoal
gogo.darkMode
gogo.stepHistory
gogo.todayBaseSteps
gogo.todayDate
```

Storage failures must not crash the application. Invalid history should be logged in development and replaced with an empty list.

## 8. Acceptance Criteria

The MVP is complete when:

- A new user can complete onboarding.
- A returning user skips onboarding.
- The dashboard shows live or mocked steps.
- Progress is calculated correctly and capped at 100%.
- Users can save goals from 100 to 100,000.
- Goal presets work.
- History displays today and persisted entries.
- History retains no more than 30 entries.
- Dark mode works and persists.
- Activity permission denial does not crash the app.
- Unsupported devices show an understandable unavailable state.
- The app works offline using local persistence.
- TypeScript, linting, formatting, and tests pass.

## 9. Test Requirements

Test the following behavior:

- Step calculation from raw total and day base
- Negative step protection
- Progress clamping
- Goal validation
- Date formatting
- Today and yesterday labels
- History serialization
- Corrupted storage fallback
- Date rollover
- Onboarding completion
- Returning-user navigation
- Dashboard unavailable state
- Goal save flow
- History empty state
- History entries
- Dark-mode toggle
- Permission denial

## 10. Future Features

Potential post-MVP features:

- Firebase Authentication
- Firestore synchronization
- Multi-device support
- Social challenges
- Leaderboards
- Notifications
- Wearable integration
- HealthKit and Google Fit integration
- Weekly and monthly analytics
- Custom server API if server-side requirements justify it
