import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/storage/local_calendar_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/calendar_event.dart';
import '../../../shared/widgets/add_edit_event_dialog.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/event_details_dialog.dart';

enum CalendarViewMode { month, week, day }

class CalendarScreen extends StatefulWidget {
  final bool isTabActive;

  const CalendarScreen({super.key, this.isTabActive = true});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarViewMode _viewMode = CalendarViewMode.month;
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<CalendarEvent> _allEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final events = await LocalCalendarService.instance.getEvents();
      if (mounted) {
        setState(() {
          _allEvents = events;
        });
      }
    } catch (e, stack) {
      debugPrint('Error loading calendar events: $e\n$stack');
      if (mounted) {
        setState(() {
          _allEvents = LocalCalendarService.instance.getInitialSampleEvents();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onTodayPressed() {
    final now = DateTime.now();
    setState(() {
      _focusedDate = now;
      _selectedDate = now;
    });
  }

  void _onPrevious() {
    setState(() {
      if (_viewMode == CalendarViewMode.month) {
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
      } else if (_viewMode == CalendarViewMode.week) {
        _focusedDate = _focusedDate.subtract(const Duration(days: 7));
      } else {
        _focusedDate = _focusedDate.subtract(const Duration(days: 1));
      }
      _selectedDate = _focusedDate;
    });
  }

  void _onNext() {
    setState(() {
      if (_viewMode == CalendarViewMode.month) {
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
      } else if (_viewMode == CalendarViewMode.week) {
        _focusedDate = _focusedDate.add(const Duration(days: 7));
      } else {
        _focusedDate = _focusedDate.add(const Duration(days: 1));
      }
      _selectedDate = _focusedDate;
    });
  }

  void _addNewEvent() async {
    final newEvent = await AddEditEventDialog.show(
      context,
      initialDate: _selectedDate,
    );

    if (newEvent != null) {
      await LocalCalendarService.instance.addEvent(newEvent);
      await _loadEvents();
    }
  }

  void _viewEventDetails(CalendarEvent event) async {
    await EventDetailsDialog.show(
      context,
      event: event,
      onUpdate: (updated) async {
        await LocalCalendarService.instance.updateEvent(updated);
        await _loadEvents();
      },
      onDelete: (id) async {
        await LocalCalendarService.instance.deleteEvent(id);
        await _loadEvents();
      },
    );
  }

  List<CalendarEvent> _getEventsForDate(DateTime date) {
    return _allEvents.where((e) {
      final s = DateTime(e.startDate.year, e.startDate.month, e.startDate.day);
      final end = DateTime(e.endDate.year, e.endDate.month, e.endDate.day);
      final target = DateTime(date.year, date.month, date.day);
      return (target.isAfter(s) || target.isAtSameMomentAs(s)) &&
          (target.isBefore(end) || target.isAtSameMomentAs(end));
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _getEventsForDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('calendar.app_bar_title'.tr(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'calendar.btn.today'.tr(context),
            onPressed: _onTodayPressed,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: MaxWidthContainer(
                maxWidth: 900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildViewSelectorHeader(context),
                    const SizedBox(height: 16),
                    _buildNavigationHeader(context),
                    const SizedBox(height: 16),
                    if (_viewMode == CalendarViewMode.month)
                      _buildMonthGrid(context),
                    if (_viewMode == CalendarViewMode.week)
                      _buildWeekStrip(context),
                    if (_viewMode == CalendarViewMode.day)
                      _buildDayTimeline(context),
                    const SizedBox(height: 24),
                    Text(
                      'calendar.events_for_date'.tr(context, {
                        'date':
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      }),
                      style: AppTypography.headingMedium,
                    ),
                    const SizedBox(height: 12),
                    if (dayEvents.isEmpty)
                      EmptyStateWidget(
                        title: 'calendar.no_events'.tr(context),
                        subtitle: 'calendar.add_event'.tr(context),
                        icon: Icons.event_note_outlined,
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dayEvents.length,
                        itemBuilder: (context, index) {
                          final event = dayEvents[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildEventCard(context, event),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
      floatingActionButton: widget.isTabActive
          ? FloatingActionButton.extended(
              onPressed: _addNewEvent,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text('calendar.add_event'.tr(context)),
            )
          : null,
    );
  }

  Widget _buildViewSelectorHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildViewModeButton(
            CalendarViewMode.month,
            'calendar.view.month'.tr(context),
          ),
          _buildViewModeButton(
            CalendarViewMode.week,
            'calendar.view.week'.tr(context),
          ),
          _buildViewModeButton(
            CalendarViewMode.day,
            'calendar.view.day'.tr(context),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(CalendarViewMode mode, String label) {
    final isSelected = _viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _viewMode = mode;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationHeader(BuildContext context) {
    final monthYearTitle =
        '${_getMonthName(_focusedDate.month)} ${_focusedDate.year}';

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _onPrevious,
              ),
              Text(monthYearTitle, style: AppTypography.headingMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _onNext,
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: _onTodayPressed,
            icon: const Icon(Icons.today, size: 16),
            label: Text('calendar.btn.today'.tr(context)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(BuildContext context) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final daysInMonth = DateTime(
      _focusedDate.year,
      _focusedDate.month + 1,
      0,
    ).day;
    final startingWeekday = firstDayOfMonth.weekday;

    final prevMonthDays = startingWeekday - 1;
    final totalCells = ((prevMonthDays + daysInMonth) / 7).ceil() * 7;

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final dayOffset = index - prevMonthDays + 1;
              if (dayOffset < 1 || dayOffset > daysInMonth) {
                return const SizedBox();
              }

              final cellDate = DateTime(
                _focusedDate.year,
                _focusedDate.month,
                dayOffset,
              );
              final isSelected = _isSameDay(cellDate, _selectedDate);
              final isToday = _isSameDay(cellDate, DateTime.now());
              final cellEvents = _getEventsForDate(cellDate);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = cellDate;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                        ? AppColors.primary.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayOffset',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isToday
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: (isSelected || isToday)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      if (cellEvents.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: cellEvents.take(3).map((e) {
                            return Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : e.color,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip(BuildContext context) {
    final startOfWeek = _focusedDate.subtract(
      Duration(days: _focusedDate.weekday - 1),
    );

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final cellDate = startOfWeek.add(Duration(days: index));
          final isSelected = _isSameDay(cellDate, _selectedDate);
          final isToday = _isSameDay(cellDate, DateTime.now());
          final cellEvents = _getEventsForDate(cellDate);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = cellDate;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(color: AppColors.primary, width: 1.5)
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cellDate.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (cellEvents.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : cellEvents.first.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayTimeline(BuildContext context) {
    final hours = List.generate(12, (index) => 8 + index);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: hours.map((hour) {
          final timeLabel = TimeOfDay(hour: hour, minute: 0).format(context);
          final hourEvents = _allEvents.where((e) {
            return _isSameDay(e.startDate, _selectedDate) &&
                e.startTimeHour == hour;
          }).toList();

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    timeLabel,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: hourEvents.isEmpty
                      ? const SizedBox(height: 24)
                      : Column(
                          children: hourEvents.map((event) {
                            return GestureDetector(
                              onTap: () => _viewEventDetails(event),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: event.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border(
                                    left: BorderSide(
                                      color: event.color,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  event.title,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, CalendarEvent event) {
    return AppCard(
      onTap: () => _viewEventDetails(event),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTypography.headingSmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: event.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.category,
                        style: TextStyle(
                          color: event.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                      style: AppTypography.bodySmall,
                    ),
                    if (event.location.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTypography.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
