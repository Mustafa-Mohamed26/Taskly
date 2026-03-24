import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Forgot Password',
          style: AppStyles.label.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIconHeader(),
              SizedBox(height: 32.h),
              _buildContent(),
              SizedBox(height: 32.h),
              _buildForm(),
              SizedBox(height: 40.h),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconHeader() {
    return Center(
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.refresh_rounded,
          color: AppColors.primary,
          size: 40.sp,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Text(
          'Reset Password',
          style: AppStyles.heading1,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          'Enter the email address associated with your account and we\'ll send you a secure link to reset your password.',
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
          label: 'Email Address',
          hint: 'name@company.com',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(height: 32.h),
        AuthButton(
          text: 'Send Reset Link',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.changePassword);
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
          'Suddenly remembered? ',
          style: AppStyles.bodyNormal,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
          },
          child: Text(
            'Back to Login',
            style: AppStyles.link,
          ),
        ),
      ],
    );
  }
}
