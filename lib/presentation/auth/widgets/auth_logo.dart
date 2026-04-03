import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(Icons.check_rounded, color: AppColors.white, size: 40.sp),
        ),
        SizedBox(height: 16.h),
        Text(
          'Taskly',
          style: AppStyles.displayMedium().copyWith(fontSize: 22.sp),
        ),
      ],
    );
  }
}
