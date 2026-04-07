import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../domain/entities/task_entity.dart';
import '../cubit/task_cubit.dart';

class AllTasksScheduleHeader extends StatelessWidget {
  final DateTime selectedDate;

  const AllTasksScheduleHeader({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Today\'s Schedule',
          style: AppStyles.titleLarge(AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
            letterSpacing: -0.5,
          ),
        ),
        BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskSuccess<List<TaskEntity>>) {
              final tasks = state.data
                  .where((t) =>
                      isSameDay(t.dateTime, selectedDate) && !t.isCompleted)
                  .length;
              return Text(
                '$tasks tasks left',
                style: AppStyles.bodyLargeMedium(AppColors.primary).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
