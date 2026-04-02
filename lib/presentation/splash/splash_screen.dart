import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/service/cache_helper.dart';
import 'package:taskly/domain/entities/user_entity.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _navigate(String route) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is AuthSuccess<UserEntity>) {
          _navigate(AppRoutes.mainLayout);
        } else if (state is AuthInitial) {
          if (CacheHelper.getOnboardingCompleted()) {
            _navigate(AppRoutes.login);
          } else {
            _navigate(AppRoutes.onboarding);
          }
        } else if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Authentication Error',
            desc: state.message,
            btnOkOnPress: () {
              // Retry checkAuth if error occurs
              context.read<AuthCubit>().checkAuth();
            },
          ).show();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.white,
            body: Stack(
              children: [
                _buildBackgroundDecorations(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(Icons.check_rounded, color: AppColors.white, size: 50.sp),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        AppStrings.appName,
                        style: AppStyles.displayLarge().copyWith(
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Manage Your Daily Tasks',
                        style: AppStyles.bodyLarge().copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50.h,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: AppStyles.bodyMedium().copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: 40.w,
                        height: 2.h,
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const AuthLoadingWidget(),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.03),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.03),
            ),
          ),
        ),
      ],
    );
  }
}
