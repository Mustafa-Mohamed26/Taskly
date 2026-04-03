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
  const AddTaskScreen({super.key});

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is TaskLoading;
        });

        if (state is TaskSuccess) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Success',
            desc: 'Task added successfully!',
            btnOkOnPress: () => Navigator.pop(context),
          ).show();
        } else if (state is TaskError) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(AppStrings.newTask, style: AppStyles.titleLarge()),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel(AppStrings.taskTitle),
                  _buildTextField('What needs to be done?', controller: _titleController),
                  SizedBox(height: 24.h),
                  _buildFieldLabel(AppStrings.description),
                  _buildTextField('Add more details...', controller: _descController, maxLines: 4),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel(AppStrings.date),
                            GestureDetector(
                              onTap: _pickDate,
                              child: _buildSelectorField(
                                Icons.calendar_today,
                                DateFormat('MMM dd, yyyy').format(_selectedDate),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel(AppStrings.time),
                            GestureDetector(
                              onTap: _pickTime,
                              child: _buildSelectorField(
                                Icons.access_time,
                                _selectedTime.format(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildFieldLabel(AppStrings.category),
                  Row(
                    children: [
                      _buildCategoryChip('Work', Icons.work),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Personal', Icons.person),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Health', Icons.favorite),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildFieldLabel(AppStrings.priority),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriorityButton('Low', AppColors.priorityLow),
                      _buildPriorityButton('Medium', AppColors.priorityMedium),
                      _buildPriorityButton('High', AppColors.priorityHigh),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: _createTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_task, color: AppColors.white),
                        SizedBox(width: 8.w),
                        Text(AppStrings.createTask, style: AppStyles.labelLarge()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const AuthLoadingWidget(), // Reusing the same loading overlay
        ],
      ),
    );
  }

  void _createTask() {
    if (_titleController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: 'Validation',
        desc: 'Title cannot be empty',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    final authState = context.read<AuthCubit>().state;
    String userId = '';
    if (authState is Authenticated) {
      userId = authState.user.id;
    } else if (authState is LoginSuccess) {
      userId = authState.user.id;
    } else if (authState is RegisterSuccess) {
      userId = authState.user.id;
    }

    if (userId.isEmpty) return;

    final taskDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final task = TaskEntity(
      id: const Uuid().v4(),
      userId: userId,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dateTime: taskDate,
      category: _selectedCategory,
      priority: _selectedPriority,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    context.read<TaskCubit>().addTask(task);
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: AppStyles.labelSmall().copyWith(letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTextField(String hint, {TextEditingController? controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.bodyMedium(AppColors.fieldHint),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
      ),
    );
  }

  Widget _buildSelectorField(IconData icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(value, style: AppStyles.bodyMediumMedium(AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppStyles.bodyMediumMedium(
                isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String label, Color color) {
    final isSelected = _selectedPriority == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = label),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.white,
          border: Border.all(
            color: isSelected ? color : AppColors.fieldBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppStyles.bodyMediumMedium(
                isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
