import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/all_tasks_header.dart';
import 'widgets/all_tasks_date_card.dart';
import 'widgets/all_tasks_schedule_header.dart';
import 'widgets/all_tasks_empty_state.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _selectedDate = DateTime.now();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final days = _getDaysInMonth(_currentMonth);
      final todayIndex = days.indexWhere((day) => isSameDay(day, now));

      if (todayIndex != -1 && _scrollController.hasClients) {
        final double itemWidth = 75.w;
        final double itemMargin = 12.w;
        final double offset = todayIndex * (itemWidth + itemMargin);
        _scrollController.jumpTo(offset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(
      daysInMonth,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedDays = _getDaysInMonth(_currentMonth);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AllTasksHeader(currentMonth: _currentMonth),
            SizedBox(height: 16.h),
            _buildDatePicker(sortedDays),
            SizedBox(height: 24.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    AllTasksScheduleHeader(selectedDate: _selectedDate),
                    SizedBox(height: 16.h),
                    Expanded(child: _buildTaskList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildDatePicker(List<DateTime> days) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = isSameDay(date, _selectedDate);
          return AllTasksDateCard(
            date: date,
            isSelected: isSelected,
            onTap: () => _onDateSelected(date, index, days),
          );
        },
      ),
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskSuccess<List<TaskEntity>>) {
          final tasks = state.data
              .where((t) => isSameDay(t.dateTime, _selectedDate))
              .toList();
          if (tasks.isEmpty) return const AllTasksEmptyState();

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 24.h),
            physics: const BouncingScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItemCard(
                task: task,
                onToggle: () => context
                    .read<TaskCubit>()
                    .updateTask(task.copyWith(isCompleted: !task.isCompleted)),
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
          );
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
      backgroundColor: AppColors.primary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: AppColors.white),
    );
  }

  void _onDateSelected(DateTime date, int index, List<DateTime> days) {
    setState(() {
      _selectedDate = date;
      if (_scrollController.hasClients) {
        final double itemWidth = 75.w;
        final double itemMargin = 12.w;
        final double offset = index * (itemWidth + itemMargin);
        _scrollController.animateTo(offset,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
