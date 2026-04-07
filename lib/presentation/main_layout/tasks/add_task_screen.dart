import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taskly/domain/entities/task_entity.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import 'package:taskly/presentation/auth/widgets/auth_loading_widget.dart';
import 'package:taskly/presentation/main_layout/tasks/cubit/task_cubit.dart';
import 'package:taskly/presentation/widgets/app_button.dart';
import 'package:taskly/presentation/widgets/app_text_field.dart';
import 'package:taskly/presentation/widgets/section_title.dart';
import 'package:uuid/uuid.dart';
import 'package:taskly/core/constants/app_strings.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_styles.dart';
import 'widgets/add_task_selector_field.dart';
import 'widgets/add_task_category_chip.dart';
import 'widgets/add_task_priority_card.dart';
import 'widgets/add_task_background_decorations.dart';

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
  List<String> _selectedCategories = ['Work'];
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
      _selectedCategories = List.from(widget.task!.categories);
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<TaskCubit, TaskState>(
      listener: _handleStateChanges,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(isDark),
            body: Stack(
              children: [
                AddTaskBackgroundDecorations(isDark: isDark),
                _buildForm(isDark),
              ],
            ),
          ),
          if (_isLoading) const AuthLoadingWidget(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          size: 28.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        isEditMode ? 'Edit Task' : AppStrings.newTask,
        style: AppStyles.displayMedium(
          isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ).copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 22.sp,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: false,
      titleSpacing: 0,
    );
  }

  Widget _buildForm(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Task Title',
            hint: 'What needs to be done?',
            controller: _titleController,
            isDark: isDark,
          ),
          SizedBox(height: 24.h),
          AppTextField(
            label: 'Description',
            hint: 'Add more details about this task...',
            controller: _descController,
            maxLines: 4,
            isDark: isDark,
          ),
          SizedBox(height: 24.h),
          _buildDateTimeSelectors(isDark),
          SizedBox(height: 24.h),
          _buildCategorySection(isDark),
          SizedBox(height: 32.h),
          _buildPrioritySection(isDark),
          SizedBox(height: 48.h),
          AppButton(
            text: isEditMode ? 'Update Task' : AppStrings.createTask,
            isLoading: _isLoading,
            icon: isEditMode ? Icons.check_circle_rounded : Icons.add_task_rounded,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelectors(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: AddTaskSelectorField(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: DateFormat('MMM dd, yyyy').format(_selectedDate),
            isDark: isDark,
            onTap: _pickDate,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AddTaskSelectorField(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: _selectedTime.format(context),
            isDark: isDark,
            onTap: _pickTime,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(bool isDark) {
    final categories = [
      {'label': 'Work', 'icon': Icons.work_rounded},
      {'label': 'Personal', 'icon': Icons.person_rounded},
      {'label': 'Health', 'icon': Icons.favorite_rounded},
      {'label': 'Shopping', 'icon': Icons.shopping_bag_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Category', isDark: isDark),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: categories.map((cat) {
              final label = cat['label'] as String;
              final isSelected = _selectedCategories.contains(label);
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: AddTaskCategoryChip(
                  label: label,
                  icon: cat['icon'] as IconData,
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        if (_selectedCategories.length > 1) {
                          _selectedCategories.remove(label);
                        }
                      } else {
                        _selectedCategories.add(label);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection(bool isDark) {
    final priorities = [
      {'label': 'Low', 'color': Colors.blue},
      {'label': 'Medium', 'color': Colors.orange},
      {'label': 'High', 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Priority', isDark: isDark),
        SizedBox(height: 16.h),
        Row(
          children: priorities.map((prio) {
            return AddTaskPriorityCard(
              label: prio['label'] as String,
              dotColor: prio['color'] as Color,
              isSelected: _selectedPriority == prio['label'],
              isDark: isDark,
              onTap: () => setState(() => _selectedPriority = prio['label'] as String),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, TaskState state) {
    setState(() => _isLoading = state is TaskLoading);
    if (state is TaskError) {
      _showErrorDialog(state.message);
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Operation Failed',
      desc: message,
    ).show();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.trim().isEmpty) {
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
    if (authState is! Authenticated) return;

    final task = TaskEntity(
      id: isEditMode ? widget.task!.id : const Uuid().v4(),
      userId: authState.user.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dateTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute),
      categories: _selectedCategories,
      priority: _selectedPriority,
      isCompleted: isEditMode ? widget.task!.isCompleted : false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    try {
      if (isEditMode) {
        await context.read<TaskCubit>().updateTask(task);
      } else {
        await context.read<TaskCubit>().addTask(task);
      }
      if (mounted) _showSuccessDialog();
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString());
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: isEditMode ? 'Task Updated' : 'Task Added',
      desc: isEditMode ? 'Your task has been updated successfully.' : 'New task has been added to your list.',
      btnOkOnPress: () => Navigator.pop(context),
    ).show();
  }
}
