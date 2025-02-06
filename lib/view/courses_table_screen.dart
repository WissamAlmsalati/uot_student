// lib/view/courses_table_screen.dart
import 'package:flutter/material.dart';
import '../controller/my_course_controller.dart'; // Import the renamed controller
import '../model/mycourse_model.dart';              // Import the new model
import 'course_details_screen.dart';

class CoursesTableScreen extends StatefulWidget {
  const CoursesTableScreen({Key? key}) : super(key: key);

  @override
  State<CoursesTableScreen> createState() => _CoursesTableScreenState();
}

class _CoursesTableScreenState extends State<CoursesTableScreen> {
  late Future<List<MyCourse>> _coursesFuture;
  final MyCourseController _courseController = MyCourseController();

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseController.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("المواد")),
      body: FutureBuilder<List<MyCourse>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد مواد"));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(course.courseGroupName),
                    subtitle: Text(course.studentName),
                    trailing: Text("المقاعد: ${course.seatsLeft}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsScreen(course: course),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
