import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 60.sp,
              color: scheme.primary.withValues(alpha: 0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'No tasks for today',
              style: AppStyles.titleMedium(scheme.onSurface.withValues(alpha: 0.6))
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tap the + button to add a task',
              style: AppStyles.bodyMedium(scheme.onSurface.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }
}
