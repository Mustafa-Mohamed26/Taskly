import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';

class AllTasksEmptyState extends StatelessWidget {
  const AllTasksEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 64.sp,
            color: scheme.onSurface.withValues(alpha: 0.2),
          ),
          SizedBox(height: 16.h),
          Text(
            'No tasks for this day',
            style: AppStyles.bodyLarge(scheme.onSurface.withValues(alpha: 0.5))
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
