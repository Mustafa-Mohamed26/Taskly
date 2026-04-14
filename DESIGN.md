# Taskly Design Document

## 1. Executive Summary
Taskly is a comprehensive task management application designed for productivity, featuring an offline-first architecture, real-time cloud synchronization, and a focus-driven timer.

## 2. Feature-Specific Design
### Feature 1: Splash Screen
- **Reference**: `assets/ai/Splash Screen light mode.png`, `assets/ai/Splash Screen dark mode.png`
- **Design**: Minimalist logo display.
- **Functionality**: 
    - **Auto-Authentication**: Check Firebase `authStateChanges` and `CacheHelper` status to automatically route to `Home` (if logged in) or `Onboarding`/`Login` (if new/logged out).

### Feature 2: Onboarding
- **Reference**: `assets/ai/Onboarding screens light mode.png`, `assets/ai/Onboarding screens dark mode.png`
- **Design**: Three-step carousel.
- **Functionality**:
    - **Persistence**: Save completion status to `Shared Preferences` via `CacheHelper` to ensure onboarding only displays once.

### Feature 3: Authentication
- **Reference**: `assets/ai/sign in & register & forget password screens light mode.png`, `assets/ai/sign in & register & forget password screens dark mode.png`
- **Design**: Clean form inputs, clear password visibility toggles, and social login buttons.
- **Backend Requirement**: Automated user profile creation in Firestore upon registration to enable cloud persistence and task assignment.

### Feature 4: Task Dashboard & CRUD System
- **Reference**: `assets/ai/dashboard and add and view the tasks light mode.png`, `assets/ai/dashboard and add and view the tasks dark mode.png`
- **Design**: Organized task cards with priority tagging and progress visualization.
- **Features**: 
    - Full CRUD operations.
    - **Offline-First**: Local storage via Sqflite for zero-latency UI interactions.
    - **Local Notifications**: Scheduled alerts for upcoming task deadlines.
    - **Visual Analytics**: Summary cards and dynamic progress bars.

### Feature 5: Calendar
- **Reference**: `assets/ai/calander view light mode.png`, `assets/ai/calander view dark mode.png`
- **Design**: Intuitive monthly/weekly view, highlighting tasks on selected dates.
- **Functionality**:
    - Current day marked with a solid blue circle.
    - Task indicator (low-opacity blue circle) for scheduled task dates.

### Feature 6: Focus Mode
- **Reference**: `assets/ai/focuse light mode.png`, `assets/ai/focuse dark mode.png`
- **Design**: Centered circular timer progress, ambient sound control, and clear task focus area.
- **Functionality**:
    - Task-specific focus session selection.
    - Dynamic circular progress indicator (decreasing blue ring).
    - Integrated soundscape controller.

### Feature 7: Profile & Settings
- **Reference**: `assets/ai/profile sittings light mode.png`, `assets/ai/profile sittings dark mode.png`, `assets/ai/User profile screen light mode.png`, `assets/ai/User profile screen dark mode.png`
- **Dashboard**: User Name/Email display and task analytics (Completed vs Ongoing).
- **Settings**: Account management, Notification toggles, Theme Preferences (Light/Dark/System), and Security/Privacy controls.

### Feature 8: Sync & Offline Engine
- **Strategy**: Offline-First Local Cache.
- **Mechanism**:
    - **Read**: Local Sqflite cache for fast UI rendering.
    - **Write**: Local-first write (Optimistic UI) + background Firestore sync.
    - **Conflict Resolution**: `updatedAt` timestamp and `isSynced` flag to manage state.
- **Optimization**: Battery-optimized sync (triggered when charging/Wi-Fi connected) and local logging for troubleshooting.
