import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_students/services/base_url.dart';
import '../model/course_group.dart';

class CourseGroupController {
  // Base URL for fetching course group by course id.
  final String baseUrl = '${BaseUrl.baseUrl}study-and-exams/api/course-group/course/';

  Future<List<CourseGroup>> fetchCourseGroup(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access') ?? '';
    final String url = '$baseUrl$courseId/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Decode response using UTF-8.
    final String jsonString = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(jsonString);
      List<dynamic> data;
      if (jsonData is List) {
        data = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        // If wrapped in a map, adjust the key if needed.
        data = jsonData['results'] as List<dynamic>? ?? [];
      } else {
        throw Exception("Unexpected JSON format");
      }

      // Map the list of dynamic objects to a List<CourseGroup>.
      return data.map((e) => CourseGroup.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load course group: ${response.statusCode}");
    }
  }
}