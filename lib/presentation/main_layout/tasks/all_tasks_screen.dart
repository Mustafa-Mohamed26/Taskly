import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    final authState = context.read<AuthCubit>().state;
    String userId = '';
    if (authState is Authenticated) {
      userId = authState.user.id;
    } else if (authState is LoginSuccess) {
      userId = authState.user.id;
    } else if (authState is RegisterSuccess) {
      userId = authState.user.id;
    }

    if (userId.isNotEmpty) {
      context.read<TaskCubit>().watchTasks(userId);
    }
  }

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
                      child: BlocBuilder<TaskCubit, TaskState>(
                        builder: (context, state) {
                          if (state is TaskLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is TaskSuccess<List<TaskEntity>>) {
                            final tasks = state.data;
                            if (tasks.isEmpty) {
                              return Center(
                                child: Text(
                                  'No tasks for today',
                                  style: AppStyles.bodyLarge(),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return _buildTaskItemCard(task);
                              },
                            );
                          } else if (state is TaskError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox.shrink();
                        },
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
                DateFormat('MMMM yyyy').format(DateTime.now()),
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
    // Current simplified week view
    final now = DateTime.now();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: List.generate(7, (index) {
          final date = now.add(Duration(days: index - now.weekday + 1));
          final isSelected = date.day == now.day;
          return _buildDateCard(
            date.day.toString(),
            DateFormat('E').format(date),
            isSelected,
          );
        }),
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
        ],
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.todaysSchedule, style: AppStyles.titleLarge()),
        BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskSuccess<List<TaskEntity>>) {
              final count = state.data.where((t) => !t.isCompleted).length;
              return Text(
                '$count tasks left',
                style: AppStyles.bodyMediumMedium(AppColors.primary),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildTaskItemCard(TaskEntity task) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<TaskCubit>().deleteTask(task.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
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
                GestureDetector(
                  onTap: () => context.read<TaskCubit>().updateTask(
                        task.copyWith(isCompleted: !task.isCompleted),
                      ),
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    margin: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: task.isCompleted ? AppColors.primary : AppColors.fieldBorder,
                        width: 2,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check, size: 16, color: AppColors.white)
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: AppStyles.bodyLargeMedium().copyWith(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(task.dateTime),
                            style: AppStyles.bodySmallMedium(),
                          ),
                        ],
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Text(
                          task.description!,
                          style: AppStyles.bodySmall().copyWith(height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                SizedBox(width: 40.w),
                _buildTag(task.category.toUpperCase()),
                SizedBox(width: 8.w),
                _buildTag(task.priority.toUpperCase()),
                if (!task.isSynced) ...[
                  const Spacer(),
                  const Icon(Icons.sync_problem, size: 16, color: Colors.orange),
                ],
              ],
            ),
          ],
        ),
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
