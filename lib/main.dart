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

import 'screens/home/driver/driver_home.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString('token');
  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // print(isLoggedIn);
  initializeDateFormatting('id_ID', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrentIndexProvider(),
      child: MyApp(),
    ),
  );
  // runApp(MyApp(
  // isLoggedIn: isLoggedIn
  //     ));
  // runApp(MyApp());
  Future.delayed(Duration(seconds: 2), () {
    // Remove the splash screen
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  // final bool isLoggedIn;

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
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade700),
          ),
          // home: LoginScreen(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
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
