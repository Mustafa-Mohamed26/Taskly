import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/schedule_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';
import '../../../core/routes/app_routes.dart';
import 'widgets/all_tasks_header.dart';
import 'widgets/all_tasks_date_card.dart';
import 'widgets/all_tasks_schedule_header.dart';
import 'widgets/all_tasks_empty_state.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final currentMonth =
            DateTime(state.selectedDate.year, state.selectedDate.month);
        final sortedDays = _getDaysInMonth(currentMonth);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                AllTasksHeader(currentMonth: currentMonth),
                SizedBox(height: 16.h),
                _buildDatePicker(context, sortedDays, state.selectedDate),
                SizedBox(height: 24.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        AllTasksScheduleHeader(selectedDate: state.selectedDate),
                        SizedBox(height: 16.h),
                        Expanded(child: _buildTaskList(state)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            child:
                Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
          ),
        );
      },
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(
        daysInMonth, (i) => DateTime(month.year, month.month, i + 1));
  }

  bool isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDatePicker(
      BuildContext context, List<DateTime> days, DateTime selectedDate) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          return AllTasksDateCard(
            date: date,
            isSelected: isSameDay(date, selectedDate),
            onTap: () => context.read<ScheduleCubit>().selectDate(date),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(ScheduleState state) {
    final tasks = state.filteredTasks;
    final isLoading = state.isLoading;

    if (isLoading && tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tasks.isEmpty && !isLoading) return const AllTasksEmptyState();

    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(bottom: 24.h),
          physics: const BouncingScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItemCard(
              task: task,
              onToggle: () => context.read<TaskCubit>().updateTask(
                  task.copyWith(isCompleted: !task.isCompleted)),
              onDelete: () => context.read<TaskCubit>().deleteTask(task),
              onMenuSelected: (value) {
                if (value == 'edit') {
                  Navigator.pushNamed(context, AppRoutes.addTask,
                      arguments: task);
                } else if (value == 'delete') {
                  context.read<TaskCubit>().deleteTask(task);
                }
              },
              onTap: () => showDialog(
                context: context,
                builder: (context) => TaskDetailDialog(task: task),
              ),
            );
          },
        ),
        if (isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}
