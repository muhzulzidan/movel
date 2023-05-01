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

  static final AuthState _instance = AuthState._internal();

  factory AuthState() {
    return _instance;
  }

  AuthState._internal();
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

class AuthService {
  static const API_URL = 'https://api.movel.id/api/user';

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
      final token = responseData['token'];
      AuthState().token = token; // set the token in the state management class
      await saveToken(token); // save the token to storage

      // print("$token");
      // ... save token to state management system or storage
      return true; // Return true to indicate successful login
    } else {
      return false; // Return false to indicate failed login
    }
  }
}

bool verifyToken(String token) {
  // Check if the token is not empty
  if (token.isEmpty) {
    return false;
  }

  // Check if the token is still valid
  // Send a request to the API to verify the token
  // If the token is valid, return true
  // If the token is invalid or expired, return false
  // You can implement this logic using the `http` package or any other package for sending HTTP requests.

  return true; // For testing purposes, always return true
}

class UserService {
  // static const API_URL = 'https://admin.movel.id/api/user/';

  Future<Map<String, dynamic>> getUser() async {
    final authState = AuthState();
    final token = authState.token;

    if (!verifyToken(token)) {
      // Token is not valid, handle this case
    }

    print(token);
    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/loggeduser'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      return responseData;
    } else {
      print('${response.statusCode}');
      // print('Failed to get user information. Response body: ${response.body}');
      throw Exception('Failed to get user information');
    }
  }
}
