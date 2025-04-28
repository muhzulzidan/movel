import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:movel/screens/auth/login.dart';
import 'package:movel/screens/auth/register.dart';
import 'package:movel/screens/home/home.dart';
import 'package:movel/screens/auth/intro.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movel/controller/auth/current_index_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'screens/home/driver/driver_home.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:movel/controller/auth/auth_state.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();
  await Hive.openBox('authBox');

  initializeDateFormatting('id_ID', null);

  final authBox = Hive.box('authBox');
  String? token = authBox.get('token');
  final hasSeenIntro = authBox.get('hasSeenIntro', defaultValue: false);

  late int roleId = 0;
  bool isLoggedIn = false;

  if (token != null) {
    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/check-token?token=$token'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      roleId = responseBody['role_id'];
      isLoggedIn = true;
      authBox.put('isLoggedIn', true);
    } else {
      // Try to re-login using saved email and password
      final email = authBox.get('email');
      final password = authBox.get('password');
      if (email != null && password != null) {
        print("start login");
        final authService = AuthService();
        final loginBody = await authService.loginAndGetData(email, password);

        if (loginBody != null) {
          authBox.put('email', email);
          authBox.put('password', password);
          token = loginBody['token'];
          roleId = loginBody['role_id'];
          authBox.put('token', token);
          authBox.put('roleId', roleId);
          isLoggedIn = true;
          authBox.put('isLoggedIn', true);
          print('loginscreen role id from login is : $roleId');
        } else {
          authBox.delete('token');
          authBox.delete('email');
          authBox.delete('password');
          authBox.put('isLoggedIn', false);
        }
      } else {
        authBox.delete('token');
        authBox.put('isLoggedIn', false);
      }
    }
  }

  Widget firstScreen;
  if (!hasSeenIntro) {
    firstScreen = IntroScreen();
  } else if (isLoggedIn) {
    firstScreen = (roleId == 3 ? MyHomeDriverPage() : MyHomePage());
  } else {
    firstScreen = LoginScreen();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrentIndexProvider(),
      child: MyApp(firstScreen: firstScreen),
    ),
  );

  Future.delayed(Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;
  MyApp({required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: GetMaterialApp(
          builder: (context, child) {
            if (child == null) return Container();
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child,
            );
          },
          title: 'Movel : Mobil Travel',
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: HexColor("#Ffffff"),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              toolbarHeight: 60,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins'),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            colorScheme: ColorScheme(
              primary: Colors.deepPurple.shade900,
              secondary: Colors.amber,
              surface: Colors.white,
              background: Colors.white,
              error: Colors.red,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.deepPurple.shade900,
              onError: Colors.red,
              brightness: Brightness.light,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: firstScreen,
          routes: {
            '/home': (context) => MyHomePage(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/driver': (context) => MyHomeDriverPage(),
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
