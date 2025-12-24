class PatientProfile {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String bloodType;
  final List<String> allergies;
  final String emergencyContact;
  final String insuranceNumber;
  final String? photoUrl;

  PatientProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.bloodType,
    required this.allergies,
    required this.emergencyContact,
    required this.insuranceNumber,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'insuranceNumber': insuranceNumber,
      'photoUrl': photoUrl,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientProfile(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      bloodType: map['bloodType'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      emergencyContact: map['emergencyContact'] ?? '',
      insuranceNumber: map['insuranceNumber'] ?? '',
      photoUrl: map['photoUrl'],
    );
  }

  PatientProfile copyWith({
    String? id,
    String? userId,
    String? name,
    int? age,
    String? bloodType,
    List<String>? allergies,
    String? emergencyContact,
    String? insuranceNumber,
    String? photoUrl,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
