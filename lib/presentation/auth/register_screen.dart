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
import 'widgets/auth_header.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_background_decorations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                              title: 'Join Taskly',
                              subtitle: 'Start managing your tasks efficiently today.',
                              isDark: isDark,
                            ),
                            SizedBox(height: 20.h),
                            _buildRegisterForm(isDark),
                            SizedBox(height: 20.h),
                            AuthFooter(
                              text: 'Already have an account? ',
                              actionText: 'Sign In',
                              onActionPressed: () => Navigator.pop(context),
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

  Widget _buildRegisterForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: AppStrings.fullName,
          hint: 'John Doe',
          controller: _nameController,
          prefixIcon: Icons.person_outline,
          validator: (val) => Validators.validateFullName(val),
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
        AppTextField(
          label: AppStrings.email,
          hint: 'name@company.com',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (val) => Validators.validateEmail(val),
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
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
              size: 22.sp,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        SizedBox(height: 20.h),
        AppTextField(
          label: AppStrings.confirmPassword,
          hint: '••••••••',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          prefixIcon: Icons.shield_outlined,
          validator: (val) => Validators.validateConfirmPassword(val, _passwordController.text),
          isDark: isDark,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 22.sp,
            ),
            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
        ),
        SizedBox(height: 32.h),
        AppButton(
          text: AppStrings.createAccount,
          onPressed: _onRegisterPressed,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    setState(() => _isLoading = state is AuthLoading);

    if (state is RegisterSuccess) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Registration Success',
        desc: 'Account created successfully!',
        btnOkOnPress: () => Navigator.pushReplacementNamed(context, AppRoutes.mainLayout),
      ).show();
    } else if (state is AuthError) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Registration Error',
        desc: state.message,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
