import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const AppLogo({
    super.key,
    this.size = 22,
    this.showText = true,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.check_rounded,
            color: AppColors.white,
            size: size.sp,
          ),
        ),
        if (showText) ...[
          SizedBox(width: 10.w),
          Text(
            'Taskly',
            style: AppStyles.displayMedium(
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ).copyWith(
              fontWeight: FontWeight.w900,
              fontSize: size.sp,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
