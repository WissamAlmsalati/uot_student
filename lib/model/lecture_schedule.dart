class LectureSchedule {
  final int id;
  final String label;
  final int day;
  final String startTime;
  final String endTime;
  final int classroom;
  final int courseGroup;

  LectureSchedule({
    required this.id,
    required this.label,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.classroom,
    required this.courseGroup,
  });

  factory LectureSchedule.fromJson(Map<String, dynamic> json) {
    return LectureSchedule(
      id: json['id'],
      label: json['label'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      classroom: json['classroom'],
      courseGroup: json['courseGroup'],
    );
  }
}