// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import './auth/auth_screens.dart';

// import '../main.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   var tokenText;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(actions: [
//         TextButton(
//             onPressed: () async {
//               final SharedPreferences prefs = await _prefs;
//               await prefs.clear();
//               Get.offAll(() => MyApp());
//             },
//             child: Text(
//               'logout',
//               style: TextStyle(color: Colors.black),
//             ))
//       ]),
//       body: Center(
//         child: Column(
//           children: [
//             Text('Welcome home sayang'),
//             ElevatedButton(
//                 onPressed: () async {
//                   final prefs = await SharedPreferences.getInstance();
//                   // final SharedPreferences? prefs = await _prefs;
//                   // print(prefs?.get('message'));
//                   final token = prefs.getString('token');
//                   // tokenText = token;
//                   print(token);
//                   setState(() {
//                     tokenText = token ?? 'Token not found';
//                   });
//                 },
//                 child: Text('print token')),
//             Center(child: Text('Ini Tokennya : ${tokenText}')),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:movel/screens/home/home_content.dart';
import 'package:movel/screens/inbox.dart';
import 'package:movel/screens/pesanan.dart';
import 'package:movel/screens/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  // final String userAccessToken;

  // MyHomePage({required this.userAccessToken});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
// String _userData = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//     Future<void> _fetchUserData() async {
//     final response = await http.get(
//       Uri.parse('https://admin.movel.id/api/user'),
//       headers: {'Authorization': 'Bearer ${widget.userAccessToken}'},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         _userData = data.toString();
//       });
//     }
//   }


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  IndexedStack(
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
