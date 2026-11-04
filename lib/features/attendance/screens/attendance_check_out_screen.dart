import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/state/attendance_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/app_text_field.dart';

class AttendanceCheckOutScreen extends StatefulWidget {
  const AttendanceCheckOutScreen({super.key});

  @override
  State<AttendanceCheckOutScreen> createState() =>
      _AttendanceCheckOutScreenState();
}

class _AttendanceCheckOutScreenState extends State<AttendanceCheckOutScreen> {
  final _locationController = TextEditingController(
    text: 'Corporate Headquarters - Building A (11.5564° N, 104.9282° E)',
  );
  final _summaryController = TextEditingController();
  bool _isLoading = false;

  void _handleCheckOut() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        AttendanceNotifier.performCheckOut(location: _locationController.text);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('attendance_check_out.snackbar_success'.tr(context)),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  String _formatTimeOnly(DateTime? dt) {
    if (dt == null) return '--:--';
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hourStr:$minuteStr $period';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AttendanceRecordState>(
      valueListenable: AttendanceNotifier.attendanceNotifier,
      builder: (context, attendanceState, child) {
        final isCheckedOut =
            attendanceState.status == AttendanceStateStatus.shiftCompleted;

        return Scaffold(
          appBar: AppBar(
            title: Text('attendance_check_out.app_bar_title'.tr(context)),
          ),
          drawer: const AppDrawer(),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MaxWidthContainer(
              maxWidth: 800,
              child: Column(
                children: [
                  _buildSummaryCard(context, attendanceState),
                  const SizedBox(height: 20),
                  AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'attendance_check_out.end_of_duty_log'.tr(context),
                          style: AppTypography.headingMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'attendance_check_out.description'.tr(context),
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'attendance_check_out.field.location_label'.tr(
                            context,
                          ),
                          controller: _locationController,
                          prefixIcon: Icons.my_location,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'attendance_check_out.field.summary_label'.tr(
                            context,
                          ),
                          hint: 'attendance_check_out.field.summary_hint'.tr(
                            context,
                          ),
                          controller: _summaryController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        if (!isCheckedOut)
                          AppButton(
                            text: 'attendance_check_out.btn_confirm'.tr(
                              context,
                            ),
                            icon: Icons.logout,
                            variant: AppButtonVariant.primary,
                            isLoading: _isLoading,
                            onPressed: _handleCheckOut,
                          )
                        else ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warningBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'attendance_check_out.success_message'.tr(
                                      context,
                                    ),
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            text: 'attendance_check_out.btn_return_dashboard'
                                .tr(context),
                            variant: AppButtonVariant.outline,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, AttendanceRecordState state) {
    final statusText = state.status == AttendanceStateStatus.working
        ? 'status.on_duty'.tr(context)
        : state.status == AttendanceStateStatus.shiftCompleted
        ? 'status.completed'.tr(context)
        : 'status.absent'.tr(context);

    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailColumn(
            'attendance_check_out.summary.check_in_time'.tr(context),
            _formatTimeOnly(state.checkInTime),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildDetailColumn(
            'attendance_check_out.summary.current_status'.tr(context),
            statusText,
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildDetailColumn(
            'attendance_check_out.summary.elapsed'.tr(context),
            state.formattedDuration,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String title, String val) {
    return Column(
      children: [
        Text(title, style: AppTypography.caption),
        const SizedBox(height: 4),
        Text(
          val,
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
