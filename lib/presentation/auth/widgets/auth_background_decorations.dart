import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';

class AuthBackgroundDecorations extends StatelessWidget {
  final bool isDark;

  const AuthBackgroundDecorations({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.02);
    return Stack(
      children: [
        Positioned(
          top: -100.h,
          right: -80.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
        Positioned(
          bottom: -50.h,
          left: -40.w,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
