import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/routes/app_routes.dart';
import 'package:taskly/domain/entities/user_entity.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/auth_logo.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is AuthSuccess<UserEntity>) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Success',
            desc: 'Account created successfully!',
            btnOkOnPress: () {
              Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
            },
          ).show();
        } else if (state is AuthError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Registration Error',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 48.h),
                    _buildForm(),
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
      children: [
        const AuthLogo(),
        SizedBox(height: 40.h),
        Text(
          AppStrings.joinTaskly,
          style: AppStyles.displayLarge(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.joinTasklySubtitle,
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
          label: AppStrings.fullName,
          hint: 'John Doe',
          controller: _nameController,
          prefixIcon: Icons.person_outline,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: AppStrings.email,
          hint: 'name@company.com',
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          label: AppStrings.password,
          hint: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
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
        SizedBox(height: 24.h),
        AuthTextField(
          label: AppStrings.confirmPassword,
          hint: '••••••••',
          controller: _confirmPasswordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.shield_outlined,
        ),
        SizedBox(height: 32.h),
        AuthButton(
          text: AppStrings.createAccount,
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty) {
              if (_passwordController.text == _confirmPasswordController.text) {
                context.read<AuthCubit>().register(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Validation',
                  desc: 'Passwords do not match',
                  btnOkOnPress: () {},
                ).show();
              }
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                title: 'Validation',
                desc: 'Please fill in all fields',
                btnOkOnPress: () {},
              ).show();
            }
          },
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: AppStyles.bodyMedium(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            AppStrings.signIn,
            style: AppStyles.labelMedium(),
          ),
        ),
      ],
    );
  }
}
