import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_logo.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 48.h),
              _buildForm(),
              SizedBox(height: 40.h),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const AuthLogo(),
        SizedBox(height: 40.h),
        Text(
          'Join Taskly',
          style: AppStyles.heading1,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Start managing your tasks efficiently today.",
          style: AppStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: 'Full Name',
          hint: 'John Doe',
          controller: _nameController,
          prefixIcon: Icons.person_outline,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'Email Address',
          hint: 'name@company.com',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'Password',
          hint: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'Confirm Password',
          hint: '••••••••',
          controller: _confirmPasswordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.shield_outlined,
        ),
        SizedBox(height: 32.h),
        AuthButton(
          text: 'Create Account',
          onPressed: () {
            // Handle registration
          },
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppStyles.bodyNormal,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Sign in',
            style: AppStyles.link,
          ),
        ),
      ],
    );
  }
}
