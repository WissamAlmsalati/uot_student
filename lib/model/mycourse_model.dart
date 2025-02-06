// lib/model/mycourse_model.dart
class MyCourse {
  final int id;
  final String studentName;
  final String courseGroupName;
  final int seatsLeft;
  final double srsGrade;
  final double finalGrade;
  final double sumOfGrades;
  final DateTime enrolledAt;
  final int courseGroup;
  final int student;

  MyCourse({
    required this.id,
    required this.studentName,
    required this.courseGroupName,
    required this.seatsLeft,
    required this.srsGrade,
    required this.finalGrade,
    required this.sumOfGrades,
    required this.enrolledAt,
    required this.courseGroup,
    required this.student,
  });

  factory MyCourse.fromJson(Map<String, dynamic> json) {
    return MyCourse(
      id: json['id'],
      studentName: json['studentName'],
      courseGroupName: json['courseGroupName'],
      seatsLeft: json['seatsLeft'],
      srsGrade: (json['srsGrade'] as num).toDouble(),
      finalGrade: (json['finalGrade'] as num).toDouble(),
      sumOfGrades: (json['sumOfGrades'] as num).toDouble(),
      enrolledAt: DateTime.parse(json['enrolledAt']),
      courseGroup: json['courseGroup'],
      student: json['student'],
    );
  }
}
