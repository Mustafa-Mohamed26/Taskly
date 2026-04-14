import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/service/cache_helper.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });

    _progressController.forward();

    // Ensure AuthCubit triggers the check on initialization
    context.read<AuthCubit>().checkAuth();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _checkAndNavigate() {
    if (!mounted) return;
    final state = context.read<AuthCubit>().state;
    
    // Only navigate if we've finished the splash animation
    if (_progressController.isCompleted) {
      if (state is Authenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
      } else if (state is Unauthenticated) {
        if (!CacheHelper.getOnboardingCompleted()) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (_progressController.isCompleted) {
          _checkAndNavigate();
        } else if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Authentication Error',
            desc: state.message,
            btnOkOnPress: () => context.read<AuthCubit>().checkAuth(),
          ).show();
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Stack(
            children: [
              _buildBackgroundDecorations(isDark),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(isDark),
                    SizedBox(height: 32.h),
                    Text(
                      AppStrings.appName,
                      style: AppStyles.displayLarge(
                        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ).copyWith(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Simplify your day.',
                      style: AppStyles.bodyLarge(
                        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ).copyWith(
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 60.h,
                left: 40.w,
                right: 40.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PREPARING WORKSPACE',
                          style: AppStyles.labelSmall(
                            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ).copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${(_progressAnimation.value * 100).toInt()}%',
                          style: AppStyles.labelSmall(
                            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ).copyWith(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.check_rounded, color: AppColors.white, size: 60.sp),
    );
  }

  Widget _buildBackgroundDecorations(bool isDark) {
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.05 : 0.03);
    return Stack(
      children: [
        Positioned(
          top: -120.h,
          right: -80.w,
          child: Container(
            width: 320.w,
            height: 320.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
        Positioned(
          bottom: -60.h,
          left: -40.w,
          child: Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
