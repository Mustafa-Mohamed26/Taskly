import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../auth/cubit/auth_cubit.dart';

class HomeHeader extends StatelessWidget {
  final bool isDark;

  const HomeHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final hour = DateTime.now().hour;
        String greeting = 'Good Morning';
        if (hour >= 12 && hour < 17) {
          greeting = 'Good Afternoon';
        } else if (hour >= 17) {
          greeting = 'Good Evening';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppStyles.displayMedium(
                    isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ).copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()),
                  style: AppStyles.bodyMedium(
                    isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                    size: 26.sp,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                    size: 26.sp,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
