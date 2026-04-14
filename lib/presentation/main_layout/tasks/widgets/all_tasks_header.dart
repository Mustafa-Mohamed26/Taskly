import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_styles.dart';

class AllTasksHeader extends StatelessWidget {
  const AllTasksHeader({super.key, required this.currentMonth});
  final DateTime currentMonth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: scheme.primary, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                DateFormat('MMMM yyyy').format(currentMonth),
                style: AppStyles.displayMedium(scheme.onSurface).copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search, color: scheme.onSurface, size: 26.sp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
