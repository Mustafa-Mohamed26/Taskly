import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';

class TaskDetailDialog extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.fieldFillDark : AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.calendar_today_rounded,
                      'Date',
                      DateFormat('EEEE, MMM dd, yyyy').format(task.dateTime),
                      isDark,
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRow(
                      Icons.access_time_rounded,
                      'Time',
                      DateFormat('hh:mm a').format(task.dateTime),
                      isDark,
                    ),
                    SizedBox(height: 24.h),
                    _buildCategories(isDark),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Text(
                        'Description',
                        style: AppStyles.bodyLargeMedium(
                          isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.background.withValues(alpha: 0.3)
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          task.description!,
                          style: AppStyles.bodyMedium(
                            isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ).copyWith(height: 1.5, fontSize: 15.sp),
                        ),
                      ),
                    ],
                    SizedBox(height: 32.h),
                    _buildCloseButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    Color priorityColor = Colors.orange;
    if (task.priority.toUpperCase() == 'HIGH') priorityColor = Colors.red;
    if (task.priority.toUpperCase() == 'LOW') priorityColor = Colors.blue;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: priorityColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${task.priority.toUpperCase()} PRIORITY',
                  style: AppStyles.bodySmallMedium(priorityColor).copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 11.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                task.isCompleted ? Icons.check_circle_rounded : Icons.pending_rounded,
                color: task.isCompleted ? Colors.green : Colors.orange,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            task.title,
            style: AppStyles.titleLarge(
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w900, fontSize: 24.sp, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.bodySmall(
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: AppStyles.bodyMedium(
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategories(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppStyles.bodyLargeMedium(
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ).copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: task.categories.map((category) {
            Color bgColor = const Color(0xFFE0E7FF);
            Color textColor = const Color(0xFF4F46E5);
            if (category.toUpperCase() == 'PERSONAL') {
              bgColor = const Color(0xFFDCFCE7);
              textColor = const Color(0xFF166534);
            } else if (category.toUpperCase() == 'HEALTH') {
              bgColor = const Color(0xFFFCE7F3);
              textColor = const Color(0xFF9D174D);
            } else if (category.toUpperCase() == 'SHOPPING') {
              bgColor = const Color(0xFFFEF9C3);
              textColor = const Color(0xFF854D0E);
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10.r)),
              child: Text(
                category.toUpperCase(),
                style: AppStyles.bodySmallMedium(textColor).copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          elevation: 0,
        ),
        child: Text(
          'Close',
          style: AppStyles.bodyLargeMedium(AppColors.white).copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
