import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_students/services/base_url.dart';
import '../model/exam_schedule.dart';

class ExamScheduleController {
  // Replace with your proper host
  final String apiUrl = '${BaseUrl.baseUrl}study-and-exams/api/exams-schedule/';

  Future<List<ExamSchedule>> fetchExamSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Use UTF-8 decoding to support non-ASCII (e.g. Arabic) characters.
    final String jsonString = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(jsonString);
      List<dynamic> data;
      if (jsonData is List) {
        data = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        // You can adjust the key below if your API wraps the list.
        data = jsonData['results'] as List<dynamic>? ?? [];
      } else {
        throw Exception("Unexpected JSON format");
      }
      return data.map((json) => ExamSchedule.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load exam schedules: ${response.statusCode}");
    }
  }
}