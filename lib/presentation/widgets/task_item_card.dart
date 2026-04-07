import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class TaskItemCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onMenuSelected;
  final VoidCallback? onTap;
  final bool showDescription;
  final bool showTime;
  final bool showTags;

  const TaskItemCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onMenuSelected,
    this.onTap,
    this.showDescription = true,
    this.showTime = true,
    this.showTags = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.fieldFillDark : (isCompleted ? const Color(0xFFF8FAFC) : AppColors.white),
          borderRadius: BorderRadius.circular(16.r),
          border: isCompleted
              ? Border.all(
                  color: AppColors.fieldBorder.withValues(alpha: 0.3),
                  style: BorderStyle.solid)
              : null,
          boxShadow: isCompleted
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckbox(),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow(context),
                      if (showDescription && task.description != null && task.description!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        _buildDescription(),
                      ],
                      if (showTags) ...[
                        SizedBox(height: 16.h),
                        _buildTags(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          color: task.isCompleted ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: task.isCompleted ? AppColors.primary : AppColors.fieldBorder,
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, size: 16, color: AppColors.white)
            : null,
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            task.title,
            style: AppStyles.bodyLargeMedium().copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
        ),
        Row(
          children: [
            if (showTime)
              Text(
                DateFormat('hh:mm a').format(task.dateTime),
                style: AppStyles.bodyMedium(
                  task.isCompleted
                      ? AppColors.textSecondary.withValues(alpha: 0.5)
                      : AppColors.textSecondary,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: task.isCompleted
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : AppColors.textSecondary,
                size: 30.sp,
              ),
              onSelected: onMenuSelected,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description!,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppStyles.bodyMedium(
        task.isCompleted
            ? AppColors.textSecondary.withValues(alpha: 0.5)
            : AppColors.textSecondary,
      ).copyWith(height: 1.4),
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...task.categories.map((category) {
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

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _buildTag(category.toUpperCase(), bgColor, textColor),
            );
          }),
          if (task.priority.toUpperCase() == 'HIGH')
            _buildTag(
              'HIGH PRIORITY',
              const Color(0xFFF1F5F9),
              const Color(0xFF64748B),
            ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: AppStyles.bodySmallMedium(textColor).copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
