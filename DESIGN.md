# Taskly - Design Document

## 1. Overview
Taskly is a modern task management application built with Flutter. This document outlines the architectural design and technical specifications for implementing a robust task management system with **Firebase Synchronization** and **Offline-First Local Caching**.

## 2. Features
### **User Authentication**
- **Email/Password Auth**: Secure registration and login using Firebase Authentication.
- **Forgot/Change Password**: Password recovery and management.
- **Onboarding**: Interactive walkthrough for new users.

### **Task Management**
- **CRUD Operations**: Create, read, update, and delete tasks.
- **Category Management**: Organize tasks into categories (Work, Personal, Health, etc.).
- **Priority Levels**: Set task urgency (Low, Medium, High).
- **Checklist/Status**: Mark tasks as completed or pending.

### **Calendar & Scheduling**
- **Weekly/Monthly View**: Visualize tasks on a calendar.
- **Today's Schedule**: Quick view of immediate tasks.

### **Advanced Functionality**
- **Offline Mode**: Full app access without internet via Sqflite caching.
- **Real-time Synchronization**: Background syncing with Firebase Firestore.
- **Focus Timer**: Dedicated mode for deep work.
- **Theming**: Support for Light, Dark, and System themes.

### **Profile & Settings**
- **Personal Information**: Edit user profile details.
- **Notifications**: Manage task reminders and app alerts.
- **Security & Privacy**: Manage account data and privacy settings.

## 2. Goals
- **Real-time Sync**: Synchronize tasks with Firebase Firestore for cross-device access.
- **Offline-First**: Enable full application functionality without an internet connection using local caching.
- **Persistence**: Store user preferences and session data locally.
- **Performance**: Minimize latency by serving data from the local cache while fetching updates in the background.

---

## 3. Architecture (Clean Architecture + MVVM)
The project follows a layered approach to ensure separation of concerns and testability.

### Layers:
1.  **Presentation (lib/presentation)**:
    - **UI**: Flutter widgets (Screens, Components).
    - **Logic**: Bloc/Cubit for state management. Handles UI events and maps them to Domain-level UseCases.
2.  **Domain (lib/domain)**:
    - **Entities**: Plain Dart objects representing the core data (e.g., `TaskEntity`).
    - **Repositories (Abstract)**: Interfaces defining data operations.
    - **Use Cases**: Specific business rules (e.g., `AddTaskUseCase`, `SyncTasksUseCase`).
3.  **Data (lib/data)**:
    - **Models**: Data Transfer Objects (DTOs) with JSON serialization logic (e.g., `TaskModel`).
    - **Data Sources**:
        - **Remote**: Firebase Firestore implementation.
        - **Local**: Sqflite (for tasks) and Shared Preferences (for settings).
    - **Repositories (Implementation)**: Coordinates between Remote and Local data sources.

---

## 4. Data Models

### Task Model
| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | String | Unique identifier (Firebase UID or Local GUID) |
| `title` | String | Task name |
| `description`| String | Detailed notes |
| `dateTime` | DateTime | Scheduled date and time |
| `category` | String | e.g., Work, Personal, Health |
| `priority` | String | Low, Medium, High |
| `isCompleted`| bool | Completion status |
| `updatedAt` | int | Timestamp for conflict resolution/syncing |

---

## 5. Persistence Strategy

### Remote (Firebase)
- **Firestore**: Used as the primary source of truth for task data.
- **Authentication**: Firebase Auth for user management (Google, Email/Password).

### Local (Cache)
- **Sqflite**: Stores tasks locally for offline access.
- **Shared Preferences**: Stores lightweight data like:
    - User theme preference (Dark/Light).
    - Onboarding completion status.
    - Last sync timestamp.

### Synchronization Logic (Repository Pattern)
1.  **Read**: Always check the local database first. Fetch from Firestore in the background and update the local DB.
2.  **Write**: Write to the local DB immediately (UI updates instantly). Attempt to push to Firestore. If offline, mark the record as "needs_sync" for later.
3.  **Conflict Resolution**: Use `updatedAt` timestamps to determine which version of a task is newer during synchronization.

---

## 6. Security & Best Practices
- **Firestore Security Rules**: Ensure users can only read/write their own data using `request.auth.uid`.
- **Environment Variables**: Use `.env` or Firebase configuration files to manage sensitive keys.
- **Null Safety**: Strict adherence to Dart's sound null safety.
- **Error Handling**: Graceful handling of network timeouts and database failures.

---

## 7. Implementation Roadmap
1.  **Setup**: Configure Firebase (Android/iOS/Web).
2.  **Data Layer**: Implement Sqflite helper and Firestore data source.
3.  **Domain Layer**: Define Task entity and Repository interfaces.
4.  **State Management**: Create `TaskCubit` to handle CRUD operations.
5.  **Sync Engine**: Implement background sync logic to reconcile local and remote data.
6.  **UI Integration**: Connect existing screens to the new logic.
