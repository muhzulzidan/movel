// import 'dart:html';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:requests/requests.dart';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

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

// Future<void> saveToken(String token) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', token);
// }

class AuthService {
  Future<void> saveToken(String token) async {
    // Get the SharedPreferences instance.
    final prefs = await SharedPreferences.getInstance();

    // Save the token.
    prefs.setString('token', token);
  }

  // var cookieJar = CookieJar();

  static const apiUrl = 'https://api.movel.id/api/user';

  Future<bool> login(String email, String password) async {
    // final dio = Dio();

    // Add the CookieJar to Dio's HttpClientAdapter
    // dio.interceptors.add(CookieManager(cookieJar));

    try {
      final response = await Requests.post(
        '$apiUrl/login',
        body: {
          'email': email,
          'password': password,
        },
        bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      );

      if (response.statusCode == 200) {
        print("headers : ${response.headers}");
        // print(" this is extra ${response.extra}");

        // Save authentication data here, such as a JWT token
        final responseData = response.json();
        print(" autstte $responseData");
        final token = responseData['token'];
        final roleId = responseData['role_id'];
        print("ini token di authstate : $token");
        print("ini roleid di authstate : $roleId");
        AuthState().token =
            token; // set the token in the state management class
        await saveToken(token); // save the token to storage

      String roleName;
      switch (roleId) {
        case 2:
          roleName = "passenger";
          break;
        case 3:
          roleName = "driver";
          break;
        default:
          roleName = "unknown";
          break;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('roleId', roleId);

      // print("$token");
      // ... save token to state management system or storage
      return true; // Return true to indicate successful login
    } else {
      return false; // Return false to indicate failed login
    }
  }
}

// class AuthService {
//   var cookieJar = CookieJar();

//   var client = http.Client();

//   static const API_URL = 'https://api.movel.id/api/user';

//   Future<bool> login(String email, String password) async {

//     final response = await client.post(
//       Uri.parse('$API_URL/login'),
//       body: {
//         'email': email,
//         'password': password,
//       },
//     );

//     if (response.statusCode == 200) {
//       // Save authentication data here, such as a JWT token
//       final responseData = (response.body);
//       print(responseData);
//       final token = responseData['token'];
//       final roleId = responseData['role_id'];
//       // print(roleId);
//       AuthState().token = token; // set the token in the state management class
//       await saveToken(token); // save the token to storage

//       String roleName;
//       switch (roleId) {
//         case 2:
//           roleName = "passenger";
//           break;
//         case 3:
//           roleName = "driver";
//           break;
//         default:
//           roleName = "unknown";
//           break;
//       }

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setInt('roleId', roleId);

//       // print("$token");
//       // ... save token to state management system or storage
//       return true; // Return true to indicate successful login
//     } else {
//       return false; // Return false to indicate failed login
//     }
//   }
// }

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
  // var cookieJar = CookieJar();
  Future<List<dynamic>> getUser() async {
    String token = "";
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print("user seevice : $token");
    // final dio = Dio();

    // Add the CookieJar to Dio's HttpClientAdapter

    // final options = Options(
    //   headers: {
    //     'Authorization': 'Bearer $token',
    //   },
    // );

    final roleId = await prefs.getInt('roleId');
    String url;
    if (roleId == 3) {
      url = 'https://api.movel.id/api/user/driver';
    } else {
      url = 'https://api.movel.id/api/user/passenger';
    }

    final response = await Requests.get(
      url,
      // options: options,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = response.json();
      print("auth state $responseData");
      print(response.headers);
      return responseData;
    } else {
      throw Exception('Failed to get user information');
    }
  }
}
