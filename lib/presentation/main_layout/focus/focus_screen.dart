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
import '../../../core/theme/app_styles.dart';

class FocusScreen extends StatelessWidget {
  FocusScreen({super.key});

  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<FocusCubit, FocusState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppStrings.focusMode,
              style: AppStyles.titleLarge(scheme.onSurface).copyWith(fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                _buildTimerSection(state, scheme, isDark),
                SizedBox(height: 48.h),
                _buildCurrentTaskCard(context, state, scheme, isDark),
                SizedBox(height: 32.h),
                _buildAmbientSoundsSection(context, state, scheme, isDark),
                SizedBox(height: 40.h),
                _buildActionButtons(context, state, scheme, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerSection(FocusState state, ColorScheme scheme, bool isDark) {
    final progress = state.remainingSeconds / state.duration;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(260.w, 260.w),
            painter: CircularTimerPainter(
              progress: progress,
              color: scheme.primary,
              isDark: isDark,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(state.remainingSeconds),
                style: AppStyles.displayLarge(scheme.onSurface).copyWith(
                  fontSize: 64.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
              Text(
                AppStrings.pomodoro.toUpperCase(),
                style: AppStyles.bodySmallMedium(scheme.onSurface.withValues(alpha: 0.5))
                    .copyWith(letterSpacing: 2, fontWeight: FontWeight.w800),
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
    ColorScheme scheme,
    bool isDark,
  ) {
    final task = state.selectedTask;
    final cardBg = Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;
    final borderColor = isDark ? const Color(0xFF2A2F4F) : scheme.onSurface.withValues(alpha: 0.1);

    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, _) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: borderColor),
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
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final selected = await showDialog<TaskEntity>(
                          context: context,
                          builder: (_) => const TaskSearchDialog(),
                        );
                        if (!context.mounted) return;
                        if (selected != null) {
                          context.read<FocusCubit>().selectTask(selected);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.currentTask.toUpperCase(),
                            style: AppStyles.labelSmall(scheme.primary)
                                .copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            task?.title ?? 'No task selected',
                            style: AppStyles.titleLarge(scheme.onSurface)
                                .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
                          ),
                          if (task != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              'Priority: ${task.priority} • Taskly Pro',
                              style: AppStyles.bodySmall(scheme.onSurface.withValues(alpha: 0.5)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (task == null) {
                        final selected = await showDialog<TaskEntity>(
                          context: context,
                          builder: (_) => const TaskSearchDialog(),
                        );
                        if (!context.mounted) return;
                        if (selected != null) {
                          context.read<FocusCubit>().selectTask(selected);
                        }
                      } else {
                        _isExpanded.value = !_isExpanded.value;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        task != null
                            ? (isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.info_outline_rounded)
                            : Icons.add_rounded,
                        color: scheme.primary,
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
                        Divider(color: borderColor),
                        SizedBox(height: 8.h),
                        Text(
                          task.description ?? 'No description for this task.',
                          style: AppStyles.bodyMedium(scheme.onSurface)
                              .copyWith(fontWeight: FontWeight.w500),
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
    ColorScheme scheme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.ambientSounds.toUpperCase(),
          style: AppStyles.labelSmall(scheme.onSurface.withValues(alpha: 0.5))
              .copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAmbientIcon(context, icon: Icons.water_drop_rounded, label: AppStrings.rain, isSelected: state.selectedSound == AppStrings.rain),
            _buildAmbientIcon(context, icon: Icons.forest_rounded, label: AppStrings.forest, isSelected: state.selectedSound == AppStrings.forest),
            _buildAmbientIcon(context, icon: Icons.waves_rounded, label: AppStrings.waves, isSelected: state.selectedSound == AppStrings.waves),
            _buildAmbientIcon(context, icon: Icons.multiline_chart_rounded, label: AppStrings.white, isSelected: state.selectedSound == AppStrings.white),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FocusState state,
    ColorScheme scheme,
    bool isDark,
  ) {
    final isRunning = state.status == FocusStatus.running;
    final cardBg = Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;

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
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            minimumSize: Size(double.infinity, 64.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            elevation: 8,
            shadowColor: scheme.primary.withValues(alpha: 0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                isRunning ? AppStrings.pauseSession : 'Start Session',
                style: AppStyles.labelLarge().copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
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
            backgroundColor: cardBg,
            minimumSize: Size(double.infinity, 64.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stop_rounded, color: scheme.onSurface, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                AppStrings.endSession,
                style: AppStyles.bodyLargeMedium(scheme.onSurface).copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widget
// ---------------------------------------------------------------------------

Widget _buildAmbientIcon(
  BuildContext context, {
  required IconData icon,
  required String label,
  required bool isSelected,
}) {
  final scheme = Theme.of(context).colorScheme;
  final cardBg = Theme.of(context).inputDecorationTheme.fillColor ?? scheme.surface;

  return GestureDetector(
    onTap: () =>
        context.read<FocusCubit>().selectSound(isSelected ? null : label),
    child: Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: isSelected ? scheme.primary : cardBg,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Icon(
            icon,
            color: isSelected ? scheme.onPrimary : scheme.onSurface.withValues(alpha: 0.5),
            size: 28.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: AppStyles.bodySmallMedium(
                  isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.5))
              .copyWith(fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600),
        ),
      ],
    ),
  );
}
