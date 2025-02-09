import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendResetPasswordLink(String email) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.movel.id/api/user/forgot_password'),
      body: {'email': email},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Reset password link sent successfully. Please check your email.')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to send reset password link. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Forgot Password'),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Lupa Kata Sandi ?',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Silakan masukkan E-Mail Anda yang telah terdaftar, Kode untuk mengatur ulang kata sandi akan kami kirimkan via E-Mail.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 25),
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
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.black54),
                            hintText: 'Ketikkan E-Mail Anda',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 21, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                )
                              : Text(
                                  'Kirimkan Kode',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17),
                                ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              sendResetPasswordLink(email);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
