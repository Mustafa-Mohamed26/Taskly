import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/security_cubit.dart';
import 'cubit/security_state.dart';
import '../../auth/cubit/auth_cubit.dart';
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
      body: BlocConsumer<SecurityCubit, SecurityState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            children: [
              _buildSecurityBanner(context, state.biometricEnabled),
              SizedBox(height: 32.h),
              _buildSectionHeader(context, 'ACCOUNT SECURITY'),
              SizedBox(height: 16.h),
              _buildSecurityItem(
                context: context,
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Last updated 3 months ago',
                onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
              ),
              if (state.isBiometricSupported)
                _buildToggleItem(
                  context: context,
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric Lock',
                  subtitle: 'Use FaceID or Fingerprint to unlock',
                  value: state.biometricEnabled,
                  onChanged: (val) => context.read<SecurityCubit>().toggleBiometric(val),
                ),
              _buildToggleItem(
                context: context,
                icon: Icons.notifications_paused_outlined,
                title: 'Private Notifications',
                subtitle: 'Hide task details from lock screen',
                value: state.hideNotificationsEnabled,
                onChanged: (val) => context.read<SecurityCubit>().toggleHideNotifications(val),
              ),
              SizedBox(height: 32.h),
              _buildSectionHeader(context, 'PRIVACY & DATA'),
              SizedBox(height: 16.h),
              _buildSecurityItem(
                context: context,
                icon: Icons.privacy_tip_outlined,
                title: 'Data Privacy Policy',
                subtitle: 'Manage how your data is used',
                onTap: () => _showPrivacyPolicy(context),
              ),
              _buildSecurityItem(
                context: context,
                icon: Icons.apps_rounded,
                title: 'App Permissions',
                subtitle: 'Camera, Storage, and Contacts',
                onTap: () => context.read<SecurityCubit>().openAppSettings(),
              ),
              SizedBox(height: 32.h),
              _buildSectionHeader(context, 'DANGER ZONE'),
              SizedBox(height: 16.h),
              _buildDangerItem(
                context: context,
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'This action is permanent and cannot be undone',
                onTap: () {
                  final userId = (context.read<AuthCubit>().state as dynamic).user.id;
                  _showDeleteConfirmation(context, userId);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSecurityBanner(BuildContext context, bool isSecure) {
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
              color: isSecure ? Colors.green : Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSecure ? Icons.shield_rounded : Icons.verified_user_outlined,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSecure ? 'Enhanced Security Active' : 'Basic Security Active',
                  style: AppStyles.bodyLargeMedium(Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  isSecure 
                    ? 'Your account is protected by biometric lock.' 
                    : 'Consider enabling biometric lock for extra safety.',
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
    required ValueChanged<bool> onChanged,
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
            onChanged: onChanged,
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
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBg = isDark ? const Color(0xFF131629) : Colors.red.withValues(alpha: 0.05);

    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Privacy Policy', style: AppStyles.titleMedium(Theme.of(context).colorScheme.onSurface)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'At Taskly, we value your privacy. We only collect data necessary to provide you with the best task management experience.',
                style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(height: 12.h),
              Text(
                '• Your tasks are stored securely in encrypted cloud storage.\n'
                '• We do not share your personal information with third parties.\n'
                '• You have full control over your data and can delete it at any time.',
                style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?', style: TextStyle(color: Colors.red)),
        content: const Text(
          'This will permanently delete your profile and ALL your tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SecurityCubit>().deleteAccount(uid);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
