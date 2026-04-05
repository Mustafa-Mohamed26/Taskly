# Taskly Implementation Plan (Feature-Based)

## Feature 1: Splash Screen
- [ ] *Design Reference**: `assets/ai/Splash Screen light mode.png`, `assets/ai/Splash Screen dark mode.png`
- [ ] Initialize Firebase & Dependencies.
- [ ] **Auto-Authentication**: Implement Auth-state listener in `AuthCubit` to check if user is already logged in.
- [ ] **Routing**: Implement conditional navigation based on Auth status and Onboarding completion.

## Feature 2: Onboarding
-  [ ] *Design Reference**: `assets/ai/Onboarding screens light mode.png`, `assets/ai/Onboarding screens dark mode.png`
- [ ] Carousel UI implementation.
- [ ] **Cache Persistence**: Implement `CacheHelper.setOnboardingCompleted(true)` to skip onboarding on next launch.

## Feature 3: Authentication System
- [ ] *Design Reference**: `assets/ai/sign in & register & forget password screens light mode.png`, `assets/ai/sign in & register & forget password screens dark mode.png`
- [ ] Implement Firebase Auth (Sign In, Sign Up, Forgot Password).
- [ ] Implement Firestore User profile synchronization (Data Sync).
- [ ] Add form validation and loading state overlays.

## Feature 4: Task Dashboard & CRUD System
- [ ] *Design Reference**: `assets/ai/dashboard and add and view the tasks light mode.png`, `assets/ai/dashboard and add and view the tasks dark mode.png`
- [ ] **Summary Cards**: Display total task counts for 'Today' and 'This Week' on the dashboard.
- [ ] **Dynamic Progress Bar**: Calculate and visualize daily progress based on (completed tasks / total tasks).
- [ ] **Today's Tasks List**: Filtered list view of tasks scheduled for the current day.
- [ ] **CRUD System**:
    - [ ] Add Task via floating action button (Navigate to Add Task page).
    - [ ] Edit/Remove via task item options (three-dot menu).
    - [ ] Edit Task: Reuse Add Task page as 'Edit Task' mode with pre-filled data.
- [ ] **Navigation**: 'View All' navigates to the detailed weekly task list.
- [ ] **UI Feedback**: `AwesomeDialog` overlays for all successful/failed CRUD operations.
- [ ] **Future Note**: Potential for future expansion (e.g., drag-and-drop reordering, voice-to-text task creation).
- [ ] **Notification System**: Integrate `flutter_local_notifications` for scheduled task reminders.

## Feature 5: Calendar
- [ ] *Design Reference**: `assets/ai/calander view light mode.png`, `assets/ai/calander view dark mode.png`
- [ ] **View Modes**: Support Weekly and Monthly toggle views.
- [ ] **Visualization**:
    - [ ] **Current Day**: Highlighted with a solid blue circle.
    - [ ] **Task Indicator**: Low-opacity blue circle for days with scheduled tasks.
- [ ] **Task Display**: List all tasks (completed/pending) for the selected day.
- [ ] **Header Info**: Display current date in the AppBar.
- [ ] **UX Suggestions**:
    - [ ] **Task Quick-Add**: Long-press on a date to open the 'Add Task' screen pre-filled with that date.
    - [ ] **Filtering**: Add chips to filter calendar tasks by 'All', 'Completed', and 'Pending'.
    - [ ] **Transition**: Smooth animation when switching between week/month modes.

## Feature 6: Focus Mode
- [ ] *Design Reference**: `assets/ai/focuse light mode.png`, `assets/ai/focuse dark mode.png`
- [ ] **Task Selection**: Integration with `TaskCubit` to pick a task for the focus session.
- [ ] **Timer Core**:
    - [ ] Implement Pomodoro logic (25 min default) with decreasing circular progress indicator.
    - [ ] Add soundscape controller (start/stop/switch sounds).
- [ ] **UX Suggestions**:
    - [ ] **Auto-Pause**: Lifecycle listener to pause session on background.
    - [ ] **Stats**: Calculate focus time to update profile stats.
    - [ ] **Feedback**: Add haptic feedback on completion.

## Feature 7: User Profile & Settings
- [ ] *Design Reference**: `assets/ai/profile sittings light mode.png`, `assets/ai/profile sittings dark mode.png`, `assets/ai/User profile screen light mode.png`, `assets/ai/User profile screen dark mode.png`
- [ ] **Profile Display**: 
    - [ ] Display Name and Email only.
    - [ ] Task stats calculation (Completed vs Ongoing) + visual percentage progress.
- [ ] **Account Settings**: 
    - [ ] Personal info form (Name, Email[Read-only], Phone, Bio).
    - [ ] 'Save Changes' functionality (Firestore update).
- [ ] **Notifications**: 
    - [ ] Implement switch toggle logic for Push Reminders, Email, Weekly Reports.
    - [ ] Define notification categories (Local for reminders, FCM for email/updates).
- [ ] **Theme Preferences**: 
    - [ ] Implement Radio-group for Light/Dark/System Default themes.
    - [ ] Apply app-wide theme accent colors.
- [ ] **Security & Privacy**:
    - [ ] Change Password flow (Email trigger + success dialog).
    - [ ] Privacy Policy Modal implementation.
    - [ ] App Permission Linker (System settings).
    - [ ] Account Deletion (Auth + Firestore data wipe + Confirmation alert).

## Feature 8: Sync & Offline Engine
- [ ] **Logic**: Local Sqflite (Single Source of Truth) + Background Firestore Sync.
- [ ] **Connectivity**: Connectivity listener for auto-syncing when online.
- [ ] **Sync Throttling**: Battery-optimized background sync (Charging + Wi-Fi).
- [ ] **Debugging**: Dedicated log screen in settings for sync debugging.
- [ ] **Conflict Resolution**: Timestamp-based resolution.
