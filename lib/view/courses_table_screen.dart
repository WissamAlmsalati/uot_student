import 'package:flutter/material.dart';

class CoursesTableScreen extends StatefulWidget {
  const CoursesTableScreen({Key? key}) : super(key: key);

  @override
  State<CoursesTableScreen> createState() => _CoursesTableScreenState();
}

class _CoursesTableScreenState extends State<CoursesTableScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Courses Table Screen"),
    );
  }
}
