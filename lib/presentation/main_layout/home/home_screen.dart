import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildSummarySection(),
              SizedBox(height: 24.h),
              _buildProgressSection(),
              SizedBox(height: 24.h),
              _buildTasksSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.goodMorning, style: AppStyles.headlineLarge()),
            Text('Monday, Oct 24', style: AppStyles.bodyMediumMedium()),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: AppStrings.today,
            count: '5 Tasks',
            color: AppColors.primary,
            textColor: AppColors.white,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildSummaryCard(
            title: AppStrings.thisWeek,
            count: '12 Tasks',
            color: AppColors.white,
            textColor: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (color != AppColors.white)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.calendar_today, color: textColor, size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(title, style: AppStyles.bodyMediumMedium(textColor)),
          SizedBox(height: 4.h),
          Text(count, style: AppStyles.headlineMedium(textColor)),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.dailyProgress, style: AppStyles.titleMedium()),
              Text('60%', style: AppStyles.titleMedium(AppColors.primary)),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 8.h,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.todaysTasks, style: AppStyles.titleLarge()),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.allTasks),
              child: Text(
                AppStrings.viewAll,
                style: AppStyles.bodyMediumMedium(AppColors.primary),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _buildTaskItem('Design System Update', 'HIGH', '09:00 AM', false),
        _buildTaskItem('Team Standup Meeting', 'MEDIUM', '10:30 AM', false),
        _buildTaskItem('Review Project Proposals', 'LOW', 'Done', true),
        _buildTaskItem('Client Presentation', 'HIGH', '02:00 PM', false),
      ],
    );
  }

  Widget _buildTaskItem(
    String title,
    String priority,
    String time,
    bool isDone,
  ) {
    Color priorityColor;
    switch (priority) {
      case 'HIGH':
        priorityColor = AppColors.priorityHigh;
        break;
      case 'MEDIUM':
        priorityColor = AppColors.priorityMedium;
        break;
      default:
        priorityColor = AppColors.priorityLow;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
              border: Border.all(
                color: isDone ? AppColors.primary : AppColors.fieldBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child:
                isDone
                    ? const Icon(Icons.check, color: AppColors.white, size: 16)
                    : null,
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
                  ).copyWith(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      priority,
                      style: AppStyles.bodySmallMedium(priorityColor),
                    ),
                    SizedBox(width: 12.w),
                    Text(time, style: AppStyles.bodySmallMedium()),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
