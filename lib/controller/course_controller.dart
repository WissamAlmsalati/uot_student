import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_students/services/base_url.dart';
import '../model/course.dart';

class CourseController {
  // Replace with your proper host URL if needed
  final String apiUrl = '${BaseUrl.baseUrl}management/api/course-list/';

  Future<List<Course>> fetchCourses() async {
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

    // Decode using UTF-8 to handle special characters properly.
    final String jsonString = utf8.decode(response.bodyBytes);

    print("Response status: ${response.statusCode}");
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(jsonString);
      List<dynamic> data;
      // Check if the API returns a direct JSON array or a wrapped map.
      if (jsonData is List) {
        data = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        data = jsonData['results'] as List<dynamic>? ?? [];
      } else {
        throw Exception("Unexpected JSON format");
      }
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load courses: ${response.statusCode}");
    }
  }
}