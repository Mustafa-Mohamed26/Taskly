import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class HomeBackgroundDecorations extends StatelessWidget {
  final bool isDark;

  const HomeBackgroundDecorations({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.02);
    return Stack(
      children: [
        Positioned(
          top: -100.h,
          right: -50.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
        Positioned(
          bottom: 200.h,
          left: -80.w,
          child: Container(
            width: 250.w,
            height: 250.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
