// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  var isLogin = false.obs;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(36),
                  child: Center(
                    child: Obx(
                      () => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
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
                              height: 10,
                            ),
                            
                            
                          ]),
                    ),
                  ),
                ),
                Image(image: AssetImage('assets/images/carLogin.png', ), height: 320),
              ],
              
            ),

          ),
          
        ],
        
      ),
    );
    
  }

  //   return Column(
  //     children: [
  //       SizedBox(
  //         height: 20,
  //       ),
  //       InputTextFieldWidget(loginController.emailController, 'email address'),
  //       SizedBox(
  //         height: 20,
  //       ),
  //       InputTextFieldWidget(loginController.passwordController, 'password'),
  //       SizedBox(
  //         height: 20,
  //       ),
  //       SubmitButton(
  //         onPressed: () => loginController.loginWithEmail(),
  //         title: 'Login',
  //       )
  //     ],
  //   );
  // }
}
