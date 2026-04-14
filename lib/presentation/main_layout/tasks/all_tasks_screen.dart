import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';
import '../../../core/routes/app_routes.dart';
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
      final days = _getDaysInMonth(_currentMonth);
      final todayIndex = days.indexWhere((day) => isSameDay(day, DateTime.now()));
      if (todayIndex != -1 && _scrollController.hasClients) {
        _scrollController.jumpTo(todayIndex * (75.w + 12.w));
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
    return List.generate(daysInMonth, (i) => DateTime(month.year, month.month, i + 1));
  }

  bool isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final sortedDays = _getDaysInMonth(_currentMonth);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
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
          return AllTasksDateCard(
            date: date,
            isSelected: isSameDay(date, _selectedDate),
            onTap: () {
              setState(() {
                _selectedDate = date;
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    index * (75.w + 12.w),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
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
                    Navigator.pushNamed(context, AppRoutes.addTask, arguments: task);
                  } else if (value == 'delete') {
                    context.read<TaskCubit>().deleteTask(task);
                  }
                },
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => TaskDetailDialog(task: task),
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
}
