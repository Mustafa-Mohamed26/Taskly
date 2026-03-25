import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.newTask,
          style: AppStyles.titleLarge(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(AppStrings.taskTitle),
            _buildTextField('What needs to be done?'),
            SizedBox(height: 24.h),
            _buildFieldLabel(AppStrings.description),
            _buildTextField('Add more details about this task...', maxLines: 4),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel(AppStrings.date),
                      _buildSelectorField(Icons.calendar_today, 'Oct 24, 2023'),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel(AppStrings.time),
                      _buildSelectorField(Icons.access_time, '10:00 AM'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildFieldLabel(AppStrings.category),
            Row(
              children: [
                _buildCategoryChip('Work', Icons.work, true),
                SizedBox(width: 8.w),
                _buildCategoryChip('Personal', Icons.person, false),
                SizedBox(width: 8.w),
                _buildCategoryChip('Health', Icons.favorite, false),
              ],
            ),
            SizedBox(height: 24.h),
            _buildFieldLabel(AppStrings.priority),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriorityButton('Low', AppColors.priorityLow, false),
                _buildPriorityButton('Medium', AppColors.priorityMedium, true),
                _buildPriorityButton('High', AppColors.priorityHigh, false),
              ],
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_task, color: AppColors.white),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.createTask,
                    style: AppStyles.labelLarge(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: AppStyles.labelSmall().copyWith(letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.bodyMedium(AppColors.fieldHint),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
      ),
    );
  }

  Widget _buildSelectorField(IconData icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(value, style: AppStyles.bodyMediumMedium(AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? AppColors.white : AppColors.textSecondary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppStyles.bodyMediumMedium(isSelected ? AppColors.white : AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityButton(String label, Color color, bool isSelected) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : AppColors.white,
        border: Border.all(color: isSelected ? color : AppColors.fieldBorder, width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppStyles.bodyMediumMedium(isSelected ? AppColors.textPrimary : AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
