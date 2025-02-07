import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:uot_students/services/base_url.dart';

class AuthController {
  BaseUrl baseUrl = BaseUrl();

  final String loginUrl = '${BaseUrl.baseUrl}user/login/';

  Future<void> login(
    String username,
    String password,
    BuildContext context, {
    VoidCallback? onRetry,
  }) async {
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
            context,
            'خطأ',
            'لم يتم العثور على رمز الدخول.',
            onRetry: onRetry,
          );
          return;
        }

        String accessToken = data['access'];
        print('Access token: $accessToken');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access', accessToken);

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        _showDialog(
          context,
          'خطأ',
          'فشل تسجيل الدخول: ${response.reasonPhrase}',
          onRetry: onRetry,
        );
      }
    } catch (e) {
      _showDialog(
        context,
        'استثناء',
        'حدث خطأ: $e',
        onRetry: onRetry,
      );
    }
  }

  void _showDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onRetry != null) {
                onRetry();
              }
            },
            child: const Text('إعادة المحاولة'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}