import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class AddTaskPriorityCard extends StatelessWidget {
  final String label;
  final Color dotColor;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const AddTaskPriorityCard({
    super.key,
    required this.label,
    required this.dotColor,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF1F5F9).withValues(alpha: 0.5)
                : (isDark ? AppColors.fieldFillDark : const Color(0xFFF8FAFC)),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.fieldBorderDark
                      : AppColors.fieldBorder.withValues(alpha: 0.3)),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              SizedBox(height: 12.h),
              Text(
                label,
                style: AppStyles.bodyMedium(
                  isSelected ? AppColors.primary : AppColors.textPrimary,
                ).copyWith(
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
