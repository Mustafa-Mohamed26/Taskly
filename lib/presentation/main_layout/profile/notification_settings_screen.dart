import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/service/cache_helper.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _remindersEnabled = true;
  bool _emailEnabled = false;
  bool _weeklyEnabled = false;

  @override
  void initState() {
    super.initState();
    _pushEnabled = CacheHelper.getPushNotificationsEnabled();
    _remindersEnabled = CacheHelper.getRemindersEnabled();
    _emailEnabled = CacheHelper.getEmailNotificationsEnabled();
    _weeklyEnabled = CacheHelper.getWeeklyReportsEnabled();
  }

  void _toggleSetting(String key, bool value) {
    HapticFeedback.lightImpact();
    setState(() {
      switch (key) {
        case 'push':
          _pushEnabled = value;
          CacheHelper.setPushNotificationsEnabled(value);
          break;
        case 'reminders':
          _remindersEnabled = value;
          CacheHelper.setRemindersEnabled(value);
          break;
        case 'email':
          _emailEnabled = value;
          CacheHelper.setEmailNotificationsEnabled(value);
          break;
        case 'weekly':
          _weeklyEnabled = value;
          CacheHelper.setWeeklyReportsEnabled(value);
          break;
      }
    });
  }

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
        title: Text(
          AppStrings.notificationSettings,
          style: AppStyles.titleLarge(),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
          _buildSectionHeader('APP NOTIFICATIONS'),
          SizedBox(height: 16.h),
          _buildNotificationItem(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            subtitle: 'Instant alerts on your device',
            value: _pushEnabled,
            onChanged: (val) => _toggleSetting('push', val),
          ),
          _buildNotificationItem(
            icon: Icons.access_time,
            title: 'Reminders',
            subtitle: 'Don\'t miss upcoming deadlines',
            value: _remindersEnabled,
            onChanged: (val) => _toggleSetting('reminders', val),
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader('ACCOUNT UPDATES'),
          SizedBox(height: 16.h),
          _buildNotificationItem(
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Important updates to your inbox',
            value: _emailEnabled,
            onChanged: (val) => _toggleSetting('email', val),
          ),
          _buildNotificationItem(
            icon: Icons.bar_chart_rounded,
            title: 'Weekly Reports',
            subtitle: 'Summary of your task completion',
            value: _weeklyEnabled,
            onChanged: (val) => _toggleSetting('weekly', val),
          ),
          SizedBox(height: 32.h),
          _buildInfoCard(),
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

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
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
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'You can manage more granular settings for specific teams or projects in the individual project settings menu.',
              style: AppStyles.bodySmall().copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
