import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int startTimeHour;
  final int startTimeMinute;
  final int endTimeHour;
  final int endTimeMinute;
  final String location;
  final String category;
  final int colorValue;
  final String reminder;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    required this.endDate,
    this.startTimeHour = 9,
    this.startTimeMinute = 0,
    this.endTimeHour = 10,
    this.endTimeMinute = 0,
    this.location = '',
    this.category = 'Meeting',
    this.colorValue = 0xFF1B4D3E,
    this.reminder = 'None',
  });

  TimeOfDay get startTime =>
      TimeOfDay(hour: startTimeHour, minute: startTimeMinute);
  TimeOfDay get endTime => TimeOfDay(hour: endTimeHour, minute: endTimeMinute);
  Color get color => Color(colorValue);

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? startTimeHour,
    int? startTimeMinute,
    int? endTimeHour,
    int? endTimeMinute,
    String? location,
    String? category,
    int? colorValue,
    String? reminder,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTimeHour: startTimeHour ?? this.startTimeHour,
      startTimeMinute: startTimeMinute ?? this.startTimeMinute,
      endTimeHour: endTimeHour ?? this.endTimeHour,
      endTimeMinute: endTimeMinute ?? this.endTimeMinute,
      location: location ?? this.location,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      reminder: reminder ?? this.reminder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'startTimeHour': startTimeHour,
      'startTimeMinute': startTimeMinute,
      'endTimeHour': endTimeHour,
      'endTimeMinute': endTimeMinute,
      'location': location,
      'category': category,
      'colorValue': colorValue,
      'reminder': reminder,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val, int fallback) {
      if (val is int) return val;
      if (val is double) return val.toInt();
      if (val is String) return int.tryParse(val) ?? fallback;
      return fallback;
    }

    DateTime parseDateTime(dynamic val, DateTime fallback) {
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val) ?? fallback;
      return fallback;
    }

    return CalendarEvent(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startDate: parseDateTime(json['startDate'], DateTime.now()),
      endDate: parseDateTime(json['endDate'], DateTime.now()),
      startTimeHour: parseInt(json['startTimeHour'], 9).clamp(0, 23),
      startTimeMinute: parseInt(json['startTimeMinute'], 0).clamp(0, 59),
      endTimeHour: parseInt(json['endTimeHour'], 10).clamp(0, 23),
      endTimeMinute: parseInt(json['endTimeMinute'], 0).clamp(0, 59),
      location: json['location']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Meeting',
      colorValue: parseInt(json['colorValue'], 0xFF1B4D3E),
      reminder: json['reminder']?.toString() ?? 'None',
    );
  }
}
