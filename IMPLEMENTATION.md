# Taskly - Implementation Roadmap

This document outlines the development phases for Taskly, tracking progress from the initial UI prototype to a fully functional, synchronized task management system.

---

## Phase 0: UI/UX Prototyping & Foundation (Completed)
*Goal: Establish the visual identity and core navigation structure.*

- [x] **Project Scaffolding**: Standard Flutter project structure.
- [x] **Theme System**: Definition of `AppColors`, `AppStyles`, and `AppTheme`.
- [x] **Navigation Setup**: Centralized routing in `AppRoutes` and `AppRoutesGenerator`.
- [x] **Authentication UI**:
    - [x] Splash Screen.
    - [x] Onboarding Carousel.
    - [x] Login & Register Screens.
    - [x] Forgot/Change Password Screens.
- [x] **Task Management UI**:
    - [x] Main Dashboard (Home).
    - [x] All Tasks View with Weekly Strip.
    - [x] Add Task Form (Title, Desc, Date, Time, Category, Priority).
- [x] **User Profile UI**:
    - [x] Profile Overview.
    - [x] Settings (Personal Info, Notifications, Security).
- [x] **Utility Screens**:
    - [x] Focus Timer UI.
    - [x] Calendar View.

---

## Phase 1: Core Infrastructure & Setup
*Goal: Prepare the project for data handling and backend communication.*

- [x] **Add Dependencies**: Firebase (Core, Auth, Firestore), `get_it`, `path`.
- [ ] **Firebase Integration**:
    - [ ] Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
    - [ ] Configure Firebase: `flutterfire configure --project=taskly-9f9bd`
    - [ ] Initialize Firebase in `main.dart` using `DefaultFirebaseOptions`.
- [ ] **Local Storage Foundation**:
    - [ ] Initialize `Sqflite` database helper.
    - [ ] Define SQL schemas for Tasks table.
    - [ ] Set up `Shared Preferences` for user settings (Theme, Onboarding flag).
- [ ] **Dependency Injection (DI)**:
    - [ ] Set up `GetIt` or manual provider-based DI to manage repositories and services.

---

## Phase 2: Authentication System (Logic)
*Goal: Connect the existing Auth UI to Firebase Authentication.*

- [ ] **Auth Data Layer**:
    - [ ] Implement `AuthDataSource` (Firebase API).
    - [ ] Implement `AuthRepository`.
- [ ] **Auth State Management**:
    - [ ] Create `AuthCubit` for Login/Register/Logout logic.
    - [ ] Handle persistence of user session.
- [ ] **User Flow Integration**:
    - [ ] Connect `LoginScreen` to `AuthCubit`.
    - [ ] Connect `RegisterScreen` to `AuthCubit`.
    - [ ] Implement "Forgot Password" email trigger.

---

## Phase 3: Task Management (Domain & Data Layer)
*Goal: Build the engine that handles task data.*

- [ ] **Domain Layer**:
    - [ ] Define `TaskEntity`.
    - [ ] Define `TaskRepository` interface.
    - [ ] Create Use Cases: `GetTasks`, `AddTask`, `UpdateTask`, `DeleteTask`.
- [ ] **Data Layer**:
    - [ ] Create `TaskModel` with JSON & Map serialization.
    - [ ] Implement `TaskRemoteDataSource` (Firestore).
    - [ ] Implement `TaskLocalDataSource` (Sqflite).
    - [ ] Implement `TaskRepositoryImpl` with caching logic.

---

## Phase 4: State Management & UI Wiring
*Goal: Make the UI functional using the Data Layer.*

- [ ] **Task State Management**:
    - [ ] Create `TaskCubit` to manage the list and individual task states.
- [ ] **UI Integration**:
    - [ ] Connect `AddTaskScreen` to save tasks to the database.
    - [ ] Connect `AllTasksScreen` to display tasks from the database.
    - [ ] Implement "Mark as Completed" toggle in list items.
    - [ ] Implement task deletion from the UI.

---

## Phase 5: Synchronization & Offline Mode
*Goal: Ensure data is saved locally first and synced to the cloud when online.*

- [ ] **Offline-First Strategy**:
    - [ ] Update repository to always read from Local DB.
    - [ ] Implement background fetch to update Local DB from Firestore.
- [ ] **Sync Engine**:
    - [ ] Implement "Pending Sync" flag for offline writes.
    - [ ] Set up Connectivity listener to trigger sync when internet returns.
    - [ ] Handle conflict resolution (Last-Write-Wins based on `updatedAt`).

---

## Phase 6: Advanced Features & Polishing
*Goal: Complete the remaining functional modules and enhance the UX.*

- [ ] **Focus Timer Logic**:
    - [ ] Implement countdown timer functionality.
    - [ ] Add background task support for the timer.
- [ ] **Calendar Integration**:
    - [ ] Map task dates to the full calendar view.
- [ ] **Notification System**:
    - [ ] Set up `flutter_local_notifications`.
    - [ ] Schedule reminders for task due dates.
- [ ] **Settings Logic**:
    - [ ] Implement Theme Toggle (Light/Dark/System).
    - [ ] Implement Personal Info updates.

---

## Phase 7: QA & Deployment
*Goal: Verify stability and prepare for release.*

- [ ] **Testing**:
    - [ ] Unit tests for Repositories and Cubits.
    - [ ] Widget tests for core components.
    - [ ] Integration tests for the Sync flow.
- [ ] **Optimization**:
    - [ ] Fix any layout overflows on small devices.
    - [ ] Optimize database queries.
- [ ] **Final Preparation**:
    - [ ] Generate App Icons.
    - [ ] Configure ProGuard (Android) and App Store settings (iOS).
    - [ ] Production build.
