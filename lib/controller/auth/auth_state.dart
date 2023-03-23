import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthState with ChangeNotifier {
  String _token = '';

  String get token => _token;

  set token(String newToken) {
    _token = newToken;
    notifyListeners();
  }
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

class AuthService {
  static const API_URL = 'https://admin.movel.id/api/user';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$API_URL/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Save authentication data here, such as a JWT token
      final responseData = jsonDecode(response.body);
      final token = responseData['access_token'];
      AuthState()._token = token; // set the token in the state management class
      await saveToken(token); // save the token to storage

      // ... save token to state management system or storage
      return true; // Return true to indicate successful login
    } else {
      return false; // Return false to indicate failed login
    }
  }
}
