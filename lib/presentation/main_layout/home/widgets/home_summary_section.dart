import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../domain/entities/task_entity.dart';
import 'home_summary_card.dart';

class HomeSummarySection extends StatelessWidget {
  const HomeSummarySection({
    super.key,
    required this.allTasks,
    required this.todayTasks,
    required this.isDark,
  });

  final List<TaskEntity> allTasks;
  final List<TaskEntity> todayTasks;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    final weekTasks = allTasks.where((task) {
      return task.dateTime.isAfter(
              firstDayOfWeek.subtract(const Duration(seconds: 1))) &&
          task.dateTime
              .isBefore(lastDayOfWeek.add(const Duration(seconds: 1)));
    }).length;

    final cardBg = Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;

    return Row(
      children: [
        Expanded(
          child: HomeSummaryCard(
            title: AppStrings.today,
            count: '${todayTasks.length} Tasks',
            color: scheme.primary,
            textColor: scheme.onPrimary,
            icon: Icons.today_rounded,
            hasDecoration: true,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: HomeSummaryCard(
            title: 'This Week',
            count: '$weekTasks Tasks',
            color: cardBg,
            textColor: scheme.onSurface,
            icon: Icons.calendar_month_rounded,
            isDark: isDark,
            hasDecoration: true,
          ),
        ),
      ],
    );
  }
}
