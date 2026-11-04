import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class MissionRequestScreen extends StatefulWidget {
  const MissionRequestScreen({super.key});

  @override
  State<MissionRequestScreen> createState() => _MissionRequestScreenState();
}

class _MissionRequestScreenState extends State<MissionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _selectedTypeKey = 'mission_type.client_site_inspection.title';
  DateTime? _startDate;
  DateTime? _endDate;
  String? _attachmentFileName;
  bool _isLoading = false;

  final List<Map<String, String>> _missionTypeKeys = [
    {'key': 'mission_type.client_site_inspection.title'},
    {'key': 'mission_type.field_audit.title'},
    {'key': 'mission_type.technical_support.title'},
    {'key': 'mission_type.partner_training.title'},
  ];

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dayStr = dt.day.toString().padLeft(2, '0');
    final monthStr = months[dt.month - 1];
    return '$dayStr $monthStr ${dt.year}';
  }

  void _selectDate(bool isStart) async {
    final initial = isStart
        ? (_startDate ?? DateTime.now().add(const Duration(days: 1)))
        : (_endDate ??
              _startDate ??
              DateTime.now().add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = _formatDate(picked);
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
            _endDateController.clear();
          }
        } else {
          _endDate = picked;
          _endDateController.text = _formatDate(picked);
        }
      });
    }
  }

  void _pickAttachment() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final samples = [
          'Site_Inspection_Plan_v1.pdf',
          'Field_Audit_Scope_Doc.docx',
          'Technical_Requirements.pdf',
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'mission_request.field.attachment_label'.tr(context),
                  style: AppTypography.headingSmall,
                ),
              ),
              const Divider(height: 1),
              ...samples.map((fileName) {
                return ListTile(
                  leading: const Icon(
                    Icons.insert_drive_file,
                    color: AppColors.primary,
                  ),
                  title: Text(fileName, style: AppTypography.bodyMedium),
                  onTap: () {
                    setState(() {
                      _attachmentFileName = fileName;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
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
              content: Text('mission_request.snackbar_success'.tr(context)),
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('mission_request.app_bar_title'.tr(context))),
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
                    'mission_request.section_title'.tr(context),
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'mission_request.subtitle'.tr(context),
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'mission_request.field.category_label'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTypeKey,
                    decoration: const InputDecoration(),
                    items: _missionTypeKeys.map((type) {
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
                  AppTextField(
                    label: 'mission_request.field.title_label'.tr(context),
                    hint: 'mission_request.field.title_hint'.tr(context),
                    controller: _titleController,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'mission_request.field.title_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'mission_request.field.location_label'.tr(context),
                    hint: 'mission_request.field.location_hint'.tr(context),
                    controller: _locationController,
                    prefixIcon: Icons.location_on_outlined,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'mission_request.field.location_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'common.start_date'.tr(context),
                          hint: 'DD MMM YYYY',
                          controller: _startDateController,
                          readOnly: true,
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onTap: () => _selectDate(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: 'common.end_date'.tr(context),
                          hint: 'DD MMM YYYY',
                          controller: _endDateController,
                          readOnly: true,
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onTap: () => _selectDate(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'mission_request.field.description_label'.tr(
                      context,
                    ),
                    hint: 'mission_request.field.description_hint'.tr(context),
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'mission_request.field.description_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'mission_request.field.attachment_label'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: _attachmentFileName == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'mission_request.no_file_chosen'.tr(context),
                                style: AppTypography.bodySmall,
                              ),
                              OutlinedButton.icon(
                                onPressed: _pickAttachment,
                                icon: const Icon(Icons.attach_file, size: 16),
                                label: Text(
                                  'mission_request.btn_choose_file'.tr(context),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.insert_drive_file,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _attachmentFileName!,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _attachmentFileName = null;
                                  });
                                },
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'mission_request.btn_submit'.tr(context),
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
