import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:movel/screens/auth/register.dart';
import 'package:movel/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth/auth_state.dart';
import '../home/driver/driver_home.dart';
import 'forget_pass.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _passwordVisible = false;

  TextEditingController get emailController => _emailController;
  // final int padding = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        // title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.left,
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
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintText: 'E-Mail / No. Handphone',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
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
                              color: Colors.deepPurple.shade700,
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
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
                    const SizedBox(height: 20),
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
                        onPressed: _isLoading ? null : login,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Masuk',
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
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Image(
                        image: AssetImage(
                          'assets/images/carLogin.png',
                        ),
                        height: 320),
                  ),
                  Column(
                    children: [
                      Text("Tidak punya akun?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                          ),
                          child: Text("Daftar"))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    // final email = emailController.text;
    // final password = _passwordController.text;

    // user
    // final email = "zulzdn@gmail.com";
    // const password = "zidan100";
    // final email = "zidan300@gmail.com";
    // const password = "zidan100";
    final email = "zidan@gmail.com";
    const password = "zidan100";

    // const email = "zulzdn@sopir.com";
    // final email = "zidan@movel.id";
    // final password = "password";

    // sopir
    // final email = "barnas@member.com";
    // final password = "123456";
    // final email = "zidan@movel.id";
    // final password = "zidan2023";
    // final email = "sopirbaru@gmail.com";
    // final password = "12345678";
    // final email = "dodi@gmail.com";
    // final password = "12345678";
    // final email = "bang@gmail.com";
    // final password = "zidan100";

    final result = await _authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    // Future<String> getToken() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final token = prefs.getString('token') ?? '';
    //   print(token);
    //   return token;
    // }

    if (result) {
      // final accessToken = await getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      final roleId = prefs.getInt('roleId');
      print(result);
      print('loginscren role id from login is : $roleId');
      SnackBar(
        content: Text("Login berhasil"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        // behavior: SnackBarBehavior.floating,
      );
      if (roleId == 3) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyHomeDriverPage()));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      }

      // Navigator.pushNamed(context, '/home');
    } else {
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cek Email atau password kamu'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          // behavior: SnackBarBehavior.floating,
        ),
      );
      // Show an error message to the user
    }
  }
}
