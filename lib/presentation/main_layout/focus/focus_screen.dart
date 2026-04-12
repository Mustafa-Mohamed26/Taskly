import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/main_layout/focus/cubit/focus_cubit.dart';
import 'package:taskly/presentation/main_layout/focus/widgets/circular_timer_painter.dart';
import 'package:taskly/presentation/main_layout/focus/widgets/task_search_dialog.dart';
import 'package:taskly/core/service/audio_service.dart';
import 'package:taskly/config/di/di.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class FocusScreen extends StatelessWidget {
  FocusScreen({super.key});

  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<FocusCubit, FocusState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppStrings.focusMode,
              style: AppStyles.titleLarge(
                isDark ? AppColors.white : AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                _buildTimerSection(context, state, isDark),
                SizedBox(height: 48.h),
                _buildCurrentTaskCard(context, state, isDark),
                SizedBox(height: 32.h),
                _buildAmbientSoundsSection(context, state, isDark),
                SizedBox(height: 40.h),
                _buildActionButtons(context, state, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerSection(
    BuildContext context,
    FocusState state,
    bool isDark,
  ) {
    double progress = state.remainingSeconds / state.duration;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(260.w, 260.w),
            painter: CircularTimerPainter(progress: progress, isDark: isDark),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(state.remainingSeconds),
                style: AppStyles.displayLarge(
                  isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ).copyWith(
                  fontSize: 64.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
              Text(
                AppStrings.pomodoro.toUpperCase(),
                style: AppStyles.bodySmallMedium(
                  AppColors.textSecondary,
                ).copyWith(letterSpacing: 2, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTaskCard(
    BuildContext context,
    FocusState state,
    bool isDark,
  ) {
    final task = state.selectedTask;

    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, child) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.fieldFillDark : AppColors.background,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder,
              width: 1,
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selectedTask = await showDialog<TaskEntity>(
                          context: context,
                          builder: (context) => const TaskSearchDialog(),
                        );
                        if (selectedTask != null) {
                          context.read<FocusCubit>().selectTask(selectedTask);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.currentTask.toUpperCase(),
                            style: AppStyles.labelSmall(AppColors.primary).copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            task?.title ?? 'No task selected',
                            style: AppStyles.titleLarge(
                              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
                          ),
                          if (task != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              'Priority: ${task.priority} • Taskly Pro',
                              style: AppStyles.bodySmall(AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (task == null) {
                        final selectedTask = await showDialog<TaskEntity>(
                          context: context,
                          builder: (context) => const TaskSearchDialog(),
                        );
                        if (selectedTask != null) {
                          context.read<FocusCubit>().selectTask(selectedTask);
                        }
                      } else {
                        _isExpanded.value = !_isExpanded.value;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        task != null
                            ? (isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.info_outline_rounded)
                            : Icons.add_rounded,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
              if (task != null)
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder),
                        SizedBox(height: 8.h),
                        Text(
                          task.description ?? "there is no description for this task",
                          style: AppStyles.bodyMedium(Colors.black).copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmbientSoundsSection(
    BuildContext context,
    FocusState state,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.ambientSounds.toUpperCase(),
          style: AppStyles.labelSmall(
            AppColors.textSecondary,
          ).copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAmbientIcon(
              context,
              Icons.water_drop_rounded,
              AppStrings.rain,
              state.selectedSound == AppStrings.rain,
            ),
            _buildAmbientIcon(
              context,
              Icons.forest_rounded,
              AppStrings.forest,
              state.selectedSound == AppStrings.forest,
            ),
            _buildAmbientIcon(
              context,
              Icons.waves_rounded,
              AppStrings.waves,
              state.selectedSound == AppStrings.waves,
            ),
            _buildAmbientIcon(
              context,
              Icons.multiline_chart_rounded,
              AppStrings.white,
              state.selectedSound == AppStrings.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmbientIcon(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap:
          () =>
              context.read<FocusCubit>().selectSound(isSelected ? null : label),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.primary
                      : (Theme.of(context).brightness == Brightness.dark
                          ? AppColors.fieldFillDark
                          : AppColors.background),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: AppStyles.bodySmallMedium(
              isSelected ? AppColors.primary : AppColors.textSecondary,
            ).copyWith(
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FocusState state,
    bool isDark,
  ) {
    final bool isRunning = state.status == FocusStatus.running;

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (isRunning) {
              context.read<FocusCubit>().pauseTimer();
              getIt<AudioService>().pauseSound();
            } else {
              context.read<FocusCubit>().startTimer();
              getIt<AudioService>().playSound(state.selectedSound);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: Size(double.infinity, 64.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                isRunning ? AppStrings.pauseSession : 'Start Session',
                style: AppStyles.labelLarge().copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {
            context.read<FocusCubit>().stopTimer();
            getIt<AudioService>().stopSound();
          },
          style: TextButton.styleFrom(
            backgroundColor:
                isDark ? AppColors.fieldFillDark : AppColors.background,
            minimumSize: Size(double.infinity, 64.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stop_rounded,
                color: isDark ? AppColors.white : AppColors.textPrimary,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                AppStrings.endSession,
                style: AppStyles.bodyLargeMedium(
                  isDark ? AppColors.white : AppColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
