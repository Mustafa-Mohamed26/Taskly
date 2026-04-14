import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';

class AddTaskPriorityCard extends StatelessWidget {
  const AddTaskPriorityCard({
    super.key,
    required this.label,
    required this.dotColor,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final Color dotColor;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cardBg = Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primary.withValues(alpha: 0.1)
                : cardBg,
            border: Border.all(
              color: isSelected
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.12),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              SizedBox(height: 12.h),
              Text(
                label,
                style: AppStyles.bodyMedium(
                  isSelected ? scheme.primary : scheme.onSurface,
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
