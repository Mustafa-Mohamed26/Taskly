import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/core/utils/validators.dart';
import 'package:taskly/domain/entities/user_entity.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_logo.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';
import 'widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is LoginSuccess) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Login Success',
            desc: 'Welcome back, ${state.user.name ?? 'User'}!',
            btnOkOnPress: () {
              Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
            },
          ).show();
        } else if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Login Error',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 48.h),
                      _buildForm(),
                      SizedBox(height: 32.h),
                      _buildSocialLogin(),
                      SizedBox(height: 40.h),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading) const AuthLoadingWidget(),
        ],
      ),
    );
  }

  // --- Sections ---

  Widget _buildHeader() {
    return Column(
      children: [
        const AuthLogo(),
        SizedBox(height: 40.h),
        Text(
          AppStrings.welcomeBack,
          style: AppStyles.displayLarge(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.welcomeBackSubtitle,
          style: AppStyles.bodyLarge(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: AppStrings.email,
          hint: 'Enter your email',
          controller: _emailController,
          validator: (val) => Validators.validateEmail(val),
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: AppStrings.password,
          hint: 'Enter your password',
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: (val) => Validators.validatePassword(val),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.fieldHint,
              size: 20.sp,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.forgotPassword);
            },
            child: Text(
              AppStrings.forgotPassword,
              style: AppStyles.labelMedium(),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        AuthButton(
          text: AppStrings.signIn,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().login(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                AppStrings.orContinueWith,
                style: AppStyles.bodySmall(),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [

            SocialButton(
              label: 'Apple',
              onPressed: () {},
              isIconWidget: true,
              iconWidget: Icon(Icons.apple, color: AppColors.textPrimary, size: 24.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: AppStyles.bodyMedium(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: Text(
            AppStrings.createAccount,
            style: AppStyles.labelMedium(),
          ),
        ),
      ],
    );
  }
}
