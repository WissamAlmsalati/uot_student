import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CourseAttendController {
  // Base URL for registering course attendance.
  final String baseUrl =
      'http://192.168.1.105:8000/study-and-exams/api/course-attend/';

  Future<bool> registerCourseAttend(int courseGroupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String accessToken = prefs.getString('access') ?? '';
      final Uri url = Uri.parse(baseUrl);

      // Construct the body without a student field
      final Map<String, dynamic> body = {
        'course_group': courseGroupId, // Send the PK (integer)
        'enrolled_at': DateTime.now().toIso8601String(),
      };

      // Log request details for debugging purposes
      print("Sending POST request to: ${url.toString()}");
      print(
          "Request Headers: {Authorization: Bearer $accessToken, Content-Type: application/json, Accept: application/json}");
      print("Request Body: ${jsonEncode(body)}");

      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15)); // Timeout after 15 seconds

      // Log response details as soon as it's received.
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            "Failed to register course attendance: ${response.statusCode} ${response.body}");
      }
    } on SocketException catch (e) {
      print("SocketException: $e");
      throw Exception("No internet connection.");
    } on TimeoutException catch (e) {
      print("TimeoutException: $e");
      throw Exception("The request timed out. Please try again.");
    } catch (error) {
      print("Unexpected error: $error");
      throw Exception("An unexpected error occurred: $error");
    }
  }
}
