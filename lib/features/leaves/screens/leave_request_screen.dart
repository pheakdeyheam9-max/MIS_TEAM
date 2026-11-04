import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String _selectedTypeKey = 'leave_type.annual.title';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final List<Map<String, String>> _leaveTypeKeys = [
    {'key': 'leave_type.annual.title'},
    {'key': 'leave_type.sick.title'},
    {'key': 'leave_type.casual.title'},
    {'key': 'leave_type.unpaid.title'},
  ];

  void _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('validation.select_dates'.tr(context))),
        );
        return;
      }

      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('leave_request.snackbar_success'.tr(context)),
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('leave_request.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 800,
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'leave_request.heading'.tr(context),
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'leave_request.subtitle'.tr(context),
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'leave_request.field.category_label'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTypeKey,
                    decoration: const InputDecoration(),
                    items: _leaveTypeKeys.map((type) {
                      return DropdownMenuItem(
                        value: type['key']!,
                        child: Text(type['key']!.tr(context)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTypeKey = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(true),
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            _startDate == null
                                ? 'common.start_date'.tr(context)
                                : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(false),
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            _endDate == null
                                ? 'common.end_date'.tr(context)
                                : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'leave_request.field.reason_label'.tr(context),
                    hint: 'leave_request.field.reason_hint'.tr(context),
                    controller: _reasonController,
                    maxLines: 4,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'leave_request.field.reason_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'leave_request.btn_submit'.tr(context),
                    isLoading: _isLoading,
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
