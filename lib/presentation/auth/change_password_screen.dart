import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? email;
  const ChangePasswordScreen({super.key, this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Change Password',
          style: AppStyles.titleSmall().copyWith(fontSize: 18.sp),
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
              SizedBox(height: 40.h),
              _buildForm(),
              SizedBox(height: 32.h),
              _buildChecklist(),
              SizedBox(height: 40.h),
              AuthButton(
                text: 'Update Password',
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.passwordChanged,
                  );
                },
              ),
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
        Text('Create New Password', style: AppStyles.displayLarge()),
        SizedBox(height: 8.h),
        Text(
          'Your new password must be different from previous passwords.',
          style: AppStyles.bodyLarge(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AuthTextField(
          label: 'New Password',
          hint: '••••••••',
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed:
                () =>
                    setState(() => _obscureNewPassword = !_obscureNewPassword),
          ),
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: 'Confirm New Password',
          hint: '••••••••',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed:
                () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklist() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildCheckItem('At least 8 characters long', true),
          SizedBox(height: 12.h),
          _buildCheckItem('Must contain at least one uppercase letter', false),
          SizedBox(height: 12.h),
          _buildCheckItem('Must contain at least one number', true),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, bool isChecked) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.check_circle_outline,
          color: isChecked ? Colors.green : AppColors.textSecondary,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: AppStyles.bodyMedium().copyWith(
              color: isChecked ? Colors.green : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
