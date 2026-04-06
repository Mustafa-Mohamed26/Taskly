import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/core/utils/validators.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_logo.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';
import 'widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is LoginSuccess) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Login Success',
            desc: 'Welcome back, ${state.user.name ?? 'User'}!',
            btnOkOnPress: () {
              Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
            },
          ).show();
        } else if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Login Error',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                _buildBackgroundDecorations(isDark),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const AuthLogo(),
                            SizedBox(height: 48.h),
                            Text(
                              AppStrings.welcomeBack,
                              style: AppStyles.displayLarge(
                                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ).copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 32.sp,
                                letterSpacing: -1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              AppStrings.welcomeBackSubtitle,
                              style: AppStyles.bodyLarge(
                                isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ).copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 48.h),
                            _buildForm(isDark),
                            SizedBox(height: 40.h),
                            _buildSocialLogin(isDark),
                            SizedBox(height: 48.h),
                            _buildFooter(isDark),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: AppStrings.email,
          hint: 'name@company.com',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (val) => Validators.validateEmail(val),
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: AppStrings.password,
          hint: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          validator: (val) => Validators.validatePassword(val),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: isDark ? AppColors.textSecondaryDark : AppColors.fieldHint,
              size: 22.sp,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.forgotPassword);
            },
            child: Text(
              AppStrings.forgotPassword,
              style: AppStyles.labelSmall(AppColors.primary).copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 32.h),
        AuthButton(
          text: AppStrings.signIn,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().login(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSocialLogin(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? AppColors.dividerDark : AppColors.divider,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                AppStrings.orContinueWith,
                style: AppStyles.bodySmall(
                  isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? AppColors.dividerDark : AppColors.divider,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: SocialButton(
                label: 'Google',
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    title: 'Coming Soon',
                    desc: 'Google Login is currently disabled.',
                    btnOkOnPress: () {},
                  ).show();
                },
                isIconWidget: true,
                iconWidget: Icon(
                  Icons.g_mobiledata,
                  color: Colors.redAccent,
                  size: 32.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SocialButton(
                label: 'Apple',
                onPressed: () {},
                isIconWidget: true,
                iconWidget: Icon(
                  Icons.apple,
                  color: isDark ? Colors.white : Colors.black,
                  size: 26.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: AppStyles.bodyMedium(
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: Text(
            ' ${AppStrings.createAccount}',
            style: AppStyles.labelSmall(AppColors.primary).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDecorations(bool isDark) {
    final color = AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.02);
    return Stack(
      children: [
        Positioned(
          top: -100.h,
          right: -80.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
        Positioned(
          bottom: -50.h,
          left: -40.w,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
