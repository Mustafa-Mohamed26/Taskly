import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2, // Month is selected in the design
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          title: Text(
            AppStrings.calendar,
            style: AppStyles.titleLarge(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3.h,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppStyles.bodyMediumMedium(),
            tabs: const [
              Tab(text: AppStrings.day),
              Tab(text: AppStrings.week),
              Tab(text: AppStrings.month),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text('Day View')),
            const Center(child: Text('Week View')),
            _buildMonthView(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthSelector(),
          SizedBox(height: 24.h),
          _buildCalendarGrid(),
          SizedBox(height: 32.h),
          _buildTasksSection(),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        SizedBox(width: 16.w),
        Text(
          AppStrings.monthlyYear,
          style: AppStyles.titleLarge(),
        ),
        SizedBox(width: 16.w),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final List<String> weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays
              .map((day) => Text(
                    day,
                    style: AppStyles.bodySmallMedium(AppColors.primary),
                  ))
              .toList(),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: 31 + 4, // 31 days + offset for start day
          itemBuilder: (context, index) {
            if (index < 4) return const SizedBox(); // Offset
            final day = index - 3;
            final isSelected = day == 5;
            final hasIndicator = day == 16;

            return Center(
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: AppStyles.bodyMediumMedium(
                        isSelected ? AppColors.white : AppColors.textPrimary,
                      ),
                    ),
                    if (hasIndicator)
                      Container(
                        width: 4.w,
                        height: 4.w,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTasksSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.todaysTasks, style: AppStyles.titleLarge()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '3 Tasks',
                style: AppStyles.bodySmallMedium(AppColors.primary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildTaskCard('Morning yoga session', '07:30 AM • Health', true),
        _buildTaskCard('Team sync & design review', '09:00 AM • Work', false),
        _buildTaskCard('Pick up dry cleaning', '05:00 PM • Personal', false),
      ],
    );
  }

  Widget _buildTaskCard(String title, String subtitle, bool isDone) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isDone ? AppColors.primary : AppColors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: isDone ? AppColors.primary : AppColors.fieldBorder,
                width: 2,
              ),
            ),
            child: isDone ? Icon(Icons.check, size: 16.sp, color: AppColors.white) : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyLargeMedium(
                    isDone ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppStyles.bodySmallMedium(AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Icon(Icons.drag_indicator, color: AppColors.fieldBorder, size: 24.sp),
        ],
      ),
    );
  }
}
