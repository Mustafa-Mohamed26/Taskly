import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class HomeSummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final Color textColor;
  final IconData icon;
  final bool isDark;
  final bool hasDecoration;

  const HomeSummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.textColor,
    required this.icon,
    this.isDark = false,
    this.hasDecoration = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!isDark && color != AppColors.white)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 10),
            ),
          if (!isDark && color == AppColors.white)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            if (hasDecoration)
              Positioned(
                right: -25.w,
                top: -25.h,
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: textColor.withValues(alpha: 0.08),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: textColor, size: 24.sp),
                  const Spacer(),
                  Text(
                    title,
                    style: AppStyles.bodyMediumMedium(
                      textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    count,
                    style: AppStyles.titleLarge(
                      textColor,
                    ).copyWith(fontWeight: FontWeight.w900, fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
