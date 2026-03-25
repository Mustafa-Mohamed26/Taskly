import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class ThemePreferenceScreen extends StatelessWidget {
  const ThemePreferenceScreen({super.key});

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
          AppStrings.themePreference,
          style: AppStyles.titleLarge(),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Save',
              style: AppStyles.labelMedium(AppColors.primary),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.style_outlined, 'Appearance'),
            SizedBox(height: 16.h),
            _buildAppearanceItem(
              icon: Icons.light_mode_outlined,
              title: 'Light Mode',
              subtitle: 'Classic clean white interface',
              isSelected: true,
            ),
            _buildAppearanceItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Reduced eye strain in low light',
              isSelected: false,
            ),
            _buildAppearanceItem(
              icon: Icons.settings_brightness_outlined,
              title: 'System Default',
              subtitle: 'Sync with your device settings',
              isSelected: false,
            ),
            SizedBox(height: 32.h),
            _buildSectionHeader(Icons.edit_outlined, 'Accent Color'),
            SizedBox(height: 16.h),
            _buildColorGrid(),
            SizedBox(height: 32.h),
            Text(
              'PREVIEW',
              style: AppStyles.labelSmall(AppColors.textSecondary).copyWith(letterSpacing: 1.2),
            ),
            SizedBox(height: 16.h),
            _buildPreviewCard(),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Apply Changes', style: AppStyles.labelLarge()),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'Taskly version 2.4.0 • Built with love',
                style: AppStyles.bodySmall().copyWith(fontSize: 10.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(title, style: AppStyles.titleMedium()),
      ],
    );
  }

  Widget _buildAppearanceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: isSelected ? AppColors.white : AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyLargeMedium()),
                Text(subtitle, style: AppStyles.bodySmall()),
              ],
            ),
          ),
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildColorGrid() {
    final colors = [
      AppColors.primary,
      Colors.blue,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.cyan,
      Colors.deepOrange,
      Colors.blueGrey,
      const Color(0xFF2D3142),
    ];

    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: colors.map((color) {
        final isSelected = color == AppColors.primary;
        return Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
          ),
          child: isSelected ? Icon(Icons.check, color: Colors.white, size: 20.sp) : null,
        );
      }).toList(),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.check_rounded, color: AppColors.white, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100.w, height: 8.h, decoration: BoxDecoration(color: AppColors.fieldBorder, borderRadius: BorderRadius.circular(4.r))),
                    SizedBox(height: 4.h),
                    Container(width: 60.w, height: 6.h, decoration: BoxDecoration(color: AppColors.fieldBorder.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(3.r))),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildPreviewItem(true),
          SizedBox(height: 8.h),
          _buildPreviewItem(false),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(bool isChecked) {
    return Row(
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isChecked ? AppColors.primary : AppColors.fieldBorder, width: 2),
          ),
          child: isChecked ? Center(child: Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null,
        ),
        SizedBox(width: 12.w),
        Container(width: 150.w, height: 8.h, decoration: BoxDecoration(color: AppColors.fieldBorder.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4.r))),
      ],
    );
  }
}
