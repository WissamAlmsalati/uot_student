import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/student_controller.dart';
import '../model/student.dart';

class StudentTableScreen extends StatefulWidget {
  const StudentTableScreen({Key? key}) : super(key: key);

  @override
  State<StudentTableScreen> createState() => _StudentTableScreenState();
}

class _StudentTableScreenState extends State<StudentTableScreen> {
  late Future<List<Student>> _studentsFuture;
  final StudentController _studentController = StudentController();

  @override
  void initState() {
    super.initState();
    _studentsFuture = _studentController.fetchStudents();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Ensure Arabic (RTL) layout
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
backgroundColor: Colors.grey[100],          title:  Text('تفاصيل الطالب',style: TextStyle(color: Colors.black),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout,color: Colors.black,),
            ),
          ],
        ),
        body: FutureBuilder<List<Student>>(
          future: _studentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Student> students = snapshot.data!;
              if (students.isEmpty) {
                return const Center(child: Text('لم يتم العثور على طالب'));
              }
              // Assuming only one student record exists.
              final student = students.first;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display the student's initial in a large avatar.
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          student.name.isNotEmpty
                              ? student.name[0].toUpperCase()
                              : '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Student Name
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Details Section: Display data in a table-like layout.
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Register Number Row
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'رقم التسجيل:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(student.registerNumber),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Department/Specialization Row
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'التخصص:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                      student.departmentSpecializationName),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('لم يتم العثور على بيانات'));
            }
          },
        ),
      ),
    );
  }
}
