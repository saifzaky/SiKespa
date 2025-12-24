class Schedule {
  final String id;
  final String patientId;
  final String type; // 'consultation', 'medication', or 'appointment'
  final String title;
  final DateTime date;
  final String time;
  final String notes;
  final bool reminderEnabled;
  final String?
      frequency; // 'daily', 'twice', 'three_times', 'custom' for medications

  Schedule({
    required this.id,
    required this.patientId,
    required this.type,
    required this.title,
    required this.date,
    required this.time,
    required this.notes,
    this.reminderEnabled = true,
    this.frequency,
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
      'frequency': frequency,
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
      frequency: map['frequency'],
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

  bool get isMedication => type == 'medication';

  bool get isConsultation => type == 'consultation';
}
