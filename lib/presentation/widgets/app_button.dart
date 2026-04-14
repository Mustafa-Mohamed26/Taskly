import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showShadow;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height,
    this.radius,
    this.backgroundColor,
    this.textColor,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12.r),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: (backgroundColor ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: textColor ?? AppColors.white,
          minimumSize: Size(double.infinity, height ?? 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12.r),
          ),
          elevation: 0,
          disabledBackgroundColor: (backgroundColor ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.6),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: CircularProgressIndicator(
                  color: textColor ?? AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 22.sp),
                    SizedBox(width: 12.w),
                  ],
                  Text(
                    text,
                    style: AppStyles.labelLarge(textColor ?? AppColors.white).copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
