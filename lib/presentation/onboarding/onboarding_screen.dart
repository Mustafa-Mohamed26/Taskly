import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/service/cache_helper.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Organize Your Life',
      subtitle:
          'Stay on top of your daily goals and boost your productivity with Taskly\'s intuitive interface.',
      image: 'assets/images/onboarding_1.png',
    ),
    OnboardingItem(
      title: 'Stay on Schedule',
      subtitle:
          'Plan your days with precision and never miss a deadline again with our integrated calendar views.',
      image: 'assets/images/onboarding_2.png',
    ),
    OnboardingItem(
      title: 'Reach Your Potential',
      subtitle:
          'Track your progress, overcome obstacles, and celebrate every milestone on your journey to success. Our tools are designed to keep you focused on what matters most.',
      image: 'assets/images/onboarding_3.png',
    ),
  ];

  void _finishOnboarding() async {
    await CacheHelper.setOnboardingCompleted(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildPage(_items[index], isDark);
                },
              ),
            ),
            _buildBottomSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Taskly',
            style: AppStyles.displayMedium(
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ).copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 22.sp,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item, bool isDark) {
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
                    _buildImageSection(item, isDark),
                    const Spacer(),
                    _buildContentSection(item, isDark),
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

  Widget _buildImageSection(OnboardingItem item, bool isDark) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 380.h,
        minHeight: 250.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
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

  Widget _buildContentSection(OnboardingItem item, bool isDark) {
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

  Widget _buildBottomSection(bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        children: [
          _buildDotIndicator(isDark),
          SizedBox(height: 32.h),
          _buildNextButton(isDark),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _items.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: 8.w),
          width: _currentIndex == index ? 24.w : 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color:
                _currentIndex == index
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(bool isDark) {
    final bool isLastPage = _currentIndex == _items.length - 1;
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            _finishOnboarding();
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Text(
          isLastPage ? 'Continue' : 'Next',
          style: AppStyles.labelLarge(AppColors.white).copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

}

class OnboardingItem {
  final String title;
  final String subtitle;
  final String image;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
