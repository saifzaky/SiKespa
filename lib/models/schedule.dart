class Schedule {
  final String id;
  final String patientId;
  final String type; // 'consultation' or 'medication'
  final String title;
  final DateTime date;
  final String time;
  final String notes;
  final bool reminderEnabled;

  Schedule({
    required this.id,
    required this.patientId,
    required this.type,
    required this.title,
    required this.date,
    required this.time,
    required this.notes,
    this.reminderEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'type': type,
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'notes': notes,
      'reminderEnabled': reminderEnabled,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map, String documentId) {
    return Schedule(
      id: documentId,
      patientId: map['patientId'] ?? '',
      type: map['type'] ?? 'consultation',
      title: map['title'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      time: map['time'] ?? '',
      notes: map['notes'] ?? '',
      reminderEnabled: map['reminderEnabled'] ?? true,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get isUpcoming {
    return date.isAfter(DateTime.now());
  }
}
