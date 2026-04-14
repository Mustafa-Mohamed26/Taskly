import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/widgets/task_item_card.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import 'widgets/home_header.dart';
import 'widgets/home_summary_section.dart';
import 'widgets/home_progress_section.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/home_background_decorations.dart';
import 'package:taskly/presentation/widgets/task_detail_dialog.dart';
import 'cubit/home_cubit.dart';

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
            child: BlocListener<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state is TaskActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: scheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state is TaskError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: scheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final allTasks = state.allTasks;
                  final todayTasks = state.todayTasks;
                  final progress = state.progress;
                  final isLoading = state.isLoading;

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
                                  .copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.sp),
                            ),
                            SizedBox(height: 16.h),
                            HomeSummarySection(
                              allTasks: allTasks,
                              todayTasks: todayTasks,
                              isDark: isDark,
                            ),
                            SizedBox(height: 32.h),
                            HomeProgressSection(
                                progress: progress, isDark: isDark),
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
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.allTasks),
                                  child: Text(
                                    AppStrings.viewAll,
                                    style: AppStyles.bodyMediumMedium(
                                            scheme.primary)
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
                        child: Stack(
                          children: [
                            todayTasks.isEmpty && !isLoading
                                ? SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.w),
                                    child: HomeEmptyState(isDark: isDark),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.fromLTRB(
                                        24.w, 0, 24.w, 24.h),
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
                                                isCompleted:
                                                    !task.isCompleted)),
                                        onDelete: () => context
                                            .read<TaskCubit>()
                                            .deleteTask(task),
                                        onMenuSelected: (value) {
                                          if (value == 'edit') {
                                            Navigator.pushNamed(
                                                context, AppRoutes.addTask,
                                                arguments: task);
                                          } else if (value == 'delete') {
                                            context
                                                .read<TaskCubit>()
                                                .deleteTask(task);
                                          }
                                        },
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (_) =>
                                              TaskDetailDialog(task: task),
                                        ),
                                      );
                                    },
                                  ),
                            if (isLoading)
                              const Positioned(
                                top: 0,
                                left: 24,
                                right: 24,
                                child: LinearProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
