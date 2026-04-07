import 'package:flutter/material.dart';
import 'package:taskly/core/service/cache_helper.dart';
import 'package:taskly/presentation/onboarding/models/onboarding_item.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_page_content.dart';
import 'widgets/onboarding_bottom_section.dart';

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
      subtitle: 'Stay on top of your daily goals and boost your productivity with Taskly\'s intuitive interface.',
      image: 'assets/images/onboarding_1.png',
    ),
    OnboardingItem(
      title: 'Stay on Schedule',
      subtitle: 'Plan your days with precision and never miss a deadline again with our integrated calendar views.',
      image: 'assets/images/onboarding_2.png',
    ),
    OnboardingItem(
      title: 'Reach Your Potential',
      subtitle: 'Track your progress, overcome obstacles, and celebrate every milestone on your journey to success.',
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
            const OnboardingHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(
                    item: _items[index],
                    isDark: isDark,
                  );
                },
              ),
            ),
            OnboardingBottomSection(
              currentIndex: _currentIndex,
              totalItems: _items.length,
              isDark: isDark,
              onNext: _onNextPressed,
            ),
          ],
        ),
      ),
    );
  }

  void _onNextPressed() {
    if (_currentIndex == _items.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}
