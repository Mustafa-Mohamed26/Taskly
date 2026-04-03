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
      title: 'Simplify Your Life',
      subtitle:
          'Organize your daily tasks and boost your productivity effortlessly.',
      icon: Icons.auto_awesome_outlined,
    ),
    OnboardingItem(
      title: 'Set Your Goals',
      subtitle:
          'Keep track of your long-term goals and celebrate every small win.',
      icon: Icons.track_changes_outlined,
    ),
    OnboardingItem(
      title: 'Collaborate with Ease',
      subtitle: 'Share tasks with your team and achieve milestones together.',
      icon: Icons.groups_outlined,
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              'Skip',
              style: AppStyles.labelMedium().copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
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
                return _buildPage(_items[index]);
              },
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 100.sp, color: AppColors.primary),
          ),
          SizedBox(height: 60.h),
          Text(
            item.title,
            style: AppStyles.displayLarge().copyWith(fontSize: 28.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            item.subtitle,
            style: AppStyles.bodyLarge().copyWith(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dot Indicator
          Row(
            children: List.generate(
              _items.length,
              (index) => Container(
                margin: EdgeInsets.only(right: 8.w),
                width: _currentIndex == index ? 24.w : 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color:
                      _currentIndex == index
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),

          // Next/Get Started Button
          ElevatedButton(
            onPressed: () {
              if (_currentIndex == _items.length - 1) {
                _finishOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              minimumSize: Size(
                _currentIndex == _items.length - 1 ? 160.w : 60.w,
                60.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 0,
            ),
            child:
                _currentIndex == _items.length - 1
                    ? Text('Get Started', style: AppStyles.labelLarge())
                    : const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
