import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:movel/screens/auth/login.dart';
import 'package:movel/screens/auth/register.dart';
import 'package:movel/screens/home.dart';
import 'package:movel/screens/auth/intro.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  Future.delayed(Duration(seconds: 2), () {
    // Remove the splash screen
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Movel : Mobil Travel',
        theme: ThemeData(
          fontFamily: 'Poppins',
          useMaterial3: true,
          scaffoldBackgroundColor: HexColor("#F2F2F2"),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        // home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
