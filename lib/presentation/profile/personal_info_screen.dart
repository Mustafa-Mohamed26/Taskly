import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.personalInfo, style: AppStyles.titleLarge()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            _buildProfileIcon(),
            SizedBox(height: 32.h),
            _buildForm(),
            SizedBox(height: 24.h),
            _buildVerificationBanner(),
            SizedBox(height: 32.h),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Icon(Icons.check_rounded, color: AppColors.white, size: 60.sp),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildInfoField('Full Name', 'Alex Thompson', Icons.person_outline),
        SizedBox(height: 20.h),
        _buildInfoField(
          'Email Address',
          'alex.t@taskly.app',
          Icons.email_outlined,
        ),
        SizedBox(height: 20.h),
        _buildInfoField(
          'Phone Number',
          '+1 (415) 555-0123',
          Icons.phone_outlined,
        ),
        SizedBox(height: 20.h),
        _buildBioField(),
      ],
    );
  }

  Widget _buildInfoField(String label, String initialValue, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(label, style: AppStyles.labelSmall(AppColors.textPrimary)),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: initialValue,
          style: AppStyles.bodyMedium(AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.notes_rounded, size: 16.sp, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text('Bio', style: AppStyles.labelSmall(AppColors.textPrimary)),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue:
              'Product Designer focusing on productivity tools and streamlined workflows. Always multitasking.',
          maxLines: 4,
          style: AppStyles.bodyMedium(AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Verification',
                  style: AppStyles.bodyLargeMedium(),
                ),
                Text(
                  'Your account is fully verified',
                  style: AppStyles.bodySmall(),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text('Save Changes', style: AppStyles.labelLarge()),
        ),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: Size(double.infinity, 56.h),
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Cancel',
            style: AppStyles.bodyLargeMedium(AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
