import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../domain/entities/task_entity.dart';
import '../cubit/task_cubit.dart';

class AllTasksScheduleHeader extends StatelessWidget {
  const AllTasksScheduleHeader({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Today\'s Schedule',
          style: AppStyles.titleLarge(scheme.onSurface).copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
            letterSpacing: -0.5,
          ),
        ),
        BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskSuccess<List<TaskEntity>>) {
              final remaining = state.data
                  .where((t) => _isSameDay(t.dateTime, selectedDate) && !t.isCompleted)
                  .length;
              return Text(
                '$remaining tasks left',
                style: AppStyles.bodyLargeMedium(scheme.primary)
                    .copyWith(fontWeight: FontWeight.w700),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
