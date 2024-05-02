import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:movel/screens/home/driver/driver_home_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './profile/profile.dart';
import 'chat/inbox_driver.dart';
import 'pesanan/pesanan_baru.dart';
import 'pesanan/pesanan_driver_diterima.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MyHomeDriverPage extends StatefulWidget {
  // final String userAccessToken;

  // MyHomePage({required this.userAccessToken});
  @override
  _MyHomeDriverPageState createState() => _MyHomeDriverPageState();
}

class _MyHomeDriverPageState extends State<MyHomeDriverPage> {
  late IO.Socket socket;  
  int _currentIndex = 0;
  late List<dynamic> _newOrders = [];

  @override
  void initState() {
    super.initState();
      connectToServer();

    _fetchAcceptedOrders();
  }

    void connectToServer() {
    socket = IO.io('https://admin.movel.id/', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    // Listen for the new_order event
    socket.on('new_order', (data) {
      // Update the list of orders
      print('Received new_order event: $data');
      _fetchAcceptedOrders();
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }


  Future<void> _fetchAcceptedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'https://api.movel.id/api/user/orders/driver/';

    final response = await Requests.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = response.json();
      final status = jsonData['status'];
      final message = jsonData['message'];

      final newOrders = jsonData['data'];
      print("new order : $newOrders");

      if (status == false) {
        print('Failed to fetch accepted orders: $message');
      } else {
        if (!listEquals(newOrders, _newOrders)) {
          print("status true ");
          setState(() {
            _newOrders = newOrders;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PesananBaruScreen(newOrders: _newOrders)),
            );

            // Send a notification
            // _sendNotification();
          });
        }
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
                builder: (context) => DriverInboxScreen(),
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
