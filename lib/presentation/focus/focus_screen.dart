import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        title: Text(AppStrings.focusMode, style: AppStyles.titleLarge()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            _buildTimerSection(),
            SizedBox(height: 48.h),
            _buildCurrentTaskCard(),
            SizedBox(height: 32.h),
            _buildAmbientSoundsSection(),
            SizedBox(height: 40.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 240.w,
          height: 240.w,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 12.w,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        Column(
          children: [
            Text(
              '25:00',
              style: AppStyles.displayLarge().copyWith(fontSize: 48.sp),
            ),
            Text(
              AppStrings.pomodoro,
              style: AppStyles.bodySmallMedium(AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentTaskCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.currentTask,
                    style: AppStyles.labelSmall(AppColors.primary),
                  ),
                  SizedBox(height: 4.h),
                  Text('Design System Update', style: AppStyles.titleLarge()),
                  SizedBox(height: 4.h),
                  Text(
                    AppStrings.priorityHighPro,
                    style: AppStyles.bodySmall(AppColors.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 6.h,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.stepInfo,
                style: AppStyles.bodySmall(AppColors.textSecondary),
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    AppStrings.complete,
                    style: AppStyles.bodySmallMedium(AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientSoundsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.ambientSounds,
          style: AppStyles.labelSmall(AppColors.textSecondary),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAmbientIcon(Icons.water_drop, AppStrings.rain, true),
            _buildAmbientIcon(Icons.forest, AppStrings.forest, false),
            _buildAmbientIcon(Icons.waves, AppStrings.waves, false),
            _buildAmbientIcon(Icons.multiline_chart, AppStrings.white, false),
          ],
        ),
      ],
    );
  }

  Widget _buildAmbientIcon(IconData icon, String label, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            size: 28.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppStyles.bodySmallMedium(
            isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 64.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pause, color: AppColors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(AppStrings.pauseSession, style: AppStyles.labelLarge()),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: AppColors.background,
            minimumSize: Size(double.infinity, 64.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stop, color: AppColors.textPrimary, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                AppStrings.endSession,
                style: AppStyles.bodyLargeMedium(AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
