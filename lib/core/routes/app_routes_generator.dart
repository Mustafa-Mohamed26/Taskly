import 'package:flutter/material.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/auth/forgot_password_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/main_layout/main_layout_screen.dart';
import '../../presentation/main_layout/tasks/add_task_screen.dart';
import '../../presentation/main_layout/tasks/all_tasks_screen.dart';
import '../../presentation/main_layout/profile/personal_info_screen.dart';
import '../../presentation/main_layout/profile/notification_settings_screen.dart';
import '../../presentation/main_layout/profile/theme_preference_screen.dart';
import '../../presentation/main_layout/profile/security_privacy_screen.dart';
import 'app_routes.dart';
import '../../domain/entities/task_entity.dart';

class AppRoutesGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayoutScreen());
      case AppRoutes.addTask:
        final task = settings.arguments as TaskEntity?;
        return MaterialPageRoute(builder: (_) => AddTaskScreen(task: task));
      case AppRoutes.allTasks:
        return MaterialPageRoute(builder: (_) => const AllTasksScreen());
      case AppRoutes.personalInfo:
        return MaterialPageRoute(builder: (_) => const PersonalInfoScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
        );
      case AppRoutes.themePreference:
        return MaterialPageRoute(builder: (_) => const ThemePreferenceScreen());
      case AppRoutes.securityPrivacy:
        return MaterialPageRoute(builder: (_) => const SecurityPrivacyScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => const Scaffold(
            body: Center(child: Text('Error: Route not found')),
          ),
    );
  }
}
