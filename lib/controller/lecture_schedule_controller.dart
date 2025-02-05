import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/lecture_schedule.dart';

class LectureScheduleController {
  // Replace with your proper host if needed.
  final String apiUrl =
      'http://192.168.1.105:8000/study-and-exams/api/lectures-schdule/';

  Future<List<LectureSchedule>> fetchLectureSchedules() async {
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

    // Use UTF-8 decoding to support non-ASCII characters.
    final String jsonString = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(jsonString);
      List<dynamic> data;
      if (jsonData is List) {
        data = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        // If your API wraps the list in a key (e.g., "results"), adjust it here.
        data = jsonData['results'] as List<dynamic>? ?? [];
      } else {
        throw Exception("Unexpected JSON format");
      }
      return data.map((json) => LectureSchedule.fromJson(json)).toList();
    } else {
      throw Exception(
          "Failed to load lecture schedules: ${response.statusCode}");
    }
  }
}
