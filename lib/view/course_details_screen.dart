// lib/view/course_details_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/mycourse_model.dart';

class CourseDetailsScreen extends StatelessWidget {
  final MyCourse course;

  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the enrolled date for display.
    final String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(course.enrolledAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل المادة"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _detailRow("اسم الطالب", course.studentName),
            _detailRow("اسم المجموعة", course.courseGroupName),
            _detailRow("اعمال السنة", course.srsGrade.toString()),
            _detailRow("الدرجة النهائية", course.finalGrade.toString()),
            _detailRow("مجموع الدرجات", course.sumOfGrades.toString()),
          ],
        ),
      ),
    );
  }

  /// A helper method to build a row displaying a label and its value.
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
