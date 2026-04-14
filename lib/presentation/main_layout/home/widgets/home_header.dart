import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../auth/cubit/auth_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final hour = DateTime.now().hour;
        final greeting = hour < 12
            ? 'Good Morning'
            : hour < 17
                ? 'Good Afternoon'
                : 'Good Evening';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppStyles.displayMedium(scheme.onSurface).copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()),
                  style: AppStyles.bodyMedium(
                    scheme.onSurface.withValues(alpha: 0.6),
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: scheme.onSurface, size: 26.sp),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications_none_rounded,
                      color: scheme.onSurface, size: 26.sp),
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
