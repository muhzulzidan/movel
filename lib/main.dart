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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'screens/home/driver/driver_home.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString('token');
  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // print(isLoggedIn);
  initializeDateFormatting('id_ID', null);
  late int roleId;

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  print('Token: $token'); // Print the value of the token

  if (token != null) {
    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/check-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      roleId = responseBody['role_id'];
      prefs.setBool('isLoggedIn', true);
    } else {
      roleId = 0;
      // Token is not valid
      prefs.remove('token');
      // Set login status to false
      prefs.setBool('isLoggedIn', false);
      print("Token is not valid");
      print("response : ${response.statusCode}");
    }
  } else {
    print("Token is null");
    roleId = 0;
  }

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  print("main dart is log in  $isLoggedIn");
  print('main dart is role id : $roleId');
  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrentIndexProvider(),
      child: MyApp(isLoggedIn: isLoggedIn, roleId: roleId),
    ),
  );

  Future.delayed(Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  // final bool isLoggedIn;
  final bool isLoggedIn;
  final int roleId; // Declare roleId as non-nullable

  MyApp({required this.isLoggedIn, required this.roleId});

  // const MyApp({required this.isLoggedIn});
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
          // key: UniqueKey(),
          builder: (context, child) {
            if (child == null) {
              return Container(); // or throw an error
            }

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child,
            );
          },
          title: 'Movel : Mobil Travel',
          theme: ThemeData(
            fontFamily: 'Poppins',
            // useMaterial3: true,
            scaffoldBackgroundColor: HexColor("#Ffffff"),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              toolbarHeight: 60,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins'),
              elevation: 0,
              // shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
            ),
            // scaffoldBackgroundColor: HexColor("#F2F2F2"),
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
          // home: LoginScreen(),
          debugShowCheckedModeBanner: false,
          initialRoute:
              isLoggedIn ? (roleId == 3 ? '/driver' : '/home') : '/login',
          // home: isLoggedIn ? IntroScreen() : MyHomePage(),
          routes: {
            // '/seat': (context) => ChooseSeatScreen(),
            '/': (context) => IntroScreen(),
            // '/': (context) => MyHomePage(),
            '/home': (context) => MyHomePage(),
            //  "/home": isLoggedIn ? MyHomePage() : LoginScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/driver': (context) => MyHomeDriverPage(),

            // '/profile' : (context) => ProfileScreen(),
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
