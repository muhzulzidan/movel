import 'package:flutter/material.dart';

import 'ChatScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/passenger/chats'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      // print("data inbox passenger : $data");
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kotak Masuk",
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // )
      ),
      body: data != null && data['chats'] != null && data['chats'].isNotEmpty
          ? ListView.builder(
              itemCount: data['chats'].length,
              itemBuilder: (context, index) {
                var chat = data['chats'][index];
                print("chat pasenger : $chat");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                chatId: chat['id'].toString(),
                                name: chat['receiver']['user_driver']['name'],
                                profilePicture: chat['receiver']['photo']
                                    .replaceFirst('/photos/public', ''),
                              )),
                    );
                  },
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: chat['receiver'] != null
                              ? Image.network(
                                  chat['receiver']['photo']
                                      .replaceFirst('/photos/public', ''),
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                )
                              : Container(), // Placeholder widget
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (chat['receiver'] != null) ...[
                              Text(
                                '${chat['receiver']['user_driver']['name']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                            Text(
                              data != null && data['user'] != null
                                  ? "Halo ${data['user']['name']}"
                                  : 'Loading...', // Placeholder text
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}
