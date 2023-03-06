// import 'dart:convert';

// import 'package:movel/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:movel/network/api.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginController extends GetxController {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   Future<void> loginWithEmail() async {
//     var headers = {'Content-Type': 'application/json'};
//     try {
//       var url = Uri.parse(
//           ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
//       Map body = {
//         'email': emailController.text.trim(),
//         'password': passwordController.text
//       };
//       http.Response response =
//           await http.post(url, body: jsonEncode(body), headers: headers);

//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json['code'] == 0) {
//           var token = json['data']['Token'];
//           final SharedPreferences? prefs = await _prefs;
//           await prefs?.setString('token', token);

//           emailController.clear();
//           passwordController.clear();
//           Get.offAll(HomeScreen());
//         } else if (json['code'] == 1) {
//           throw jsonDecode(response.body)['message'];
//         }
//       } else {
//         throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
//       }
//     } catch (error) {
//       Get.back();
//       showDialog(
//           context: Get.context!,
//           builder: (context) {
//             return SimpleDialog(
//               title: Text('Error'),
//               contentPadding: EdgeInsets.all(20),
//               children: [Text(error.toString())],
//             );
//           });
//     }
//   }
// }

import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  TextEditingController get emailController => _emailController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Perform login logic here, such as making a network request
    // and storing authentication data in a state management system.

    setState(() {
      _isLoading = false;
    });

    // Navigate to the home screen after successful login
    Navigator.pushNamed(context, '/home');
  }
}
