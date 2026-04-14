import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../../core/constants/app_strings.dart';
import 'cubit/profile_stats_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF131629) : AppColors.white;
    final borderColor = isDark
        ? const Color(0xFF1C1F37)
        : AppColors.fieldBorder.withValues(alpha: 0.5);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(AppStrings.profile, style: AppStyles.titleLarge(scheme.onSurface)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            _buildUserInfo(context, scheme: scheme),
            SizedBox(height: 32.h),
            _buildStatsSection(context, cardBg: cardBg, borderColor: borderColor, scheme: scheme),
            SizedBox(height: 40.h),
            _buildAccountSettings(
              context,
              cardBg: cardBg,
              borderColor: borderColor,
              scheme: scheme,
            ),
            SizedBox(height: 40.h),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserInfo(BuildContext context, {required ColorScheme scheme}) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      String name = 'Taskly User';
      String email = '';
      String? photoUrl;

      if (state is Authenticated) {
        name = state.user.name ?? name;
        email = state.user.email;
        photoUrl = state.user.photoUrl;
      } else if (state is LoginSuccess) {
        name = state.user.name ?? name;
        email = state.user.email;
        photoUrl = state.user.photoUrl;
      } else if (state is RegisterSuccess) {
        name = state.user.name ?? name;
        email = state.user.email;
        photoUrl = state.user.photoUrl;
      }

      return Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.3),
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
                ? Icon(Icons.person_rounded, color: scheme.onPrimary, size: 60.sp)
                : null,
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: AppStyles.displayMedium(scheme.onSurface).copyWith(fontSize: 24.sp),
          ),
          if (email.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(email, style: AppStyles.bodyMediumMedium(scheme.primary)),
          ],
        ],
      );
    },
  );
}

Widget _buildStatsSection(
  BuildContext context, {
  required Color cardBg,
  required Color borderColor,
  required ColorScheme scheme,
}) {
  return BlocBuilder<ProfileStatsCubit, ProfileStatsState>(
    builder: (context, state) {
      final completed = state.completedTasks;
      final ongoing = state.ongoingTasks;
      final successRate = state.successRate;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(context, label: AppStrings.completed, value: '$completed', cardBg: cardBg, borderColor: borderColor, scheme: scheme),
          _buildStatCard(context, label: AppStrings.ongoing, value: '$ongoing', cardBg: cardBg, borderColor: borderColor, scheme: scheme),
          _buildStatCard(context, label: AppStrings.success, value: '$successRate%', cardBg: cardBg, borderColor: borderColor, scheme: scheme),
        ],
      );
    },
  );
}

Widget _buildStatCard(
  BuildContext context, {
  required String label,
  required String value,
  required Color cardBg,
  required Color borderColor,
  required ColorScheme scheme,
}) {
  return Container(
    width: 100.w,
    padding: EdgeInsets.symmetric(vertical: 16.h),
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      children: [
        Text(label, style: AppStyles.bodySmallMedium(scheme.primary)),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppStyles.displayMedium(scheme.onSurface).copyWith(fontSize: 22.sp),
        ),
      ],
    ),
  );
}

Widget _buildAccountSettings(
  BuildContext context, {
  required Color cardBg,
  required Color borderColor,
  required ColorScheme scheme,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppStrings.accountSettings,
        style: AppStyles.labelSmall(scheme.onSurface.withValues(alpha: 0.6))
            .copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
      ),
      SizedBox(height: 16.h),
      _buildSettingItem(
        context,
        cardBg: cardBg, borderColor: borderColor, scheme: scheme,
        icon: Icons.person_outline,
        title: AppStrings.personalInfo,
        subtitle: AppStrings.personalInfoSub,
        onTap: () => Navigator.pushNamed(context, AppRoutes.personalInfo),
      ),
      _buildSettingItem(
        context,
        cardBg: cardBg, borderColor: borderColor, scheme: scheme,
        icon: Icons.notifications_none,
        title: AppStrings.notificationSettings,
        subtitle: AppStrings.notificationSettingsSub,
        onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
      ),
      _buildSettingItem(
        context,
        cardBg: cardBg, borderColor: borderColor, scheme: scheme,
        icon: Icons.palette_outlined,
        title: AppStrings.themePreference,
        subtitle: AppStrings.themePreferenceSub,
        onTap: () => Navigator.pushNamed(context, AppRoutes.themePreference),
      ),
      _buildSettingItem(
        context,
        cardBg: cardBg, borderColor: borderColor, scheme: scheme,
        icon: Icons.security,
        title: AppStrings.securityPrivacy,
        subtitle: AppStrings.securityPrivacySub,
        onTap: () => Navigator.pushNamed(context, AppRoutes.securityPrivacy),
      ),
    ],
  );
}

Widget _buildSettingItem(
  BuildContext context, {
  required Color cardBg,
  required Color borderColor,
  required ColorScheme scheme,
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
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: scheme.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyLargeMedium(scheme.onSurface)),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppStyles.bodySmall(scheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: scheme.onSurface.withValues(alpha: 0.4),
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
          Text(AppStrings.logout, style: AppStyles.bodyLargeMedium(Colors.red)),
        ],
      ),
    ),
  );
}
