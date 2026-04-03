import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

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
        title: Text(AppStrings.securityPrivacy, style: AppStyles.titleLarge()),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
          _buildSecurityBanner(),
          SizedBox(height: 32.h),
          _buildSectionHeader('ACCOUNT SECURITY'),
          SizedBox(height: 16.h),
          _buildSecurityItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Last updated 3 months ago',
            onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
          ),
          _buildToggleItem(
            icon: Icons.security_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of protection',
            value: true,
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader('PRIVACY & DATA'),
          SizedBox(height: 16.h),
          _buildSecurityItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Data Privacy Policy',
            subtitle: 'Manage how your data is used',
            onTap: () {},
          ),
          _buildSecurityItem(
            icon: Icons.apps_rounded,
            title: 'App Permissions',
            subtitle: 'Camera, Storage, and Contacts',
            onTap: () {},
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader('DANGER ZONE'),
          SizedBox(height: 16.h),
          _buildDangerItem(
            icon: Icons.delete_forever_outlined,
            title: 'Delete Account',
            subtitle: 'This action is permanent and cannot be undone',
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBanner() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account is Secure', style: AppStyles.bodyLargeMedium()),
                Text(
                  'Your security settings are up to date.',
                  style: AppStyles.bodySmall(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppStyles.labelSmall(
        AppColors.textSecondary,
      ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyLargeMedium()),
                  Text(subtitle, style: AppStyles.bodySmall()),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyLargeMedium()),
                Text(subtitle, style: AppStyles.bodySmall()),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.red, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyLargeMedium(Colors.red)),
                Text(
                  subtitle,
                  style: AppStyles.bodySmall(AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.withValues(alpha: 0.5),
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}
