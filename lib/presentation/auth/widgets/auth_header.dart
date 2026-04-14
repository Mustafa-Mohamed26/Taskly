import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';
import 'package:taskly/presentation/widgets/app_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLogo(isDark: isDark),
        SizedBox(height: 48.h),
        Text(
          title,
          style: AppStyles.displayLarge(
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ).copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 32.sp,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          subtitle,
          style: AppStyles.bodyLarge(
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ).copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
