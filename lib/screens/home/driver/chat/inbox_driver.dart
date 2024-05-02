import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movel/screens/home/driver/chat/ChatScreenDriver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DriverInboxScreen extends StatefulWidget {
  @override
  _DriverInboxScreenState createState() => _DriverInboxScreenState();
}

class _DriverInboxScreenState extends State<DriverInboxScreen> {
  List<dynamic> chats = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      fetchChats('$token').then((fetchedChats) {
        setState(() {
          chats = fetchedChats;
        });
        print("chats :$chats");
      });
    });
  }

  Future<List<dynamic>> fetchChats(String token) async {
    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/chats'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        if (data.containsKey('chats')) {
          return data['chats'];
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Kotak Masuk",
          ),
          // bottom: const TabBar(
          //   labelColor: Colors.black,
          //   tabs: [
          //     Tab(
          //       text: "Terjadwal",
          //     ),
          //     Tab(
          //       text: "Sedang Proses",
          //     ),
          //     Tab(
          //       text: "Riwayat",
          //     ),
          //   ],
          // ),
        ),
        body: chats.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.chat,
                      size: 100.0,
                      color: Colors.deepPurple.shade200,
                    ),
                    Text(
                      'Chat Kosong',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    var chat = chats[index];
                    print("$chat['updated_at']");
                    // Rest of your code...
                  },
                ),
              ),
        // Icon(Icons.directions_car),
        // Icon(Icons.directions_transit),
        // ],
        // ),
      ),
    );
  }
}
