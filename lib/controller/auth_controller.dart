import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthController {
  final String loginUrl = 'http://192.168.1.105:8000/user/login/';

  Future<void> login(
      String username, String password, BuildContext context) async {
    final Uri url = Uri.parse(loginUrl);

    try {
      final response = await http.post(url, body: {
        'username': username,
        'password': password,
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['access'] == null) {
          _showDialog(
              context, 'Error', 'Access token not found in the response.');
          return;
        }

        String accessToken = data['access'];
        print('Access token: $accessToken');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access', accessToken);

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        _showDialog(context, 'Error', 'Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showDialog(context, 'Exception', 'An error occurred: $e');
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
