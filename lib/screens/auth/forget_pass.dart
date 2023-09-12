import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
                      SizedBox(
                        height: 20,
                      ),
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
                      SizedBox(
                        height: 15,
                      ),
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
                            // if (value?.isEmpty) {
                            //   return 'Please enter your email';
                            // }
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
                          child: Text(
                            'Kirimkan Kode',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 17),
                          ),
                          onPressed: () {
                            // if (_formKey.currentState.validate()) {
                            //   // TODO: Implement reset password logic
                            // }
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
                    // Column(
                    //   children: [
                    //     Text("Tidak punya akun?"),
                    //     TextButton(
                    //         onPressed: () {
                    //           // Navigator.push(
                    //           //   context,
                    //           //   MaterialPageRoute(
                    //           //       builder: (context) => RegisterScreen()),
                    //           // );
                    //         },
                    //         style: ElevatedButton.styleFrom(
                    //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //           minimumSize: Size.zero,
                    //           padding: EdgeInsets.zero,
                    //           backgroundColor: Colors.transparent,
                    //         ),
                    //         child: Text("Daftar"))
                    //   ],
                    // ),
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
