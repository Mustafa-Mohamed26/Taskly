import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/core/utils/validators.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import 'package:taskly/presentation/widgets/app_button.dart';
import 'package:taskly/presentation/widgets/app_text_field.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_social_section.dart';
import 'widgets/auth_background_decorations.dart';

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
      listener: _handleAuthState,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                AuthBackgroundDecorations(isDark: isDark),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthHeader(
                              title: AppStrings.welcomeBack,
                              subtitle: AppStrings.welcomeBackSubtitle,
                              isDark: isDark,
                            ),
                            SizedBox(height: 48.h),
                            _buildLoginForm(isDark),
                            SizedBox(height: 40.h),
                            AuthSocialSection(isDark: isDark),
                            SizedBox(height: 48.h),
                            AuthFooter(
                              text: AppStrings.dontHaveAccount,
                              actionText: AppStrings.createAccount,
                              onActionPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                              isDark: isDark,
                            ),
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

  Widget _buildLoginForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: AppStrings.email,
          hint: 'name@company.com',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (val) => Validators.validateEmail(val),
          isDark: isDark,
        ),
        SizedBox(height: 24.h),
        AppTextField(
          label: AppStrings.password,
          hint: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          validator: (val) => Validators.validatePassword(val),
          isDark: isDark,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: isDark ? AppColors.textSecondaryDark : AppColors.fieldHint,
              size: 22.sp,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
            child: Text(
              AppStrings.forgotPassword,
              style: AppStyles.labelSmall(Theme.of(context).colorScheme.primary).copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 32.h),
        AppButton(
          text: AppStrings.signIn,
          onPressed: _onLoginPressed,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    setState(() => _isLoading = state is AuthLoading);

    if (state is LoginSuccess) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Login Success',
        desc: 'Welcome back, ${state.user.name ?? 'User'}!',
        btnOkOnPress: () => Navigator.pushReplacementNamed(context, AppRoutes.mainLayout),
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
  }
}
