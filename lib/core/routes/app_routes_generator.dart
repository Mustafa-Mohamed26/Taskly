import 'package:flutter/material.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/auth/forgot_password_screen.dart';
import '../../presentation/auth/change_password_screen.dart';
import '../../presentation/auth/password_changed_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/main_layout/main_layout_screen.dart';
import '../../presentation/tasks/add_task_screen.dart';
import '../../presentation/tasks/all_tasks_screen.dart';
import '../../presentation/profile/personal_info_screen.dart';
import '../../presentation/profile/notification_settings_screen.dart';
import '../../presentation/profile/theme_preference_screen.dart';
import '../../presentation/profile/security_privacy_screen.dart';
import 'app_routes.dart';

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
      case AppRoutes.changePassword:
        final email = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen(email: email));
      case AppRoutes.passwordChanged:
        return MaterialPageRoute(builder: (_) => const PasswordChangedScreen());
      case AppRoutes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayoutScreen());
      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
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
