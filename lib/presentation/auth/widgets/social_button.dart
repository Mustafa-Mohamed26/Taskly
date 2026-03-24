import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;
  final bool isIconWidget;
  final Widget? iconWidget;

  const SocialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconPath = '',
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          side: const BorderSide(color: AppColors.fieldBorder),
          backgroundColor: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIconWidget && iconWidget != null)
              iconWidget!
            else if (iconPath.isNotEmpty)
              Image.asset(
                iconPath,
                height: 20.h,
              ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppStyles.bodyNormal.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
