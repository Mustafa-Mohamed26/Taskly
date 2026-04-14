import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/validators.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import 'package:taskly/presentation/widgets/app_button.dart';
import 'package:taskly/presentation/widgets/app_text_field.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_background_decorations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: _handleAuthState,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(isDark),
            body: Stack(
              children: [
                AuthBackgroundDecorations(isDark: isDark),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildForgotPasswordHeader(isDark),
                          SizedBox(height: 48.h),
                          AppTextField(
                            label: 'Email Address',
                            hint: 'name@company.com',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => Validators.validateEmail(val),
                            isDark: isDark,
                          ),
                          SizedBox(height: 40.h),
                          AppButton(
                            text: 'Send Reset Link',
                            onPressed: _onSendPressed,
                            isLoading: _isLoading,
                          ),
                          SizedBox(height: 40.h),
                          AuthFooter(
                            text: 'Suddenly remembered? ',
                            actionText: 'Back to Login',
                            onActionPressed: () => Navigator.pop(context),
                            isDark: isDark,
                          ),
                        ],
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

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          size: 20.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Forgot Password',
        style: AppStyles.headlineLarge(
          isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    );
  }

  Widget _buildForgotPasswordHeader(bool isDark) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.1 : 0.05),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 60.sp,
          ),
        ),
        SizedBox(height: 40.h),
        Text(
          'Reset Password',
          style: AppStyles.displayLarge(
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ).copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 32.sp,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          'Enter your email address and we\'ll send you a secure link to reset your password.',
          style: AppStyles.bodyLarge(
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ).copyWith(
            fontSize: 16.sp,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onSendPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
    }
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    setState(() => _isLoading = state is AuthLoading);

    if (state is ForgotPasswordSuccess) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Email Sent',
        desc: state.message,
        btnOkOnPress: () {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
        },
      ).show();
    } else if (state is AuthError) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: state.message,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
