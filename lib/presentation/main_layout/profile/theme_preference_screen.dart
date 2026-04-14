import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/cubit/theme_cubit.dart';

class ThemePreferenceScreen extends StatelessWidget {
  const ThemePreferenceScreen({super.key});

  // Palette shown in the UI (first entry is the default)
  static const List<Color> _accentColors = [
    Color(0xFF2211D1), // default indigo
    Colors.blue,
    Colors.teal,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.cyan,
    Colors.deepOrange,
    Colors.blueGrey,
    Color(0xFF2D3142),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final scheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: scheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppStrings.themePreference,
              style: AppStyles.titleLarge(scheme.onSurface),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Done', style: AppStyles.labelMedium(scheme.primary)),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, icon: Icons.style_outlined, title: 'Appearance'),
                SizedBox(height: 16.h),
                _buildAppearanceTile(
                  context,
                  icon: Icons.light_mode_outlined,
                  title: 'Light Mode',
                  subtitle: 'Classic clean white interface',
                  themeMode: ThemeMode.light,
                  currentMode: themeState.mode,
                ),
                _buildAppearanceTile(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Reduced eye strain in low light',
                  themeMode: ThemeMode.dark,
                  currentMode: themeState.mode,
                ),
                _buildAppearanceTile(
                  context,
                  icon: Icons.settings_brightness_outlined,
                  title: 'System Default',
                  subtitle: 'Sync with your device settings',
                  themeMode: ThemeMode.system,
                  currentMode: themeState.mode,
                ),
                SizedBox(height: 32.h),
                _buildSectionHeader(context, icon: Icons.edit_outlined, title: 'Accent Color'),
                SizedBox(height: 16.h),
                _buildAccentColorGrid(
                  context,
                  colors: _accentColors,
                  selectedColor: themeState.accentColor,
                ),
                SizedBox(height: 32.h),
                Text(
                  'PREVIEW',
                  style: AppStyles.labelSmall(
                    scheme.onSurface.withValues(alpha: 0.6),
                  ).copyWith(letterSpacing: 1.2),
                ),
                SizedBox(height: 16.h),
                _buildPreviewCard(context, isDark: isDark),
                SizedBox(height: 40.h),
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
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

Widget _buildSectionHeader(BuildContext context, {required IconData icon, required String title}) {
  return Row(
    children: [
      Icon(icon, size: 20.sp, color: Theme.of(context).colorScheme.primary),
      SizedBox(width: 8.w),
      Text(
        title,
        style: AppStyles.titleMedium(Theme.of(context).colorScheme.onSurface),
      ),
    ],
  );
}

Widget _buildAppearanceTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required ThemeMode themeMode,
  required ThemeMode currentMode,
}) {
  final isSelected = themeMode == currentMode;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final itemBg = isDark ? const Color(0xFF1C1F37) : AppColors.white;
  final scheme = Theme.of(context).colorScheme;

  return GestureDetector(
    onTap: () => context.read<ThemeCubit>().changeTheme(themeMode),
    child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? scheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? scheme.primary
                  : scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.white : scheme.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyLargeMedium(scheme.onSurface)),
                Text(
                  subtitle,
                  style: AppStyles.bodySmall(
                    scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Radio<ThemeMode>(
            value: themeMode,
            groupValue: currentMode,
            onChanged: (_) =>
                context.read<ThemeCubit>().changeTheme(themeMode),
            activeColor: scheme.primary,
          ),
        ],
      ),
    ),
  );
}

Widget _buildAccentColorGrid(
  BuildContext context, {
  required List<Color> colors,
  required Color selectedColor,
}) {
  return Wrap(
    spacing: 16.w,
    runSpacing: 16.h,
    children: colors.map((color) {
      final isSelected = color.toARGB32() == selectedColor.toARGB32();
      return GestureDetector(
        onTap: () => context.read<ThemeCubit>().changeAccentColor(color),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: AppColors.white, width: 3)
                : null,
            boxShadow: isSelected
                ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)]
                : null,
          ),
          child: isSelected
              ? Icon(Icons.check, color: Colors.white, size: 20.sp)
              : null,
        ),
      );
    }).toList(),
  );
}

Widget _buildPreviewCard(BuildContext context, {required bool isDark}) {
  final scheme = Theme.of(context).colorScheme;
  final itemBg = isDark ? const Color(0xFF1C1F37) : AppColors.white;
  final borderColor = isDark
      ? const Color(0xFF2A2A3A)
      : AppColors.fieldBorder.withValues(alpha: 0.5);

  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: itemBg,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonLine(context, width: 100.w, height: 8.h, color: borderColor),
                  SizedBox(height: 4.h),
                  _buildSkeletonLine(context, width: 60.w, height: 6.h, color: borderColor),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildPreviewRow(context, isChecked: true, borderColor: borderColor, primary: scheme.primary),
        SizedBox(height: 8.h),
        _buildPreviewRow(context, isChecked: false, borderColor: borderColor, primary: scheme.primary),
      ],
    ),
  );
}

Widget _buildSkeletonLine(
  BuildContext context, {
  required double width,
  required double height,
  required Color color,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4.r),
    ),
  );
}

Widget _buildPreviewRow(
  BuildContext context, {
  required bool isChecked,
  required Color borderColor,
  required Color primary,
}) {
  return Row(
    children: [
      Container(
        width: 18.w,
        height: 18.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isChecked ? primary : borderColor,
            width: 2,
          ),
        ),
        child: isChecked
            ? Center(
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
      SizedBox(width: 12.w),
      Container(
        width: 150.w,
        height: 8.h,
        decoration: BoxDecoration(
          color: borderColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    ],
  );
}
