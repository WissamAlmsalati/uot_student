import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/student.dart';

class StudentController {
  // Replace with your proper host
  final String apiUrl = 'http://192.168.1.105:8000/user/api/students/';

  Future<List<Student>> fetchStudents() async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the stored access token; if missing, an empty string is used.
    final String accessToken = prefs.getString('access') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Decode the response using UTF-8 to correctly handle Arabic characters.
    final String jsonString = utf8.decode(response.bodyBytes);
    print("Response status: ${response.statusCode}");
    print("Response body: $jsonString");

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(jsonString);
      List<dynamic> data;

      // Adjust according to your API structure.
      if (jsonData is List) {
        // When the API directly returns a JSON array.
        data = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        // Extract the list of students from the "results" key.
        data = jsonData['results'] as List<dynamic>? ?? [];
      } else {
        throw Exception("Unexpected JSON format");
      }

      print("Parsed students count: ${data.length}");
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load students: ${response.statusCode}");
    }
  }
}
