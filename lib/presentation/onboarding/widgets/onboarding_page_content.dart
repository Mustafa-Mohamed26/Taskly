import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';
import '../models/onboarding_item.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;
  final bool isDark;

  const OnboardingPageContent({
    super.key,
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildImageSection(context),
                    const Spacer(),
                    _buildContentSection(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 380.h,
        minHeight: 250.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Image.asset(
          item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      children: [
        Text(
          item.title,
          style: AppStyles.displayMedium(
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ).copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          item.subtitle,
          style: AppStyles.bodyLarge(
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ).copyWith(
            fontSize: 15.sp,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
