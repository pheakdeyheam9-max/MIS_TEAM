class ScheduleItemEntity {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String category; // Shift, Meeting, Mission, Training

  const ScheduleItemEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.category,
  });
}
