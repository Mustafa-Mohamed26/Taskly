import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class AllTasksDateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const AllTasksDateCard({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 75.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF0F4F8).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: AppStyles.bodyMedium(
                isSelected ? AppColors.white : AppColors.textSecondary,
              ).copyWith(fontWeight: FontWeight.w600, fontSize: 16.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              DateFormat('E').format(date),
              style: AppStyles.bodyMedium(
                isSelected ? AppColors.white : AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w900, fontSize: 16.sp),
            ),
            if (isSelected) ...[
              SizedBox(height: 6.h),
              Container(
                width: 5.w,
                height: 5.w,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
