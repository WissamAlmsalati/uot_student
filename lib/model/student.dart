class Student {
  final int id;
  final String registerNumber;
  final String name;
  final String grandFatherName;
  final String motherName;
  final String email;
  final String phone;
  final String? picture;
  final String birthDate;
  final int qualification;
  final String gender;
  final int specialization;
  final String? registerSemester;
  final int identityType;
  final String identity;
  final bool isActive;
  final int state;
  final String departmentSpecializationName;

  Student({
    required this.id,
    required this.registerNumber,
    required this.name,
    required this.grandFatherName,
    required this.motherName,
    required this.email,
    required this.phone,
    this.picture,
    required this.birthDate,
    required this.qualification,
    required this.gender,
    required this.specialization,
    this.registerSemester,
    required this.identityType,
    required this.identity,
    required this.isActive,
    required this.state,
    required this.departmentSpecializationName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: (json['id'] as int?) ?? 0,
      registerNumber: (json['registerNumber'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      grandFatherName: (json['grandFatherName'] as String?) ?? '',
      motherName: (json['motherName'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      picture: json['picture'] as String?,
      birthDate: (json['birthDate'] as String?) ?? '',
      qualification: (json['qualification'] as int?) ?? 0,
      gender: (json['gender'] as String?) ?? '',
      specialization: (json['specialization'] as int?) ?? 0,
      registerSemester: json['registerSemester']?.toString(),
      identityType: (json['identityType'] as int?) ?? 0,
      identity: (json['identity'] as String?) ?? '',
      isActive: (json['isActive'] as bool?) ?? false,
      state: (json['state'] as int?) ?? 0,
      departmentSpecializationName:
          (json['departmentSpecializationName'] as String?) ?? '',
    );
  }
}
