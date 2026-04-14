import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.securityPrivacy, style: AppStyles.titleLarge(Theme.of(context).colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
          _buildSecurityBanner(context),
          SizedBox(height: 32.h),
          _buildSectionHeader(context, 'ACCOUNT SECURITY'),
          SizedBox(height: 16.h),
          _buildSecurityItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Last updated 3 months ago',
            onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
          ),
          _buildToggleItem(
            context: context,
            icon: Icons.security_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of protection',
            value: true,
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader(context, 'PRIVACY & DATA'),
          SizedBox(height: 16.h),
          _buildSecurityItem(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'Data Privacy Policy',
            subtitle: 'Manage how your data is used',
            onTap: () {},
          ),
          _buildSecurityItem(
            context: context,
            icon: Icons.apps_rounded,
            title: 'App Permissions',
            subtitle: 'Camera, Storage, and Contacts',
            onTap: () {},
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader(context, 'DANGER ZONE'),
          SizedBox(height: 16.h),
          _buildDangerItem(
            context: context,
            icon: Icons.delete_forever_outlined,
            title: 'Delete Account',
            subtitle: 'This action is permanent and cannot be undone',
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBg = isDark ? const Color(0xFF131629) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
                Text('Account is Secure', style: AppStyles.bodyLargeMedium(Theme.of(context).colorScheme.onSurface)),
                Text(
                  'Your security settings are up to date.',
                  style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppStyles.labelSmall(
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildSecurityItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBg = isDark ? const Color(0xFF131629) : AppColors.white;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyLargeMedium(Theme.of(context).colorScheme.onSurface)),
                  Text(subtitle, style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBg = isDark ? const Color(0xFF131629) : AppColors.white;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyLargeMedium(Theme.of(context).colorScheme.onSurface)),
                Text(subtitle, style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {},
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBg = isDark ? const Color(0xFF131629) : Colors.red.withValues(alpha: 0.05);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: itemBg,
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
                  style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
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
