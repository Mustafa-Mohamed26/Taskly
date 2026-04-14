import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF0E1120) : Colors.white;
    final dividerColor = scheme.onSurface.withValues(alpha: 0.1);

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.all(24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Task',
                  style: AppStyles.titleLarge(scheme.onSurface)
                      .copyWith(fontWeight: FontWeight.w900),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: scheme.onSurface.withValues(alpha: 0.5),
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
                            task.title
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()) &&
                            !task.isCompleted)
                        .toList();

                    if (filteredTasks.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        child: Center(
                          child: Text(
                            'No tasks found',
                            style: AppStyles.bodyMedium(
                              scheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredTasks.length,
                      separatorBuilder: (_, __) => Divider(color: dividerColor),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            task.title,
                            style: AppStyles.bodyLargeMedium(scheme.onSurface)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${task.priority} Priority',
                            style: AppStyles.bodySmall(
                              scheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          onTap: () => Navigator.pop(context, task),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(color: scheme.primary),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
