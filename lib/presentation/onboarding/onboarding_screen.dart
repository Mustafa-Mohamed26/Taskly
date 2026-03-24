import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/routes/app_routes.dart';
import '../auth/widgets/auth_button.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<OnboardingModel> _onboardingData = [
    OnboardingModel(
      title: 'Track Your Daily Tasks',
      description: 'Experience the easiest way to manage your work and personal projects in one place.',
      icon: Icons.track_changes_rounded,
    ),
    OnboardingModel(
      title: 'Boost Productivity',
      description: 'Set priorities and deadlines to ensure your goals are met with maximum efficiency.',
      icon: Icons.rocket_launch_rounded,
    ),
    OnboardingModel(
      title: 'Stay Organized',
      description: 'Organize your tasks by categories and tags for better workflow management.',
      icon: Icons.folder_copy_rounded,
    ),
  ];

  void _nextStep() {
    if (_currentIndex < _onboardingData.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _onboardingData[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            children: [
              _buildHeader(),
              const Spacer(),
              _buildContent(currentItem),
              const Spacer(),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        },
        child: Text(
          'Skip',
          style: AppStyles.link.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(OnboardingModel item) {
    return Column(
      key: ValueKey<int>(_currentIndex), // Important for animation effect
      children: [
        Container(
          width: 240.w,
          height: 240.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              item.icon,
              size: 100.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: 60.h),
        Text(
          item.title,
          style: AppStyles.heading1.copyWith(fontSize: 28.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          item.description,
          style: AppStyles.subtitle.copyWith(fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _onboardingData.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 8.h,
              width: _currentIndex == index ? 24.w : 8.w,
              decoration: BoxDecoration(
                color: _currentIndex == index ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 48.h),
        AuthButton(
          text: _currentIndex == _onboardingData.length - 1 ? 'Get Started' : 'Next',
          onPressed: _nextStep,
        ),
      ],
    );
  }
}
