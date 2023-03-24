import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:movel/screens/auth/login.dart';

import '../../controller/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  // final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Login'),
          ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintText: 'Name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintText: 'E-Mail',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintText: 'No. Handphone',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: !_passwordVisible,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintText: 'Kata Sandi',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple[900],
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: !_passwordVisible,
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintText: 'Konfirmasi Kata Sandi',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple[900],
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                          ),
                          child: Text(
                            "Lupa kata sandi ?",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          backgroundColor: Colors.amber,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: _isLoading ? null : register,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Daftar',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Sudah punya akun?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text("Masuk"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    setState(() {
      _isLoading = true;
    });

    final String name = _nameController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String password_confirmation = _passwordController.text.trim();

    // final result = await _authService.login(email, password);

    // Perform validation on the input fields
    // if (name.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please enter your name')),
    //   );
    //   _isLoading = false;
    //   return;
    // }

    // if (phoneNumber.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please enter your phone number')),
    //   );
    //   _isLoading = false;
    //   return;
    // }

    // if (email.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please enter your email')),
    //   );
    //   _isLoading = false;
    //   return;
    // }

    // if (password.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please enter your password')),
    //   );
    //   _isLoading = false;
    //   return;
    // }

    // if (password != password_confirmation) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Passwords do not match')),
    //   );
    //   _isLoading = false;
    //   return;
    // }

    // if (password_confirmation.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please enter your password')),
    //   );
    //   _isLoading = false;
    //   return;
    // }

    // Send the registration data to your backend server
    // and wait for the response
    final response = await http
        .post(Uri.parse('https://admin.movel.id/api/user/register'), body: {
      'name': "zidan",
      'tc': "true",
      'no_hp': "08243324234",
      'email': "zidan8@gmail.com",
      'password': "zidan100",
      'password_confirmation': "zidan100",
      // 'name': name,
      // 'tc': "true",
      // 'no_hp': phoneNumber,
      // 'email': email,
      // 'password': password,
      // 'password_confirmation': password_confirmation,
    });

    String message = '';
    final jsonResponse = jsonDecode(response.body);

    if (jsonResponse.containsKey('token')) {
      // Registration was successful
      print("success");
      print(jsonResponse);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Success')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else if (response.statusCode == 200 &&
        jsonResponse.containsKey('status') &&
        jsonResponse['status'] == 'failed') {
      // Registration failed
      print("status failed");
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${jsonResponse['message']}')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    } else {
      // Unexpected response
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Failed')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
    // if (response.statusCode == 200) {
    //   final jsonResponse = jsonDecode(response.body);

    // } else {
    //   final jsonResponse = jsonDecode(response.body);
    //   print(jsonResponse);
    //   print(response.body);
    //   print("gagal hhttpnya");
    //   // HTTP request failed
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Registration failed')),
    //   );
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => RegisterScreen()),
    //   );
    // }

    // Check the response status code
    // if (response.statusCode == 200) {
    //   final jsonResponse = jsonDecode(response.body);
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(content: Text('${jsonResponse['message']}')),
    //   // );
    //   if (jsonResponse['status'] == "failed") {
    //     print("failed");
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('${jsonResponse['message']}')),
    //     );
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => RegisterScreen()),
    //     );
    //   } else if (jsonResponse['status'] == "success") {
    //     print("success");
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('${jsonResponse['message']}')),
    //     );
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginScreen()),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       // SnackBar(content: Text('${jsonResponse['message']}')),
    //       SnackBar(content: Text('ndak tahu')),
    //     );
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginScreen()),
    //     );
    //   }
    // } else {
    //   final jsonResponse = jsonDecode(response.body);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('${jsonResponse}')),
    //   );
    //   // _isLoading = false;
    //   // return;
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => RegisterScreen()),
    //   );
    // }
  }
}
