import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is AuthSuccess<String>) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Email Sent',
            desc: state.data,
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Error',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Forgot Password',
                style: AppStyles.titleSmall().copyWith(fontSize: 18.sp),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 48.h),
                    _buildForm(),
                    SizedBox(height: 40.h),
                    AuthButton(
                      text: 'Send Instructions',
                      onPressed: () {
                        if (_emailController.text.isNotEmpty) {
                          context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.bottomSlide,
                            title: 'Validation',
                            desc: 'Please enter your email',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
                    ),
                    SizedBox(height: 40.h),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const AuthLoadingWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.lock_open_outlined,
            color: AppColors.primary,
            size: 32.sp,
          ),
        ),
        SizedBox(height: 32.h),
        Text(
          'Reset Your Password',
          style: AppStyles.displayLarge(),
        ),
        SizedBox(height: 12.h),
        Text(
          'Enter the email associated with your account and we\'ll send you instructions to reset your password.',
          style: AppStyles.bodyLarge(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return AuthTextField(
      label: 'Email Address',
      hint: 'name@company.com',
      controller: _emailController,
      prefixIcon: Icons.email_outlined,
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          "Suddenly remember your password?",
          style: AppStyles.bodyMedium(),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Back to login',
            style: AppStyles.labelMedium(),
          ),
        ),
      ],
    );
  }
}
