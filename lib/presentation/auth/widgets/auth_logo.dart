import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 28.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          'Taskly',
          style: AppStyles.heading2.copyWith(fontSize: 22.sp),
        ),
      ],
    );
  }
}
