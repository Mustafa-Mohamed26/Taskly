import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list_app/core/routes/app_routes.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              SizedBox(height: 32.h),
              _buildSocialLogin(),
              SizedBox(height: 40.h),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Sections ---

  Widget _buildHeader() {
    return Column(
      children: [
        const AuthLogo(),
        SizedBox(height: 40.h),
        Text(
          'Welcome Back',
          style: AppStyles.heading1,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Let's get back to crushing those goals.",
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
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'Password',
          hint: 'Enter your password',
          controller: _passwordController,
          obscureText: _obscurePassword,
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
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.forgotPassword);
            },
            child: Text(
              'Forgot Password?',
              style: AppStyles.link,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        AuthButton(
          text: 'Sign In',
          onPressed: () {
            // Handle sign in
          },
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Or continue with',
                style: AppStyles.bodyNormal.copyWith(fontSize: 12.sp),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            SocialButton(
              label: 'Google',
              onPressed: () {},
              isIconWidget: true,
              iconWidget: Icon(Icons.g_mobiledata, color: Colors.red, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            SocialButton(
              label: 'Apple',
              onPressed: () {},
              isIconWidget: true,
              iconWidget: Icon(Icons.apple, color: Colors.black, size: 24.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppStyles.bodyNormal,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Create Account',
            style: AppStyles.link,
          ),
        ),
      ],
    );
  }
}
