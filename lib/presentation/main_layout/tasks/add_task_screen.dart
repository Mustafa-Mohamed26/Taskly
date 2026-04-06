import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskEntity? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = 'Work';
  String _selectedPriority = 'Medium';
  bool _isLoading = false;

  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dateTime);
      _selectedCategory = widget.task!.category;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is TaskLoading;
        });

        if (state is TaskSuccess) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: isEditMode ? 'Task Updated' : 'Task Added',
            desc:
                isEditMode
                    ? 'Your task has been updated successfully.'
                    : 'New task has been added to your list.',
            btnOkOnPress: () => Navigator.pop(context),
          ).show();
        } else if (state is TaskError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Operation Failed',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  size: 20.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isEditMode ? 'Edit Task' : AppStrings.newTask,
                style: AppStyles.headlineLarge(
                  isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w800, fontSize: 18.sp),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                _buildBackgroundDecorations(isDark),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Basic Information', isDark),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        'Task Title',
                        'What needs to be done?',
                        controller: _titleController,
                        isDark: isDark,
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField(
                        'Description',
                        'Add more details (optional)...',
                        controller: _descController,
                        maxLines: 4,
                        isDark: isDark,
                      ),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Date & Time', isDark),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickDate,
                              child: _buildSelectorField(
                                Icons.calendar_today_rounded,
                                'Date',
                                DateFormat('MMM dd, yyyy').format(_selectedDate),
                                isDark,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickTime,
                              child: _buildSelectorField(
                                Icons.access_time_rounded,
                                'Time',
                                _selectedTime.format(context),
                                isDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Category', isDark),
                      SizedBox(height: 16.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildCategoryChip('Work', Icons.work_rounded, isDark),
                            SizedBox(width: 12.w),
                            _buildCategoryChip('Personal', Icons.person_rounded, isDark),
                            SizedBox(width: 12.w),
                            _buildCategoryChip('Health', Icons.favorite_rounded, isDark),
                            SizedBox(width: 12.w),
                            _buildCategoryChip('Shopping', Icons.shopping_bag_rounded, isDark),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Priority Level', isDark),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          _buildPriorityCard('Low', AppColors.priorityLow, isDark),
                          SizedBox(width: 12.w),
                          _buildPriorityCard('Medium', AppColors.priorityMedium, isDark),
                          SizedBox(width: 12.w),
                          _buildPriorityCard('High', AppColors.priorityHigh, isDark),
                        ],
                      ),
                      SizedBox(height: 48.h),
                      _buildSubmitButton(isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const AuthLoadingWidget(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: AppStyles.labelSmall(
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ).copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w800),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    TextEditingController? controller,
    int maxLines = 1,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppStyles.bodySmall(
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyles.bodyMedium(
              isDark
                  ? AppColors.textSecondaryDark.withValues(alpha: 0.4)
                  : AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: isDark ? AppColors.fieldFillDark : AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorField(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppStyles.bodySmall(
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.fieldFillDark : AppColors.white,
            border: Border.all(
              color: isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: AppColors.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  value,
                  style: AppStyles.bodyMedium(
                    isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ).copyWith(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isDark) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.fieldFillDark : AppColors.white),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder),
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color:
                  isSelected
                      ? AppColors.white
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: AppStyles.bodyMedium(
                isSelected
                    ? AppColors.white
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityCard(String label, Color color, bool isDark) {
    final isSelected = _selectedPriority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? color.withValues(alpha: 0.1)
                    : (isDark ? AppColors.fieldFillDark : AppColors.white),
            border: Border.all(
              color: isSelected ? color : (isDark ? AppColors.fieldBorderDark : AppColors.fieldBorder),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppStyles.bodySmall(
                  isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ).copyWith(fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: Size(double.infinity, 64.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isEditMode ? Icons.check_circle_rounded : Icons.add_task_rounded,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              isEditMode ? 'Update Task' : AppStrings.createTask,
              style: AppStyles.labelLarge(AppColors.white).copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_titleController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Input Required',
        desc: 'Please enter a title for your task.',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    final authState = context.read<AuthCubit>().state;
    String userId = '';
    if (authState is Authenticated) userId = authState.user.id;
    if (userId.isEmpty) return;

    final taskDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final task = TaskEntity(
      id: isEditMode ? widget.task!.id : const Uuid().v4(),
      userId: userId,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dateTime: taskDate,
      category: _selectedCategory,
      priority: _selectedPriority,
      isCompleted: isEditMode ? widget.task!.isCompleted : false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    if (isEditMode) {
      context.read<TaskCubit>().updateTask(task);
    } else {
      context.read<TaskCubit>().addTask(task);
    }
  }

  Widget _buildBackgroundDecorations(bool isDark) {
    final color = AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.02);
    return Stack(
      children: [
        Positioned(
          top: -50.h,
          right: -30.w,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
