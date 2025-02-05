class ExamSchedule {
  final int id;
  final String label;
  final String semesterName;
  final String examType;
  final DateTime examDate;
  final String startTime;
  final String endTime;
  final int course;
  final int semester;

  ExamSchedule({
    required this.id,
    required this.label,
    required this.semesterName,
    required this.examType,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.course,
    required this.semester,
  });

  factory ExamSchedule.fromJson(Map<String, dynamic> json) {
    return ExamSchedule(
      id: (json['id'] as int?) ?? 0,
      label: (json['label'] as String?) ?? '',
      semesterName: (json['semesterName'] as String?) ?? '',
      examType: (json['examType'] as String?) ?? '',
      examDate: DateTime.tryParse(json['examDate'] as String? ?? '') ??
          DateTime(1970, 1, 1),
      startTime: (json['startTime'] as String?) ?? '',
      endTime: (json['endTime'] as String?) ?? '',
      course: (json['course'] as int?) ?? 0,
      semester: (json['semester'] as int?) ?? 0,
    );
  }
}
