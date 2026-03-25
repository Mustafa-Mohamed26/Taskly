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
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case AppRoutes.passwordChanged:
        return MaterialPageRoute(builder: (_) => const PasswordChangedScreen());
      case AppRoutes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayoutScreen());
      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case AppRoutes.allTasks:
        return MaterialPageRoute(builder: (_) => const AllTasksScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Error: Route not found'),
        ),
      ),
    );
  }
}
