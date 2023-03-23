import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './auth/auth_screens.dart';

// import '../main.dart';

class TokecScreen extends StatefulWidget {
  const TokecScreen({Key? key}) : super(key: key);

  @override
  State<TokecScreen> createState() => _TokecScreenState();
}

class _TokecScreenState extends State<TokecScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var tokenText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              await prefs.clear();
              // Get.offAll(() => MyApp());
            },
            child: Text(
              'logout',
              style: TextStyle(color: Colors.black),
            ))
      ]),
      body: Center(
        child: Column(
          children: [
            Text('Welcome home'),
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
