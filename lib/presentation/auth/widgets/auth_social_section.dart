import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/constants/app_strings.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';
import 'social_button.dart';

class AuthSocialSection extends StatelessWidget {
  final bool isDark;

  const AuthSocialSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? AppColors.dividerDark : AppColors.divider,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                AppStrings.orContinueWith,
                style: AppStyles.bodySmall(
                  isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? AppColors.dividerDark : AppColors.divider,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: SocialButton(
                label: 'Google',
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    title: 'Coming Soon',
                    desc: 'Google Login is currently disabled.',
                    btnOkOnPress: () {},
                  ).show();
                },
                isIconWidget: true,
                iconWidget: Icon(
                  Icons.g_mobiledata,
                  color: Colors.redAccent,
                  size: 32.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SocialButton(
                label: 'Apple',
                onPressed: () {},
                isIconWidget: true,
                iconWidget: Icon(
                  Icons.apple,
                  color: isDark ? Colors.white : Colors.black,
                  size: 26.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
