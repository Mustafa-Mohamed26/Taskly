import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class AllTasksHeader extends StatelessWidget {
  final DateTime currentMonth;

  const AllTasksHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                DateFormat('MMMM yyyy').format(currentMonth),
                style: AppStyles.displayMedium(AppColors.textPrimary).copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.textPrimary,
              size: 26.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
