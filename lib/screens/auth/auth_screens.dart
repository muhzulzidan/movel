// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors
import '../../controller/auth/login_controller.dart';
import '../../controller/auth/register_controller.dart';
import './widget/input_fields.dart';
import './widget/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  RegisterationController registerationController =
      Get.put(RegisterationController());

  LoginController loginController = Get.put(LoginController());
  var isLogin = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Center(
            child: Obx(
              () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: !isLogin.value ? Colors.purple : Colors.white,
                          onPressed: () {
                            isLogin.value = false;
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color:
                                  !isLogin.value ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        MaterialButton(
                          color: isLogin.value ? Colors.purple : Colors.white,
                          onPressed: () {
                            isLogin.value = true;
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color:
                                  isLogin.value ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    isLogin.value ? loginController : registerWidget()
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Column(
      children: [
        InputTextFieldWidget(registerationController.nameController, 'name'),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registerationController.phoneController, 'phone_number'),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registerationController.emailController, 'email address'),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registerationController.passwordController, 'password'),
        SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => registerationController.registerWithEmail(),
          title: 'Register',
        )
      ],
    );
  }

  // Widget loginWidget() {
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
