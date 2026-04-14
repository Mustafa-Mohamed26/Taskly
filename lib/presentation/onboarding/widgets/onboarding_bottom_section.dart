import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/theme/app_colors.dart';
import '../../../../presentation/widgets/app_button.dart';

class OnboardingBottomSection extends StatelessWidget {
  final int currentIndex;
  final int totalItems;
  final bool isDark;
  final VoidCallback onNext;

  const OnboardingBottomSection({
    super.key,
    required this.currentIndex,
    required this.totalItems,
    required this.isDark,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        children: [
          _buildDotIndicator(context),
          SizedBox(height: 32.h),
          AppButton(
            text: currentIndex == totalItems - 1 ? 'Continue' : 'Next',
            onPressed: onNext,
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalItems,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: 8.w),
          width: currentIndex == index ? 24.w : 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ),
    );
  }
}
