import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class HomeEmptyState extends StatelessWidget {
  final bool isDark;

  const HomeEmptyState({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 60.sp,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          SizedBox(height: 16.h),
          Text(
            'No tasks for today',
            style: AppStyles.titleMedium(
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the + button to add a task',
            style: AppStyles.bodyMedium(
              isDark ? AppColors.textSecondaryDark.withValues(alpha: 0.5) : AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
