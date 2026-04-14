import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  String? _uid;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();

    _loadUserData();
  }

  void _loadUserData() {
    final state = context.read<AuthCubit>().state;
    if (state is Authenticated) {
      _uid = state.user.id;
      _nameController.text = state.user.name ?? '';
      _emailController.text = state.user.email;
      _phoneController.text = state.user.phone ?? '';
      _bioController.text = state.user.bio ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_uid != null && _formKey.currentState!.validate()) {
      context.read<AuthCubit>().updateProfile(
            uid: _uid!,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            bio: _bioController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildProfileIcon(),
                  SizedBox(height: 32.h),
                  _buildForm(context),
                  SizedBox(height: 24.h),
                  _buildVerificationBanner(context),
                  SizedBox(height: 32.h),
                  _buildActionButtons(context, isLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(AppStrings.personalInfo, style: AppStyles.titleLarge(Theme.of(context).colorScheme.onSurface)),
      centerTitle: true,
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Icon(Icons.person_rounded, color: AppColors.white, size: 60.sp),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        _buildInfoField(
          context,
          'Full Name',
          _nameController,
          Icons.person_outline,
        ),
        SizedBox(height: 20.h),
        _buildInfoField(
          context,
          'Email Address',
          _emailController,
          Icons.email_outlined,
          readOnly: true,
        ),
        SizedBox(height: 20.h),
        _buildInfoField(
          context,
          'Phone Number',
          _phoneController,
          Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20.h),
        _buildBioField(context),
      ],
    );
  }

  Widget _buildInfoField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF131629) : AppColors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 8.w),
            Text(label, style: AppStyles.labelSmall(Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: AppStyles.bodyMedium(
            readOnly ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5) : Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF131629) : AppColors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.notes_rounded, size: 16.sp, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 8.w),
            Text('Bio', style: AppStyles.labelSmall(Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          style: AppStyles.bodyMedium(Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerBg = isDark ? const Color(0xFF131629) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Verification',
                  style: AppStyles.bodyLargeMedium(Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  'Your account is fully verified',
                  style: AppStyles.bodySmall(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isLoading) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cancelBg = isDark ? const Color(0xFFFFFFFF) : AppColors.white;

    return Column(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: const CircularProgressIndicator(color: AppColors.white),
                )
              : Text('Save Changes', style: AppStyles.labelLarge()),
        ),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: Size(double.infinity, 56.h),
            backgroundColor: cancelBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Cancel',
            style: AppStyles.bodyLargeMedium(AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

