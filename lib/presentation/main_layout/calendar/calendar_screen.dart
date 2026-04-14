import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/main_layout/calendar/cubit/calendar_view_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_styles.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final cubit = context.read<CalendarViewCubit>();
        if (_tabController.index == 0) {
          cubit.onDaySelected(DateTime.now(), DateTime.now());
        } else if (_tabController.index == 1) {
          cubit.onFormatChanged(CalendarFormat.week);
        } else {
          cubit.onFormatChanged(CalendarFormat.month);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg =
        Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;

    return BlocBuilder<CalendarViewCubit, CalendarViewState>(
      builder: (context, state) {
        final selectedTasks = state.selectedDayTasks;
        final isLoading = state.isLoading;

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: scaffoldBg,
            elevation: 0,
            title: Text(
              AppStrings.calendar,
              style: AppStyles.titleLarge(scheme.onSurface).copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
            bottom: isLoading
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: LinearProgressIndicator(),
                  )
                : null,
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: scheme.onSurface),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: scheme.onSurface),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                color: cardBg,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: scheme.primary,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: scheme.primary,
                  unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.5),
                  labelStyle: AppStyles.bodyLargeMedium().copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  tabs: const [
                    Tab(text: AppStrings.day),
                    Tab(text: AppStrings.week),
                    Tab(text: AppStrings.month),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (_tabController.index != 0)
                        _buildCalendarSection(state, cardBg, scheme),
                      _buildTasksSection(selectedTasks, scheme, state.selectedDay),
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

  Widget _buildCalendarSection(
    CalendarViewState state,
    Color cardBg,
    ColorScheme scheme,
  ) {
    final cubit = context.read<CalendarViewCubit>();
    
    return Container(
      color: cardBg,
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
                  onPressed: () => cubit.changeFocusedDay(
                    DateTime(state.focusedDay.year, state.focusedDay.month - 1),
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(state.focusedDay),
                  style: AppStyles.titleMedium(scheme.onSurface).copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 18.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => cubit.changeFocusedDay(
                    DateTime(state.focusedDay.year, state.focusedDay.month + 1),
                  ),
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: state.focusedDay,
            calendarFormat: state.calendarFormat,
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
            onDaySelected: cubit.onDaySelected,
            onFormatChanged: cubit.onFormatChanged,
            onPageChanged: cubit.changeFocusedDay,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: AppStyles.bodyMedium(scheme.onSurface),
              weekendTextStyle: AppStyles.bodyMedium(scheme.onSurface),
              selectedDecoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              todayDecoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppStyles.bodySmallMedium(scheme.primary)
                  .copyWith(fontWeight: FontWeight.w800),
              weekendStyle: AppStyles.bodySmallMedium(scheme.primary)
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            eventLoader: (day) => state.allTasks
                .where((task) => isSameDay(task.dateTime, day))
                .toList(),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 4,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: scheme.primary,
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

  Widget _buildTasksSection(
    List<TaskEntity> selectedTasks,
    ColorScheme scheme,
    DateTime selectedDay,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSameDay(selectedDay, DateTime.now())
                    ? AppStrings.todaysTasks
                    : "Day's Tasks",
                style: AppStyles.titleMedium(scheme.onSurface).copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (selectedTasks.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${selectedTasks.length} Tasks',
                    style: AppStyles.bodySmallMedium(scheme.primary).copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
                  style: AppStyles.bodyLarge(
                    scheme.onSurface.withValues(alpha: 0.5),
                  ),
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
                        task.copyWith(isCompleted: !task.isCompleted),
                      ),
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
                    builder: (_) => TaskDetailDialog(task: task),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
