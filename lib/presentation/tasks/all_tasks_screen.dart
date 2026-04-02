import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 16.h),
            _buildWeeklyCalendar(),
            SizedBox(height: 24.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    _buildScheduleHeader(),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildTaskItemCard(
                            title: 'Morning Standup',
                            time: '09:00 AM',
                            description: 'Discuss project milestones with the core engineering team.',
                            tags: ['WORK', 'HIGH PRIORITY'],
                            isChecked: false,
                          ),
                          _buildTaskItemCard(
                            title: 'Gym Session',
                            time: '12:30 PM',
                            description: 'Leg day workout and 20 mins cardio.',
                            tags: ['PERSONAL'],
                            isChecked: false,
                          ),
                          _buildTaskItemCard(
                            title: 'Check Emails',
                            time: '08:00 AM',
                            description: 'Reviewing overnight client feedback.',
                            tags: ['WORK'],
                            isChecked: false,
                          ),
                          _buildTaskItemCard(
                            title: 'Product Design Review',
                            time: '03:00 PM',
                            description: 'Reviewing the new UI components for the mobile app.',
                            tags: ['WORK', 'MEETING'],
                            isChecked: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
                onPressed: () {},
              ),
              Text(
                AppStrings.monthlyYear,
                style: AppStyles.titleLarge().copyWith(fontSize: 20.sp),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCalendar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _buildDateCard('23', 'Mon', false),
          _buildDateCard('24', 'Tue', false),
          _buildDateCard('25', 'Wed', true),
          _buildDateCard('26', 'Thu', false),
          _buildDateCard('27', 'Fri', false),
        ],
      ),
    );
  }

  Widget _buildDateCard(String day, String weekday, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.fieldBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: AppStyles.bodyLargeMedium(isSelected ? AppColors.white : AppColors.textPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            weekday,
            style: AppStyles.bodySmallMedium(isSelected ? AppColors.white : AppColors.textSecondary),
          ),
          if (isSelected) ...[
            SizedBox(height: 4.h),
            Container(
              width: 4.w,
              height: 4.w,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.todaysSchedule,
          style: AppStyles.titleLarge(),
        ),
        Text(
          AppStrings.tasksLeft,
          style: AppStyles.bodyMediumMedium(AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildTaskItemCard({
    required String title,
    required String time,
    required String description,
    required List<String> tags,
    required bool isChecked,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.fieldBorder, width: 2),
                ),
                child: isChecked ? const Icon(Icons.check, size: 16, color: AppColors.primary) : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppStyles.bodyLargeMedium(),
                        ),
                        Text(
                          time,
                          style: AppStyles.bodySmallMedium(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: AppStyles.bodySmall().copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              SizedBox(width: 40.w), // Align with title
              Wrap(
                spacing: 8.w,
                children: tags.map((tag) => _buildTag(tag)).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: AppStyles.labelSmall(AppColors.primary).copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
