import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './auth/auth_screens.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var tokenText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              final SharedPreferences? prefs = await _prefs;
              prefs?.clear();
              Get.offAll(MyApp());
            },
            child: Text(
              'logout',
              style: TextStyle(color: Colors.black),
            ))
      ]),
      body: Center(
        child: Column(
          children: [
            Text('Welcome home asu'),
            ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  // final SharedPreferences? prefs = await _prefs;
                  // print(prefs?.get('message'));
                  final token = prefs.getString('token');
                  // tokenText = token;
                  print(token);
                  setState(() {
                    tokenText = token ?? 'Token not found';
                  });
                },
                child: Text('print token')),
            Center(child: Text('Ini Tokennya : ${tokenText}')),
          ],
        ),
      ),
    );
  }
}
