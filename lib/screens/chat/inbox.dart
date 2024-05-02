import 'package:flutter/material.dart';
// import 'package:pusher_channels_flutter/pusher-js/core/pusher.dart';

import 'ChatScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:pusher_websocket_flutter/pusher.dart';

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
    // connectToServer(); // Call the connectToServer function
  }

  // void connectToServer() async {
  //  var options = PusherOptions(
  //     host: 'code.movel.id',
  //     port: 6001,
  //     encrypted: false,
  //     cluster: 'ap1',
  //   );

  //   var pusher =
  //       FlutterPusher('320b0a04d5f7bd0a1109', options, enableLogging: true);

  //   pusher.subscribe('test-channel').bind('App\\Events\\MyEvent', (data) {
  //     print('Received event: $data');
  //   });
  // }

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
      body: data == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : data['chats'] != null && data['chats'].isNotEmpty
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
                                    name: chat['receiver']['user_driver']
                                        ['name'],
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
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.inbox,
                        size: 100.0,
                        color: Colors.deepPurple.shade700,
                      ),
                      SizedBox(height: 10.0), // Add space between icon and text
                      Text(
                        'Kotak Masuk Kosong',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ), // Display when empty
    );
  }
}
