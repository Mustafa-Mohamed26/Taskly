import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../../../domain/entities/task_entity.dart';
import 'widgets/home_header.dart';
import 'widgets/home_summary_section.dart';
import 'widgets/home_progress_section.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/home_background_decorations.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          HomeBackgroundDecorations(isDark: isDark),
          SafeArea(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                List<TaskEntity> allTasks = [];
                if (state is TaskSuccess<List<TaskEntity>>) {
                  allTasks = state.data;
                }

                final now = DateTime.now();
                final todayTasks = allTasks.where((task) =>
                    task.dateTime.year == now.year &&
                    task.dateTime.month == now.month &&
                    task.dateTime.day == now.day).toList();

                final completedToday = todayTasks.where((t) => t.isCompleted).length;
                final totalToday = todayTasks.length;
                final progress = totalToday > 0 ? completedToday / totalToday : 0.0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(isDark: isDark),
                          SizedBox(height: 32.h),
                          Text(
                            'Summary',
                            style: AppStyles.titleLarge(scheme.onSurface)
                                .copyWith(fontWeight: FontWeight.w900, fontSize: 18.sp),
                          ),
                          SizedBox(height: 16.h),
                          HomeSummarySection(
                            allTasks: allTasks,
                            todayTasks: todayTasks,
                            isDark: isDark,
                          ),
                          SizedBox(height: 32.h),
                          HomeProgressSection(progress: progress, isDark: isDark),
                          SizedBox(height: 32.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.todaysTasks,
                                style: AppStyles.titleLarge(scheme.onSurface)
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, AppRoutes.allTasks),
                                child: Text(
                                  AppStrings.viewAll,
                                  style: AppStyles.bodyMediumMedium(scheme.primary)
                                      .copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                    Expanded(
                      child: todayTasks.isEmpty
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: HomeEmptyState(isDark: isDark),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                              physics: const BouncingScrollPhysics(),
                              itemCount: todayTasks.length,
                              itemBuilder: (context, index) {
                                final task = todayTasks[index];
                                return TaskItemCard(
                                  task: task,
                                  showDescription: false,
                                  showTags: false,
                                  onToggle: () => context
                                      .read<TaskCubit>()
                                      .updateTask(task.copyWith(
                                          isCompleted: !task.isCompleted)),
                                  onDelete: () =>
                                      context.read<TaskCubit>().deleteTask(task),
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
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
