class CourseGroup {
  final int id;
  final int group;
  final int maxSeats;
  // Add other fields if needed, for example:
  // final String courseName;
  // final String semesterName;
  // final String professorName;
  // final int seatsLeft;
  // final bool available;
  // final int course;
  // final int semester;
  // final int professor;

  CourseGroup({
    required this.id,
    required this.group,
    required this.maxSeats,
    // Initialize other fields if added:
    // required this.courseName,
    // required this.semesterName,
    // required this.professorName,
    // required this.seatsLeft,
    // required this.available,
    // required this.course,
    // required this.semester,
    // required this.professor,
  });

  factory CourseGroup.fromJson(Map<String, dynamic> json) {
    return CourseGroup(
      id: json['id'],
      group: json['group'],
      maxSeats: json['maxSeats'],
      // Map other fields accordingly:
      // courseName: json['courseName'],
      // semesterName: json['semesterName'],
      // professorName: json['professorName'],
      // seatsLeft: json['seatsLeft'],
      // available: json['available'],
      // course: json['course'],
      // semester: json['semester'],
      // professor: json['professor'],
    );
  }
}
