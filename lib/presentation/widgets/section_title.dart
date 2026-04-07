import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const SectionTitle({
    super.key,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppStyles.labelSmall(
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ).copyWith(
        letterSpacing: 1.2,
        fontWeight: FontWeight.w900,
        fontSize: 13.sp,
      ),
    );
  }
}
