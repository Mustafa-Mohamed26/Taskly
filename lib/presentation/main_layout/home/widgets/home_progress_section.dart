import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class HomeProgressSection extends StatelessWidget {
  final double progress;
  final bool isDark;

  const HomeProgressSection({
    super.key,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.fieldFillDark : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            builder: (context, value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.dailyProgress,
                        style: AppStyles.titleMedium(
                          isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ).copyWith(fontWeight: FontWeight.w800, fontSize: 16.sp),
                      ),
                      Text(
                        '${(value * 100).toInt()}%',
                        style: AppStyles.titleMedium(
                          const Color(0xFF2E2EBA),
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12.h,
                      backgroundColor: const Color(0xFF2E2EBA).withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2E2EBA),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
