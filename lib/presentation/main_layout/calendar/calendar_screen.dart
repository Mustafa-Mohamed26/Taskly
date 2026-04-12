import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.animation?.value == _tabController.index) {
        setState(() {
          if (_tabController.index == 0) {
            _focusedDay = DateTime.now();
            _selectedDay = _focusedDay;
          } else if (_tabController.index == 1) {
            _calendarFormat = CalendarFormat.week;
          } else {
            _calendarFormat = CalendarFormat.month;
          }
        });
      }
    });
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        List<TaskEntity> allTasks = [];
        if (state is TaskSuccess<List<TaskEntity>>) {
          allTasks = state.data;
        }

        final selectedTasks = allTasks
            .where((task) => isSameDay(task.dateTime, _selectedDay))
            .toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
          appBar: _buildAppBar(context, isDark),
          body: Column(
            children: [
              _buildTabRow(isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (_tabController.index != 0)
                        _buildCalendarSection(allTasks, isDark),
                      _buildTasksSection(selectedTasks, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
      elevation: 0,
      title: Text(
        AppStrings.calendar,
        style: AppStyles.titleLarge(
                isDark ? AppColors.white : AppColors.textPrimary)
            .copyWith(fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search,
              color: isDark ? AppColors.white : AppColors.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert,
              color: isDark ? AppColors.white : AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabRow(bool isDark) {
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppStyles.bodyLargeMedium().copyWith(fontWeight: FontWeight.w800),
        tabs: const [
          Tab(text: AppStrings.day),
          Tab(text: AppStrings.week),
          Tab(text: AppStrings.month),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(List<TaskEntity> allTasks, bool isDark) {
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.white,
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                    });
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: AppStyles.titleMedium(
                          isDark ? AppColors.white : AppColors.textPrimary)
                      .copyWith(fontWeight: FontWeight.w900, fontSize: 18.sp),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                    });
                  },
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: AppStyles.bodyMedium(
                  isDark ? AppColors.white : AppColors.textPrimary),
              weekendTextStyle: AppStyles.bodyMedium(
                  isDark ? AppColors.white : AppColors.textPrimary),
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppStyles.bodySmallMedium(AppColors.primary)
                  .copyWith(fontWeight: FontWeight.w800),
              weekendStyle: AppStyles.bodySmallMedium(AppColors.primary)
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            eventLoader: (day) {
              return allTasks
                  .where((task) => isSameDay(task.dateTime, day))
                  .toList();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 4,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(List<TaskEntity> selectedTasks, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSameDay(_selectedDay, DateTime.now())
                    ? AppStrings.todaysTasks
                    : "Day's Tasks",
                style: AppStyles.titleMedium(
                        isDark ? AppColors.white : AppColors.textPrimary)
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              if (selectedTasks.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${selectedTasks.length} Tasks',
                    style: AppStyles.bodySmallMedium(AppColors.primary)
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          if (selectedTasks.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Text(
                  'No tasks for this day',
                  style: AppStyles.bodyLarge(AppColors.textSecondary),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                final task = selectedTasks[index];
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
        ],
      ),
    );
  }
}

