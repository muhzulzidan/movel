import 'package:flutter/material.dart';

import '../../controller/auth/auth_state.dart';

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

  TextEditingController get emailController => _emailController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

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
              SizedBox(height: 20,),
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
                      labelText: 'Email',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),

              const SizedBox(height: 25),
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
                child: 
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                   decoration: const InputDecoration(
                    labelText: 'Password',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                // TextField(
                //   controller: _emailController,
                //   decoration: const InputDecoration(
                //     labelText: 'Password',
                //     border: InputBorder.none,
                //     contentPadding:
                //         EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   ),
                // ),
              ),
              
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              Image(
                  image: AssetImage(
                    'assets/images/carLogin.png',
                  ),
                  height: 320),
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

    final email = emailController.text;
    final password = _passwordController.text;

    final result = await _authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (result) {
      Navigator.pushNamed(context, '/home');
    } else {
      // Show an error message to the user
    }
  }
}
