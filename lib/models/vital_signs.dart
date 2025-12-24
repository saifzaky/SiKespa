class VitalSigns {
  final String id;
  final String patientId;
  final DateTime date;
  final String bloodPressure; // e.g., "120/80"
  final int heartRate; // bpm
  final double temperature; // celsius
  final double bloodSugar;
  final double weight;
  final String? notes;

  VitalSigns({
    required this.id,
    required this.patientId,
    required this.date,
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
    required this.bloodSugar,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'date': date.toIso8601String(),
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'temperature': temperature,
      'bloodSugar': bloodSugar,
      'weight': weight,
      'notes': notes,
    };
  }

  factory VitalSigns.fromMap(Map<String, dynamic> map, String documentId) {
    return VitalSigns(
      id: documentId,
      patientId: map['patientId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      bloodPressure: map['bloodPressure'] ?? '',
      heartRate: (map['heartRate'] ?? 72).toInt(),
      temperature: (map['temperature'] ?? 36.5).toDouble(),
      bloodSugar: (map['bloodSugar'] ?? 0.0).toDouble(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      notes: map['notes'],
    );
  }

  // Helper to determine if vital signs are normal
  bool get isNormal {
    // Blood pressure check
    final bp = bloodPressure.split('/');
    if (bp.length == 2) {
      final systolic = int.tryParse(bp[0]) ?? 0;
      final diastolic = int.tryParse(bp[1]) ?? 0;
      if (systolic < 90 || systolic > 140 || diastolic < 60 || diastolic > 90) {
        return false;
      }
    }

    // Heart rate check (60-100 bpm is normal range)
    if (heartRate < 60 || heartRate > 100) return false;

    // Temperature check (36.1-37.2°C is normal range)
    if (temperature < 36.1 || temperature > 37.2) return false;

    // Blood sugar check (fasting: 70-100 mg/dL)
    if (bloodSugar < 70 || bloodSugar > 140) return false;

    return true;
  }

  String get statusText => isNormal ? 'Normal' : 'Perlu Perhatian';
}
