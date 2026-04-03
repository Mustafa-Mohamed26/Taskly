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
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: const BorderSide(color: AppColors.fieldBorder),
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIconWidget && iconWidget != null)
              iconWidget!
            else if (iconPath != null)
              Image.asset(iconPath!, height: 24.h, width: 24.h),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppStyles.bodyMedium().copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
