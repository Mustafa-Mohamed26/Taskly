import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTaskBackgroundDecorations extends StatelessWidget {
  final bool isDark;

  const AddTaskBackgroundDecorations({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.04 : 0.02);
    return Stack(
      children: [
        Positioned(
          top: -50.h,
          right: -30.w,
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
