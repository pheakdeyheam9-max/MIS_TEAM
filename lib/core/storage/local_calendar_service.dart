import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/calendar_event.dart';

class LocalCalendarService {
  LocalCalendarService._();
  static final LocalCalendarService instance = LocalCalendarService._();

  static const String _storageKey = 'misteams_calendar_events_v1';
  SharedPreferences? _prefs;
  List<CalendarEvent>? _memoryCache;

  Future<SharedPreferences?> _getPrefs() async {
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    } catch (e) {
      debugPrint('SharedPreferences init error in LocalCalendarService: $e');
      return null;
    }
  }

  Future<List<CalendarEvent>> getEvents() async {
    if (_memoryCache != null && _memoryCache!.isNotEmpty) {
      return List.from(_memoryCache!);
    }

    try {
      final prefs = await _getPrefs();
      final rawData = prefs?.getString(_storageKey);

      if (rawData != null && rawData.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(rawData);
        _memoryCache = jsonList
            .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
            .toList();
        return List.from(_memoryCache!);
      }
    } catch (e) {
      debugPrint('Error getting events from SharedPreferences: $e');
    }

    final defaultEvents = getInitialSampleEvents();
    _memoryCache = List.from(defaultEvents);
    await saveEvents(defaultEvents);
    return List.from(_memoryCache!);
  }

  Future<void> saveEvents(List<CalendarEvent> events) async {
    _memoryCache = List.from(events);
    try {
      final prefs = await _getPrefs();
      final jsonList = events.map((e) => e.toJson()).toList();
      await prefs?.setString(_storageKey, json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving events to SharedPreferences: $e');
    }
  }

  Future<void> addEvent(CalendarEvent event) async {
    final currentEvents = await getEvents();
    currentEvents.add(event);
    await saveEvents(currentEvents);
  }

  Future<void> updateEvent(CalendarEvent updatedEvent) async {
    final currentEvents = await getEvents();
    final index = currentEvents.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      currentEvents[index] = updatedEvent;
      await saveEvents(currentEvents);
    }
  }

  Future<void> deleteEvent(String id) async {
    final currentEvents = await getEvents();
    currentEvents.removeWhere((e) => e.id == id);
    await saveEvents(currentEvents);
  }

  List<CalendarEvent> getInitialSampleEvents() {
    final now = DateTime.now();
    return [
      CalendarEvent(
        id: 'EVT-101',
        title: 'Team Sync & Mission Briefing',
        description: 'Weekly team alignment and operational updates.',
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day),
        startTimeHour: 9,
        startTimeMinute: 0,
        endTimeHour: 10,
        endTimeMinute: 30,
        location: 'Conference Room B',
        category: 'Meeting',
        colorValue: 0xFF1B4D3E,
        reminder: '15 mins before',
      ),
      CalendarEvent(
        id: 'EVT-102',
        title: 'Data Center Security Inspection',
        description: 'Physical audit and server rack verification.',
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day),
        startTimeHour: 11,
        startTimeMinute: 0,
        endTimeHour: 13,
        endTimeMinute: 0,
        location: 'North Wing Hub',
        category: 'Mission',
        colorValue: 0xFF0288D1,
        reminder: '1 hour before',
      ),
      CalendarEvent(
        id: 'EVT-103',
        title: 'Quarterly Operational Review',
        description: 'Executive briefing and department KPI assessment.',
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day),
        startTimeHour: 14,
        startTimeMinute: 30,
        endTimeHour: 16,
        endTimeMinute: 0,
        location: 'Virtual Call / Room 4',
        category: 'Internal',
        colorValue: 0xFFED6C02,
        reminder: '30 mins before',
      ),
    ];
  }
}
