import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import '../../../core/theme/app_styles.dart';

class TaskItemCard extends StatelessWidget {
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

  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onMenuSelected;
  final VoidCallback? onTap;
  final bool showDescription;
  final bool showTime;
  final bool showTags;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = task.isCompleted;

    final cardBg = isDark
        ? const Color(0xFF131629)
        : isCompleted
            ? const Color(0xFFF8FAFC)
            : Colors.white;

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
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: isCompleted
              ? Border.all(
                  color: scheme.onSurface.withValues(alpha: 0.08),
                )
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
                _buildCheckbox(context, task: task, onToggle: onToggle, scheme: scheme),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow(context, task: task, onMenuSelected: onMenuSelected, showTime: showTime, scheme: scheme),
                      if (showDescription && task.description != null && task.description!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        _buildDescription(context, task: task, scheme: scheme),
                      ],
                      if (showTags) ...[
                        SizedBox(height: 16.h),
                        _buildTags(context, task: task),
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
}

Widget _buildCheckbox(
  BuildContext context, {
  required TaskEntity task,
  required VoidCallback onToggle,
  required ColorScheme scheme,
}) {
  return GestureDetector(
    onTap: onToggle,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: task.isCompleted ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: task.isCompleted ? scheme.primary : scheme.onSurface.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: task.isCompleted
          ? Icon(Icons.check, size: 16, color: scheme.onPrimary)
          : null,
    ),
  );
}

Widget _buildHeaderRow(
  BuildContext context, {
  required TaskEntity task,
  required Function(String) onMenuSelected,
  required bool showTime,
  required ColorScheme scheme,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          task.title,
          style: AppStyles.bodyLargeMedium(
            task.isCompleted ? scheme.onSurface.withValues(alpha: 0.4) : scheme.onSurface,
          ).copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
      Row(
        children: [
          if (showTime)
            Text(
              DateFormat('hh:mm a').format(task.dateTime),
              style: AppStyles.bodyMedium(
                scheme.onSurface.withValues(alpha: task.isCompleted ? 0.3 : 0.5),
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: scheme.onSurface.withValues(alpha: task.isCompleted ? 0.3 : 0.5),
              size: 30.sp,
            ),
            onSelected: onMenuSelected,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
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

Widget _buildDescription(
  BuildContext context, {
  required TaskEntity task,
  required ColorScheme scheme,
}) {
  return Text(
    task.description!,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: AppStyles.bodyMedium(
      scheme.onSurface.withValues(alpha: task.isCompleted ? 0.3 : 0.5),
    ).copyWith(height: 1.4),
  );
}

Widget _buildTags(BuildContext context, {required TaskEntity task}) {
  const categoryColors = {
    'PERSONAL': (Color(0xFFDCFCE7), Color(0xFF166534)),
    'HEALTH': (Color(0xFFFCE7F3), Color(0xFF9D174D)),
    'SHOPPING': (Color(0xFFFEF9C3), Color(0xFF854D0E)),
  };

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ...task.categories.map((category) {
          final colors = categoryColors[category.toUpperCase()] ??
              (const Color(0xFFE0E7FF), const Color(0xFF4F46E5));
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _buildTag(context, label: category.toUpperCase(), bgColor: colors.$1, textColor: colors.$2),
          );
        }),
        if (task.priority.toUpperCase() == 'HIGH')
          _buildTag(
            context,
            label: 'HIGH PRIORITY',
            bgColor: const Color(0xFFF1F5F9),
            textColor: const Color(0xFF64748B),
          ),
      ],
    ),
  );
}

Widget _buildTag(
  BuildContext context, {
  required String label,
  required Color bgColor,
  required Color textColor,
}) {
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
