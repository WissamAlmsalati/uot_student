import 'package:flutter/material.dart';
import '../controller/course_controller.dart';
import '../controller/course_group_controller.dart';
import '../controller/course_attend_controller.dart';
import '../model/course.dart';
import '../model/course_group.dart';

class RegisterCourseScreen extends StatefulWidget {
  const RegisterCourseScreen({Key? key}) : super(key: key);

  @override
  State<RegisterCourseScreen> createState() => _RegisterCourseScreenState();
}

class _RegisterCourseScreenState extends State<RegisterCourseScreen> {
  late Future<List<Course>> _coursesFuture;
  Future<List<CourseGroup>>? _groupsFuture;
  final CourseController _courseController = CourseController();
  Course? _selectedCourse;
  CourseGroup? _selectedGroup;
  final TextEditingController _courseTextController = TextEditingController();

  // Added state variable to track loading state.
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseController.fetchCourses();
  }

  @override
  void dispose() {
    _courseTextController.dispose();
    super.dispose();
  }

  /// Shows a dialog with a search field and a list of courses.
  Future<Course?> _showCourseSearchDialog(List<Course> courses) async {
    return showDialog<Course>(
      context: context,
      builder: (context) {
        String searchText = "";
        List<Course> filteredCourses = courses;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Search Course"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        searchText = text;
                        filteredCourses = courses
                            .where((c) => c.name
                                .toLowerCase()
                                .contains(searchText.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search",
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200, // Limits height to roughly show 4 items.
                    child: ListView.builder(
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return ListTile(
                          title: Text(course.name),
                          onTap: () => Navigator.of(context).pop(course),
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register For a Course"),
      ),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No courses found"));
          } else {
            final courses = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select a Course",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Text field acting as a combo box.
                    GestureDetector(
                      onTap: () async {
                        Course? course = await _showCourseSearchDialog(courses);
                        if (course != null) {
                          setState(() {
                            _selectedCourse = course;
                            _courseTextController.text = course.name;
                            // Create the groups future only once when the course is set.
                            _groupsFuture = CourseGroupController()
                                .fetchCourseGroup(course.id);
                            // Clear the previous group selection.
                            _selectedGroup = null;
                          });
                          print("Selected course: ${course.name}");
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _courseTextController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Select a course",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedCourse != null && _groupsFuture != null)
                      FutureBuilder<List<CourseGroup>>(
                        future: _groupsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            final groups = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Select a Group",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: groups.length,
                                  itemBuilder: (context, index) {
                                    final group = groups[index];
                                    bool isSelected = _selectedGroup != null &&
                                        _selectedGroup!.group == group.group;
                                    return ListTile(
                                      title: Text(
                                          "Group: ${group.group}   Max Seats: ${group.maxSeats}"),
                                      trailing: isSelected
                                          ? const Icon(Icons.check_circle,
                                              color: Colors.green)
                                          : const Icon(Icons.circle_outlined),
                                      onTap: () {
                                        setState(() {
                                          _selectedGroup = group;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    const SizedBox(height: 20),
                    // Customized Register button with loading indicator.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          elevation: 5,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (_selectedCourse != null &&
                                _selectedGroup != null &&
                                !_isRegistering)
                            ? () async {
                                setState(() {
                                  _isRegistering = true;
                                });
                                try {
                                  bool success = await CourseAttendController()
                                      .registerCourseAttend(_selectedGroup!.id);
                                  if (success) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text(
                                            "Registration Successful"),
                                        content: const Text(
                                            "Your registration was successful."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                } catch (error) {
                                  print("Registration failed: $error");
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Registration Failed"),
                                      content: Text("Error: $error"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"),
                                        )
                                      ],
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isRegistering = false;
                                  });
                                }
                              }
                            : null,
                        child: _isRegistering
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Register"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
