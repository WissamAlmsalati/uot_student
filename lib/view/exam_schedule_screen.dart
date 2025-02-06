// lib/view/exam_schedule_week_table_screen.dart
import 'package:flutter/material.dart';
import '../controller/exam_schedule_controller.dart';
import '../controller/lecture_schedule_controller.dart';
import '../model/exam_schedule.dart';
import '../model/lecture_schedule.dart';

class ExamScheduleWeekTableScreen extends StatefulWidget {
  const ExamScheduleWeekTableScreen({Key? key}) : super(key: key);

  @override
  State<ExamScheduleWeekTableScreen> createState() =>
      _ExamScheduleWeekTableScreenState();
}

class _ExamScheduleWeekTableScreenState extends State<ExamScheduleWeekTableScreen> {
  late Future<List<ExamSchedule>> _examSchedulesFuture;
  late Future<List<LectureSchedule>> _lectureSchedulesFuture;
  final ExamScheduleController _examController = ExamScheduleController();
  final LectureScheduleController _lectureController = LectureScheduleController();

  @override
  void initState() {
    super.initState();
    _examSchedulesFuture = _examController.fetchExamSchedules();
    _lectureSchedulesFuture = _lectureController.fetchLectureSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('الجدول الدراسي'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'جدول الامتحانات'),
              Tab(text: 'جدول المحاضرات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExamScheduleTab(),
            _buildLectureScheduleTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildExamScheduleTab() {
    return FutureBuilder<List<ExamSchedule>>(
      future: _examSchedulesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'خطأ في تحميل جدول الامتحانات:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _examSchedulesFuture = _examController.fetchExamSchedules();
                    });
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          List<ExamSchedule> schedules = snapshot.data!;
          if (schedules.isEmpty) {
            return const Center(child: Text('لا يوجد امتحانات متاحة'));
          }
          // Group exam schedules by weekday (1 = Monday, ... , 7 = Sunday)
          Map<int, List<ExamSchedule>> grouped = {};
          for (var exam in schedules) {
            int weekday = exam.examDate.weekday;
            grouped.putIfAbsent(weekday, () => []).add(exam);
          }
          // Ensure every weekday exists (even if empty)
          for (int i = 1; i <= 7; i++) {
            grouped.putIfAbsent(i, () => []);
          }
          // Determine maximum number of rows needed
          int maxRows = grouped.values.fold<int>(
              0, (prev, list) => list.length > prev ? list.length : prev);

          // Define Arabic day names corresponding to weekday numbers (Monday=1)
          List<String> dayNames = [
            'الإثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
            'السبت',
            'الأحد'
          ];

          // Build table rows
          List<TableRow> tableRows = [];

          // Header row with day names
          tableRows.add(
            TableRow(
              decoration: BoxDecoration(color: Colors.blueGrey[100]),
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      dayNames[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
          );

          // Data rows
          for (int row = 0; row < maxRows; row++) {
            List<Widget> rowWidgets = [];
            for (int day = 1; day <= 7; day++) {
              List<ExamSchedule> exams = grouped[day]!;
              Widget cell;
              if (row < exams.length) {
                ExamSchedule exam = exams[row];
                cell = Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          exam.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exam.examType,
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${exam.startTime} - ${exam.endTime}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                cell = Container();
              }
              rowWidgets.add(Padding(
                padding: const EdgeInsets.all(4.0),
                child: cell,
              ));
            }
            tableRows.add(TableRow(children: rowWidgets));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                defaultColumnWidth: const FixedColumnWidth(120.0),
                children: tableRows,
              ),
            ),
          );
        } else {
          return const Center(child: Text('لا يوجد جدول امتحانات'));
        }
      },
    );
  }

  Widget _buildLectureScheduleTab() {
    return FutureBuilder<List<LectureSchedule>>(
      future: _lectureSchedulesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'خطأ في تحميل جدول المحاضرات:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _lectureSchedulesFuture = _lectureController.fetchLectureSchedules();
                    });
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          List<LectureSchedule> lectures = snapshot.data!;
          if (lectures.isEmpty) {
            return const Center(child: Text('لا توجد محاضرات متاحة'));
          }
          // Group lecture schedules by day (1 = Monday, ... , 7 = Sunday)
          Map<int, List<LectureSchedule>> grouped = {};
          for (var lecture in lectures) {
            int day = lecture.day;
            grouped.putIfAbsent(day, () => []).add(lecture);
          }
          for (int i = 1; i <= 7; i++) {
            grouped.putIfAbsent(i, () => []);
          }
          int maxRows = grouped.values.fold<int>(
              0, (prev, list) => list.length > prev ? list.length : prev);

          // Define Arabic day names corresponding to weekday numbers
          List<String> dayNames = [
            'الإثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
            'السبت',
            'الأحد'
          ];

          // Build table rows
          List<TableRow> tableRows = [];

          // Header row with day names
          tableRows.add(
            TableRow(
              decoration: BoxDecoration(color: Colors.blueGrey[100]),
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      dayNames[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
          );

          // Data rows
          for (int row = 0; row < maxRows; row++) {
            List<Widget> rowWidgets = [];
            for (int day = 1; day <= 7; day++) {
              List<LectureSchedule> lecturesOfDay = grouped[day]!;
              Widget cell;
              if (row < lecturesOfDay.length) {
                LectureSchedule lecture = lecturesOfDay[row];
                cell = Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lecture.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'قاعة: ${lecture.classroom}, المجموعة: ${lecture.courseGroup}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${lecture.startTime} - ${lecture.endTime}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                cell = Container();
              }
              rowWidgets.add(Padding(
                padding: const EdgeInsets.all(4.0),
                child: cell,
              ));
            }
            tableRows.add(TableRow(children: rowWidgets));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                defaultColumnWidth: const FixedColumnWidth(120.0),
                children: tableRows,
              ),
            ),
          );
        } else {
          return const Center(child: Text('لا يوجد جدول محاضرات'));
        }
      },
    );
  }
}
