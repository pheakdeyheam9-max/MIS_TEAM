import 'package:flutter/material.dart';
import '../../core/localization/localize_key.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/calendar_event.dart';
import 'app_button.dart';
import 'app_text_field.dart';

class AddEditEventDialog extends StatefulWidget {
  final CalendarEvent? eventToEdit;
  final DateTime? initialDate;

  const AddEditEventDialog({super.key, this.eventToEdit, this.initialDate});

  static Future<CalendarEvent?> show(
    BuildContext context, {
    CalendarEvent? eventToEdit,
    DateTime? initialDate,
  }) {
    return showDialog<CalendarEvent>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddEditEventDialog(
        eventToEdit: eventToEdit,
        initialDate: initialDate,
      ),
    );
  }

  @override
  State<AddEditEventDialog> createState() => _AddEditEventDialogState();
}

class _AddEditEventDialogState extends State<AddEditEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  late String _category;
  late int _selectedColorValue;
  late String _reminder;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Meeting',
      'key': 'calendar.category.meeting',
      'color': 0xFF1B4D3E,
    },
    {
      'name': 'Mission',
      'key': 'calendar.category.mission',
      'color': 0xFF0288D1,
    },
    {
      'name': 'Internal',
      'key': 'calendar.category.internal',
      'color': 0xFFED6C02,
    },
    {
      'name': 'Holiday',
      'key': 'calendar.category.holiday',
      'color': 0xFF2E7D32,
    },
    {
      'name': 'Personal',
      'key': 'calendar.category.personal',
      'color': 0xFF9C27B0,
    },
    {
      'name': 'Technical',
      'key': 'calendar.category.technical',
      'color': 0xFFD32F2F,
    },
  ];

  final List<int> _colorSwatches = [
    0xFF1B4D3E,
    0xFF0288D1,
    0xFFED6C02,
    0xFF2E7D32,
    0xFF9C27B0,
    0xFFD32F2F,
    0xFF009688,
    0xFF3F51B5,
  ];

  final List<String> _reminderOptions = [
    'None',
    '5 mins before',
    '15 mins before',
    '30 mins before',
    '1 hour before',
    '1 day before',
  ];

  @override
  void initState() {
    super.initState();
    final event = widget.eventToEdit;
    final defaultDate = widget.initialDate ?? DateTime.now();

    _titleController = TextEditingController(text: event?.title ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    _descriptionController = TextEditingController(
      text: event?.description ?? '',
    );

    _startDate = event?.startDate ?? defaultDate;
    _endDate = event?.endDate ?? defaultDate;
    _startTime = event?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    _endTime = event?.endTime ?? const TimeOfDay(hour: 10, minute: 0);

    final initialCat = event?.category ?? 'Meeting';
    final categoryExists = _categories.any((c) => c['name'] == initialCat);
    _category = categoryExists ? initialCat : 'Meeting';

    _selectedColorValue = event?.colorValue ?? 0xFF1B4D3E;

    final initialRem = event?.reminder ?? 'None';
    final reminderExists = _reminderOptions.contains(initialRem);
    _reminder = reminderExists ? initialRem : 'None';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectDate(bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _selectTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final startDT = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      final endDT = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      if (endDT.isBefore(startDT)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('calendar.validation.end_before_start'.tr(context)),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final isEdit = widget.eventToEdit != null;
      final resultEvent = CalendarEvent(
        id: isEdit
            ? widget.eventToEdit!.id
            : 'EVT-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        startTimeHour: _startTime.hour,
        startTimeMinute: _startTime.minute,
        endTimeHour: _endTime.hour,
        endTimeMinute: _endTime.minute,
        location: _locationController.text.trim(),
        category: _category,
        colorValue: _selectedColorValue,
        reminder: _reminder,
      );

      Navigator.pop(context, resultEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.eventToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 540),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit
                          ? 'calendar.edit_event'.tr(context)
                          : 'calendar.add_event'.tr(context),
                      style: AppTypography.headingLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'calendar.field.title'.tr(context),
                  controller: _titleController,
                  prefixIcon: Icons.title,
                  validator: (val) => Validators.validateRequired(
                    val,
                    'calendar.field.title'.tr(context),
                    context,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'calendar.field.category'.tr(context),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _category,
                            decoration: const InputDecoration(),
                            items: _categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat['name'] as String,
                                child: Text((cat['key'] as String).tr(context)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                final matched = _categories.firstWhere(
                                  (element) => element['name'] == val,
                                  orElse: () => _categories[0],
                                );
                                setState(() {
                                  _category = val;
                                  _selectedColorValue = matched['color'] as int;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'calendar.field.color'.tr(context),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _colorSwatches.map((colorVal) {
                    final isSelected = _selectedColorValue == colorVal;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedColorValue = colorVal),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(colorVal),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.textPrimary,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'calendar.field.start_date'.tr(context),
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 4),
                          OutlinedButton.icon(
                            onPressed: () => _selectDate(true),
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'calendar.field.end_date'.tr(context),
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 4),
                          OutlinedButton.icon(
                            onPressed: () => _selectDate(false),
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'calendar.field.start_time'.tr(context),
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 4),
                          OutlinedButton.icon(
                            onPressed: () => _selectTime(true),
                            icon: const Icon(Icons.access_time, size: 16),
                            label: Text(_startTime.format(context)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'calendar.field.end_time'.tr(context),
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 4),
                          OutlinedButton.icon(
                            onPressed: () => _selectTime(false),
                            icon: const Icon(Icons.access_time, size: 16),
                            label: Text(_endTime.format(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'calendar.field.location'.tr(context),
                  controller: _locationController,
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'calendar.field.description'.tr(context),
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'calendar.field.reminder'.tr(context),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _reminder,
                  decoration: const InputDecoration(),
                  items: _reminderOptions.map((rem) {
                    return DropdownMenuItem<String>(
                      value: rem,
                      child: Text(rem),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _reminder = val);
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('calendar.btn.cancel'.tr(context)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'calendar.btn.save'.tr(context),
                        onPressed: _handleSave,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
