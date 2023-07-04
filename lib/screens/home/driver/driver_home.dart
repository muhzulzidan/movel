import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:movel/screens/home/driver/driver_home_content.dart';
import 'package:movel/screens/chat/inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './profile/profile.dart';
import 'pesanan/pesanan_baru.dart';
import 'pesanan/pesanan_driver_diterima.dart';

class MyHomeDriverPage extends StatefulWidget {
  // final String userAccessToken;

  // MyHomePage({required this.userAccessToken});
  @override
  _MyHomeDriverPageState createState() => _MyHomeDriverPageState();
}

class _MyHomeDriverPageState extends State<MyHomeDriverPage> {
  int _currentIndex = 0;
  late List<dynamic> _acceptedOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchAcceptedOrders();
  }

  Future<void> _fetchAcceptedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'https://api.movel.id/api/user/orders/driver/accepted';

    final response = await Requests.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = response.json();
      final acceptedOrders = jsonData['data'];
      print("acceptedOrders : $acceptedOrders");
      if (!listEquals(acceptedOrders, _acceptedOrders)) {
        setState(() {
          _acceptedOrders = acceptedOrders;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PesananBaruScreen(acceptedOrders : acceptedOrders)),
          );
          // Send a notification
          _sendNotification();
        });
      }
    } else {
      print('Failed to fetch accepted orders: ${response.statusCode}');
    }
  }

  void _sendNotification() {
    // Implement your logic to send a notification
    // This could be through a package like flutter_local_notifications
    // or by integrating with a push notification service
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => DriverHomeContent(),
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
                builder: (context) => PesananDriverDiterimaScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => DriverProfileScreen(),
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
