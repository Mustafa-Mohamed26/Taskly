import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/di/di.dart';
import 'package:taskly/core/service/cache_helper.dart';
import 'package:taskly/firebase_options.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/main_layout/focus/cubit/focus_cubit.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/sync_cubit.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_routes_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await CacheHelper.init();
  } catch (e) {
    debugPrint('CacheHelper initialization failed: $e');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>()..checkAuth(),
        ),
        BlocProvider<TaskCubit>(
          create: (context) => getIt<TaskCubit>(),
        ),
        BlocProvider<SyncCubit>(
          create: (context) => getIt<SyncCubit>(),
        ),
        BlocProvider<FocusCubit>(
          create: (context) => getIt<FocusCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Taskly',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutesGenerator.onGenerateRoute,
          );
        },
      ),
    );
  }
}
