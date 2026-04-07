import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';

class AuthFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionPressed;
  final bool isDark;

  const AuthFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppStyles.bodyMedium(
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: onActionPressed,
          child: Text(
            ' $actionText',
            style: AppStyles.labelSmall(AppColors.primary).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
