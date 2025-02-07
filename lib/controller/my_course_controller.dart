import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_students/services/base_url.dart';
import '../model/mycourse_model.dart';

class MyCourseController {
  // Ensure there is no extra space in the URL.
  final String apiUrl = '${BaseUrl.baseUrl}study-and-exams/api/course-attend/';

  Future<List<MyCourse>> fetchCourses() async {
    // Retrieve the access token from SharedPreferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access') ?? '';

    print('Fetching courses from: $apiUrl with token: $accessToken');

    // Send the token in the header.
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Use utf8.decode on response.bodyBytes to correctly decode Arabic characters.
    final decodedBody = utf8.decode(response.bodyBytes);
    print('Response status: ${response.statusCode}');
    print('Response body: $decodedBody');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(decodedBody);
      // Convert each JSON object into a MyCourse instance.
      return jsonList.map((json) => MyCourse.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل المواد: ${response.statusCode}');
    }
  }
}