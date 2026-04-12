import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../tasks/cubit/task_cubit.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(AppStrings.profile, style: AppStyles.titleLarge()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            _buildUserInfo(),
            SizedBox(height: 32.h),
            _buildStatsSection(),
            SizedBox(height: 40.h),
            _buildAccountSettings(context),
            SizedBox(height: 40.h),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'Taskly User';
        String email = '';
        String? photoUrl;

        if (state is Authenticated) {
          name = state.user.name ?? 'Taskly User';
          email = state.user.email;
          photoUrl = state.user.photoUrl;
        } else if (state is LoginSuccess) {
          name = state.user.name ?? 'Taskly User';
          email = state.user.email;
          photoUrl = state.user.photoUrl;
        } else if (state is RegisterSuccess) {
          name = state.user.name ?? 'Taskly User';
          email = state.user.email;
          photoUrl = state.user.photoUrl;
        }

        return Column(
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: photoUrl == null
                  ? Icon(Icons.person_rounded, color: AppColors.white, size: 60.sp)
                  : null,
            ),
            SizedBox(height: 16.h),
            Text(
              name,
              style: AppStyles.displayMedium().copyWith(fontSize: 24.sp),
            ),
            if (email.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                email,
                style: AppStyles.bodyMediumMedium(AppColors.textLink),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        int completed = 0;
        int ongoing = 0;
        int successRate = 0;

        if (state is TaskSuccess<List<TaskEntity>>) {
          final tasks = state.data;
          completed = tasks.where((t) => t.isCompleted).length;
          ongoing = tasks.where((t) => !t.isCompleted).length;
          if (tasks.isNotEmpty) {
            successRate = ((completed / tasks.length) * 100).round();
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard(AppStrings.completed, '$completed'),
            _buildStatCard(AppStrings.ongoing, '$ongoing'),
            _buildStatCard(AppStrings.success, '$successRate%'),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(label, style: AppStyles.bodySmallMedium(AppColors.primary)),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppStyles.displayMedium().copyWith(fontSize: 22.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.accountSettings,
          style: AppStyles.labelSmall(
            AppColors.textSecondary,
          ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 16.h),
        _buildSettingItem(
          icon: Icons.person_outline,
          title: AppStrings.personalInfo,
          subtitle: AppStrings.personalInfoSub,
          onTap: () => Navigator.pushNamed(context, AppRoutes.personalInfo),
        ),
        _buildSettingItem(
          icon: Icons.notifications_none,
          title: AppStrings.notificationSettings,
          subtitle: AppStrings.notificationSettingsSub,
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
        ),
        _buildSettingItem(
          icon: Icons.palette_outlined,
          title: AppStrings.themePreference,
          subtitle: AppStrings.themePreferenceSub,
          onTap: () => Navigator.pushNamed(context, AppRoutes.themePreference),
        ),
        _buildSettingItem(
          icon: Icons.security,
          title: AppStrings.securityPrivacy,
          subtitle: AppStrings.securityPrivacySub,
          onTap: () => Navigator.pushNamed(context, AppRoutes.securityPrivacy),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.fieldBorder.withValues(alpha: 0.5),
          ),
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
                  SizedBox(height: 2.h),
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

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthCubit>().logout();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              AppStrings.logout,
              style: AppStyles.bodyLargeMedium(Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
