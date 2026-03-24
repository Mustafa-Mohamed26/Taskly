import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
          'Change Password',
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
              _buildHeader(),
              SizedBox(height: 32.h),
              _buildForm(),
              SizedBox(height: 24.h),
              _buildChecklist(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure your account',
          style: AppStyles.heading1,
        ),
        SizedBox(height: 12.h),
        Text(
          'Enter your current password and choose a new one to update your security settings.',
          style: AppStyles.subtitle,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AuthTextField(
          label: 'Current Password',
          hint: 'Enter current password',
          controller: _currentPasswordController,
          obscureText: _obscureCurrent,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
          ),
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'New Password',
          hint: 'Minimum 8 characters',
          controller: _newPasswordController,
          obscureText: _obscureNew,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed: () => setState(() => _obscureNew = !_obscureNew),
          ),
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'Confirm New Password',
          hint: 'Repeat new password',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklist() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SECURITY CHECKLIST',
            style: AppStyles.label.copyWith(
              color: AppColors.primary,
              fontSize: 12.sp,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          _buildChecklistItem('At least 8 characters long', true),
          SizedBox(height: 8.h),
          _buildChecklistItem('Includes a number or symbol', false),
          SizedBox(height: 8.h),
          _buildChecklistItem('Includes uppercase and lowercase', false),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isChecked) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: isChecked ? Colors.green : AppColors.textSecondary,
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: AppStyles.bodyNormal.copyWith(
            fontSize: 13.sp,
            color: isChecked ? Colors.green : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return AuthButton(
      text: 'Update Password',
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.passwordChanged);
      },
    );
  }
}
