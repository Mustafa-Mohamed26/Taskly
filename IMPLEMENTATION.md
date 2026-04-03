# Taskly - Implementation Roadmap

This document outlines the development phases for Taskly, tracking progress from the initial UI prototype to a fully functional, synchronized task management system using Clean Architecture.

---

## Phase 0: UI/UX Prototyping & Foundation (Completed)
- [x] **Project Scaffolding**: Standard Flutter project structure.
- [x] **Theme System**: Definition of `AppColors`, `AppStyles`, and `AppTheme`.
- [x] **Navigation Setup**: Centralized routing in `AppRoutes` and `AppRoutesGenerator`.
- [x] **Authentication UI**: Splash, Onboarding, Login, Register, Forgot/Change Password.
- [x] **Task Management UI**: Home, All Tasks, Add Task Form.
- [x] **User Profile UI**: Profile Overview, Settings.
- [x] **Utility Screens**: Focus Timer UI, Calendar View.

---

## Phase 1: Core Infrastructure & Setup (Completed)
- [x] **Add Dependencies**: Firebase, `get_it`, `path`, `injectable`, `awesome_dialog`, `build_runner`.
- [x] **Firebase Integration**: FlutterFire CLI configuration and `main.dart` initialization.
- [x] **Local Storage Foundation**: `Sqflite` (`DatabaseHelper`) and `Shared Preferences` (`CacheHelper`).
- [x] **Dependency Injection (DI)**: `GetIt` with `injectable` and `build_runner` code generation.

---

## Phase 2: Authentication System (Domain & Data Logic) (Completed - Refactored)
*Goal: Implement secure user management using Clean Architecture with strict decoupling and improved UX.*

### **1. Domain Layer**
- [x] Define `UserEntity`.
- [x] Define `AuthRepository` (Abstract interface in a separated file).
- [x] Implement **Static Use Cases** (Zero-object instantiation pattern):
    - [x] `LoginUseCase.execute()`
    - [x] `RegisterUseCase.execute()`
    - [x] `LogoutUseCase.execute()`
    - [x] `ForgotPasswordUseCase.execute()`
    - [x] `GetAuthenticatedUserUseCase.execute()` (Auth state stream).

### **2. Data Layer**
- [x] Create `UserModel` (Firebase/JSON mapping).
- [x] **Decoupled DataSources**:
    - [x] Define abstract `AuthDataSource`.
    - [x] Implement `FirebaseAuthDataSourceImpl` in `remote/` folder with `@Injectable(as: AuthDataSource)`.
- [x] **Decoupled Repositories**:
    - [x] Implement `AuthRepositoryImpl` in `remote/` folder with `@Injectable(as: AuthRepository)`.

### **3. Presentation Layer**
- [x] Create `AuthCubit` with specific states (`Initial`, `Loading`, `AuthSuccess<T>`, `AuthError`) and `@injectable`.
- [x] **Enhanced UI Feedback**:
    - [x] Create `AuthLoadingWidget` (Specialized circular progress container).
    - [x] Implement `BlocListener` in all Auth screens for `AwesomeDialog` overlays.
    - [x] Use stack-based `AuthLoadingWidget` overlay triggered by state changes.
- [x] **Navigation & Persistence**:
    - [x] Update `SplashScreen` for conditional navigation based on Auth status and Onboarding.
    - [x] Update `OnboardingScreen` to persist completion status via `CacheHelper`.

---

## Phase 3: Task Management (Domain & Data Layer)
*Goal: Build the offline-first task engine.*

### **1. Domain Layer**
- [ ] Define `TaskEntity` (id, title, desc, dateTime, category, priority, isCompleted, isSynced, updatedAt).
- [ ] Define `TaskRepository` (interface in separated file).
- [ ] Implement **Static Use Cases**:
    - [ ] `GetTasksUseCase`
    - [ ] `AddTaskUseCase`
    - [ ] `UpdateTaskUseCase`
    - [ ] `DeleteTaskUseCase`

### **2. Data Layer**
- [ ] Create `TaskModel` (Serialization + SQL mapping).
- [ ] **Remote Data Layer**:
    - [ ] Define abstract `TaskRemoteDataSource`.
    - [ ] Implement `FirestoreTaskDataSourceImpl` in `remote/`.
- [ ] **Local Data Layer**:
    - [ ] Define abstract `TaskLocalDataSource`.
    - [ ] Implement `SqfliteTaskDataSourceImpl` in `local/`.
- [ ] **Repository Implementation**:
    - [ ] Implement `TaskRepositoryImpl` (Logic for local cache first + background remote sync).

---

## Phase 4: State Management & UI Wiring
- [ ] **Task State Management**: `TaskCubit` with `@injectable` and generic `Success<T>` states.
- [ ] **UI Integration**:
    - [ ] Connect `AddTaskScreen` to Domain logic.
    - [ ] Connect `AllTasksScreen` to live data stream.
    - [ ] Implement real-time updates for completion status.

---

## Phase 5: Synchronization & Offline Mode
- [ ] **Sync Engine**:
    - [ ] Implement "Pending Sync" flag for local changes.
    - [ ] Set up `Connectivity` listener for auto-syncing when online.
    - [ ] Implement conflict resolution (Last-Write-Wins based on `updatedAt`).

---

## Phase 6: Advanced Features & Polishing
- [ ] **Focus Timer**: Logic for countdown and notifications.
- [ ] **Calendar**: Mapping tasks to the calendar view.
- [ ] **Notifications**: `flutter_local_notifications` for task reminders.
- [ ] **Settings**: Theme toggle and Profile updates logic.

---

## Phase 7: QA & Deployment
- [ ] **Testing**: Unit tests for UseCases and Cubits.
- [ ] **Optimization**: Database indexing and performance tuning.
---

## 🚩 Resume Point (Next Session)
**Next Step**: Start **Phase 3: Task Management (Domain & Data Layer)**.
1. Create `TaskEntity` in `lib/domain/entities/task_entity.dart`.
2. Create `TaskRepository` abstract interface in `lib/domain/repositories/task_repository.dart`.
3. Implement Static UseCases in `lib/domain/usecases/tasks/`.
4. Create `TaskModel` and DataSources.

*Note: Ensure all new components follow the refactored rules (Injectable, Static UseCases, Decoupled Folders).*
