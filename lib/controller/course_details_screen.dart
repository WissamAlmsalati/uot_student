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
    // Check if any required field is missing.
    if (json['id'] == null ||
        json['studentName'] == null ||
        json['courseGroupName'] == null ||
        json['seatsLeft'] == null ||
        json['srsGrade'] == null ||
        json['finalGrade'] == null ||
        json['sumOfGrades'] == null ||
        json['enrolledAt'] == null ||
        json['courseGroup'] == null ||
        json['student'] == null) {
      throw Exception("Missing required field(s) in MyCourse JSON");
    }

    return MyCourse(
      id: json['id'] as int,
      studentName: json['studentName'] as String,
      courseGroupName: json['courseGroupName'] as String,
      seatsLeft: json['seatsLeft'] as int,
      srsGrade: (json['srsGrade'] as num).toDouble(),
      finalGrade: (json['finalGrade'] as num).toDouble(),
      sumOfGrades: (json['sumOfGrades'] as num).toDouble(),
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
      courseGroup: json['courseGroup'] as int,
      student: json['student'] as int,
    );
  }
}
