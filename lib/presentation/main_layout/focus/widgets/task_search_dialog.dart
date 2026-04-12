import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../widgets/app_text_field.dart';

class TaskSearchDialog extends StatefulWidget {
  const TaskSearchDialog({super.key});

  @override
  State<TaskSearchDialog> createState() => _TaskSearchDialogState();
}

class _TaskSearchDialogState extends State<TaskSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.all(24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Task',
                  style: AppStyles.titleLarge(
                    isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ).copyWith(fontWeight: FontWeight.w900),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            AppTextField(
              label: 'Search',
              hint: 'Search tasks...',
              isDark: isDark,
              prefixIcon: Icons.search,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is TaskSuccess<List<TaskEntity>>) {
                    final filteredTasks = state.data
                        .where((task) =>
                            task.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                            !task.isCompleted)
                        .toList();

                    if (filteredTasks.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        child: Center(
                          child: Text(
                            'No tasks found',
                            style: AppStyles.bodyMedium(AppColors.textSecondary),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredTasks.length,
                      separatorBuilder: (context, index) => Divider(
                        color: isDark ? AppColors.dividerDark : AppColors.divider,
                      ),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            task.title,
                            style: AppStyles.bodyLargeMedium(
                              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${task.priority} Priority',
                            style: AppStyles.bodySmall(AppColors.textSecondary),
                          ),
                          onTap: () => Navigator.pop(context, task),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
