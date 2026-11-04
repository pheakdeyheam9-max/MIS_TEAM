import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/state/attendance_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/app_text_field.dart';

class AttendanceCheckInScreen extends StatefulWidget {
  const AttendanceCheckInScreen({super.key});

  @override
  State<AttendanceCheckInScreen> createState() =>
      _AttendanceCheckInScreenState();
}

class _AttendanceCheckInScreenState extends State<AttendanceCheckInScreen> {
  final _locationController = TextEditingController(
    text: 'Corporate Headquarters - Building A (11.5564° N, 104.9282° E)',
  );
  final _notesController = TextEditingController();
  bool _isLoading = false;

  Timer? _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = _getCambodiaTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = _getCambodiaTime();
        });
      }
    });
  }

  DateTime _getCambodiaTime() {
    return DateTime.now().toUtc().add(const Duration(hours: 7));
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    final secondStr = dt.second.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hourStr:$minuteStr:$secondStr $period';
  }

  String _formatDate(DateTime dt) {
    const weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayName = weekDays[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    return '$dayName, $monthName ${dt.day}, ${dt.year}';
  }

  void _handleCheckIn() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        AttendanceNotifier.performCheckIn(location: _locationController.text);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('attendance_check_in.snackbar_success'.tr(context)),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AttendanceRecordState>(
      valueListenable: AttendanceNotifier.attendanceNotifier,
      builder: (context, attendanceState, child) {
        final isWorking =
            attendanceState.status == AttendanceStateStatus.working;
        final isCompleted =
            attendanceState.status == AttendanceStateStatus.shiftCompleted;

        return Scaffold(
          appBar: AppBar(
            title: Text('attendance_check_in.app_bar_title'.tr(context)),
          ),
          drawer: const AppDrawer(),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MaxWidthContainer(
              maxWidth: 800,
              child: Column(
                children: [
                  _buildClockCard(),
                  const SizedBox(height: 20),
                  AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'attendance_check_in.location_verification'.tr(
                            context,
                          ),
                          style: AppTypography.headingMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'attendance_check_in.gps_description'.tr(context),
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label:
                              'attendance_check_in.field.detected_location_label'
                                  .tr(context),
                          controller: _locationController,
                          prefixIcon: Icons.my_location,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'attendance_check_in.field.notes_label'.tr(
                            context,
                          ),
                          hint: 'attendance_check_in.field.notes_hint'.tr(
                            context,
                          ),
                          controller: _notesController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 24),
                        if (!isWorking && !isCompleted)
                          AppButton(
                            text: 'attendance_check_in.btn_confirm'.tr(context),
                            icon: Icons.login,
                            isLoading: _isLoading,
                            onPressed: _handleCheckIn,
                          )
                        else if (isWorking) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.successBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'attendance_check_in.success_message'.tr(
                                      context,
                                    ),
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            text: 'attendance_check_in.btn_proceed_checkout'.tr(
                              context,
                            ),
                            variant: AppButtonVariant.outline,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.attendanceCheckOut,
                              );
                            },
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warningBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'attendance.status.shift_completed'.tr(
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

  Widget _buildClockCard() {
    return AppCard(
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.access_time_filled, size: 48, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            _formatTime(_currentTime),
            style: AppTypography.displayLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(_currentTime),
            style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
