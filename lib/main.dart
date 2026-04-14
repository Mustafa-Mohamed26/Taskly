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
import 'package:taskly/presentation/main_layout/home/cubit/home_cubit.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/schedule_cubit.dart';
import 'package:taskly/presentation/main_layout/calendar/cubit/calendar_view_cubit.dart';
import 'package:taskly/presentation/main_layout/profile/cubit/profile_stats_cubit.dart';
import 'package:taskly/presentation/main_layout/profile/cubit/security_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_routes_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
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
          create: (_) => getIt<AuthCubit>()..checkAuth(),
        ),
        BlocProvider<TaskCubit>(create: (_) => getIt<TaskCubit>()),
        BlocProvider<SyncCubit>(create: (_) => getIt<SyncCubit>()),
        BlocProvider<FocusCubit>(create: (_) => getIt<FocusCubit>()),
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<ScheduleCubit>(create: (_) => getIt<ScheduleCubit>()),
        BlocProvider<CalendarViewCubit>(create: (_) => getIt<CalendarViewCubit>()),
        BlocProvider<ProfileStatsCubit>(create: (_) => getIt<ProfileStatsCubit>()),
        BlocProvider<SecurityCubit>(create: (_) => getIt<SecurityCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is Authenticated ||
                  state is LoginSuccess ||
                  state is RegisterSuccess) {
                final userId = (state as dynamic).user.id;
                context.read<TaskCubit>().watchTasks(userId);
                context.read<HomeCubit>().init(userId);
                context.read<ScheduleCubit>().init(userId);
                context.read<CalendarViewCubit>().init(userId);
                context.read<ProfileStatsCubit>().init(userId);
                context.read<SecurityCubit>().init();
              }
            },
            child: ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, _) {
                return BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Taskly',
                      theme: AppTheme.light(themeState.accentColor),
                      darkTheme: AppTheme.dark(themeState.accentColor),
                      themeMode: themeState.mode,
                      onGenerateRoute: AppRoutesGenerator.onGenerateRoute,
                      initialRoute: AppRoutes.splash,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
