import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../../domain/entities/task_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<TaskCubit>().getTasks(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildBackgroundDecorations(isDark),
          SafeArea(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                List<TaskEntity> allTasks = [];
                if (state is TaskSuccess<List<TaskEntity>>) {
                  allTasks = state.data;
                }

                final todayTasks =
                    allTasks.where((task) {
                      final now = DateTime.now();
                      return task.dateTime.year == now.year &&
                          task.dateTime.month == now.month &&
                          task.dateTime.day == now.day;
                    }).toList();

                final completedToday =
                    todayTasks.where((t) => t.isCompleted).length;
                final totalToday = todayTasks.length;
                final progress = totalToday > 0 ? completedToday / totalToday : 0.0;

                return RefreshIndicator(
                  onRefresh: () async => _loadTasks(),
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(isDark),
                        SizedBox(height: 32.h),
                        _buildSummarySection(allTasks, todayTasks, isDark),
                        SizedBox(height: 32.h),
                        _buildProgressSection(progress, isDark),
                        SizedBox(height: 32.h),
                        _buildTasksSection(context, todayTasks, isDark),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'User';
        if (state is Authenticated) {
          name = state.user.name?.split(' ').first ?? 'User';
        }

        final hour = DateTime.now().hour;
        String greeting = 'Good Morning';
        if (hour >= 12 && hour < 17) {
          greeting = 'Good Afternoon';
        } else if (hour >= 17) {
          greeting = 'Good Evening';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $name',
                  style: AppStyles.displayMedium(
                    isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ).copyWith(fontSize: 24.sp, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()),
                  style: AppStyles.bodyMedium(
                    isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.fieldFillDark : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
                onPressed: () {},
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummarySection(
    List<TaskEntity> allTasks,
    List<TaskEntity> todayTasks,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: AppStrings.today,
            count: '${todayTasks.length} Tasks',
            color: AppColors.primary,
            textColor: AppColors.white,
            icon: Icons.today_rounded,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'This Month',
            count: '${allTasks.length} Total',
            color: isDark ? AppColors.fieldFillDark : AppColors.white,
            textColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            icon: Icons.calendar_month_rounded,
            isDark: isDark,
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
    required IconData icon,
    bool isDark = false,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (!isDark && color == AppColors.primary)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          if (!isDark && color == AppColors.white)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: textColor, size: 22.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppStyles.bodySmall(
              textColor.withValues(alpha: 0.8),
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          Text(
            count,
            style: AppStyles.headlineMedium(
              textColor,
            ).copyWith(fontWeight: FontWeight.w900, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(double progress, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.fieldFillDark : AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.dailyProgress,
                style: AppStyles.titleMedium(
                  isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppStyles.titleMedium(
                  AppColors.primary,
                ).copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            progress == 1.0
                ? "Perfect! All tasks completed."
                : "You're doing great! Keep it up.",
            style: AppStyles.bodySmall(
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(
    BuildContext context,
    List<TaskEntity> todayTasks,
    bool isDark,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.todaysTasks,
              style: AppStyles.titleLarge(
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w900),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.allTasks),
              child: Text(
                AppStrings.viewAll,
                style: AppStyles.bodyMediumMedium(
                  AppColors.primary,
                ).copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (todayTasks.isEmpty)
          _buildEmptyState(isDark)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todayTasks.length,
            itemBuilder: (context, index) {
              return _buildTaskItem(todayTasks[index], isDark);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 60.sp,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          SizedBox(height: 16.h),
          Text(
            "No tasks for today",
            style: AppStyles.bodyLarge(
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskEntity task, bool isDark) {
    Color priorityColor;
    switch (task.priority.toUpperCase()) {
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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.fieldFillDark : AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<TaskCubit>().updateTask(
                task.copyWith(isCompleted: !task.isCompleted),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.primary : AppColors.transparent,
                border: Border.all(
                  color: task.isCompleted ? AppColors.primary : AppColors.fieldBorder,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child:
                  task.isCompleted
                      ? const Icon(Icons.check, color: AppColors.white, size: 18)
                      : null,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppStyles.bodyLargeMedium(
                    task.isCompleted
                        ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                  ).copyWith(
                    fontWeight: FontWeight.w700,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      task.priority,
                      style: AppStyles.bodySmall(
                        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat('hh:mm a').format(task.dateTime),
                      style: AppStyles.bodySmall(
                        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              size: 22.sp,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushNamed(
                  context,
                  AppRoutes.addTask,
                  arguments: task,
                );
              } else if (value == 'delete') {
                context.read<TaskCubit>().deleteTask(task);
              }

            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations(bool isDark) {
    final color = AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.02);
    return Stack(
      children: [
        Positioned(
          top: -100.h,
          right: -50.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
        Positioned(
          bottom: 200.h,
          left: -80.w,
          child: Container(
            width: 250.w,
            height: 250.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
