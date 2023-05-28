import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movel/screens/home/home_content.dart';
import 'package:movel/screens/chat/inbox.dart';
import 'package:movel/screens/pesanan.dart';
import 'package:movel/screens/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movel/controller/auth/current_index_provider.dart';

class MyHomePage extends StatefulWidget {
  // final String userAccessToken;

  // MyHomePage({required this.userAccessToken});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _currentIndex = 0;
// String _userData = '';

  @override
  void initState() {
    super.initState();
    _anjay();
  }

  _anjay() async {
    final prefs = await SharedPreferences.getInstance();
    // final SharedPreferences? prefs = await _prefs;
    // print(prefs?.get('message'));
    final token = prefs.getString('token');
    // tokenText = token;
    print("ini home token get : $token");
  }

  void onTabTapped(int index) {
    final currentIndexProvider =
        Provider.of<CurrentIndexProvider>(context, listen: false);
    currentIndexProvider.setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    final int _currentIndex = currentIndexProvider.currentIndex;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => HomeContentScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => InboxScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => PesananScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, //
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Kotak Masuk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
