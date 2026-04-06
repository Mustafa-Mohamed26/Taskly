import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String? iconPath;
  final VoidCallback onPressed;
  final bool isIconWidget;
  final Widget? iconWidget;

  const SocialButton({
    super.key,
    required this.label,
    this.iconPath,
    required this.onPressed,
    this.isIconWidget = false,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16.r),
          color: isDark ? AppColors.fieldFillDark : AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIconWidget && iconWidget != null)
              iconWidget!
            else if (iconPath != null)
              Image.asset(iconPath!, height: 20.h, width: 20.h)
            else
              Icon(
                label.toLowerCase().contains('google')
                    ? Icons.g_mobiledata_rounded
                    : Icons.apple_rounded,
                size: 24.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppStyles.bodyMedium(
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
