import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';

class AddTaskCategoryChip extends StatelessWidget {
  const AddTaskCategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cardBg = Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : cardBg,
          border: Border.all(
            color: isSelected
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected ? scheme.onPrimary : scheme.onSurface,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppStyles.bodyMedium(
                isSelected ? scheme.onPrimary : scheme.onSurface,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
