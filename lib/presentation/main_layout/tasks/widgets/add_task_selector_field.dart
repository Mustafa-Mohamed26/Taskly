import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../presentation/widgets/section_title.dart';

class AddTaskSelectorField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback onTap;

  const AddTaskSelectorField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: label, isDark: isDark),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.fieldFillDark : AppColors.white,
              border: Border.all(
                color: isDark
                    ? AppColors.fieldBorderDark
                    : AppColors.fieldBorder.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(icon, size: 24.sp, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    value,
                    style: AppStyles.bodyMedium(
                      isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ).copyWith(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
