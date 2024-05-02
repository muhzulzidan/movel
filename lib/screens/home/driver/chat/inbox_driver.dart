import 'package:flutter/material.dart';
import 'package:movel/controller/chat/chat_service.dart';
import 'package:movel/screens/home/driver/chat/ChatScreenDriver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DriverInboxScreen extends StatefulWidget {
  @override
  _DriverInboxScreenState createState() => _DriverInboxScreenState();
}

class _DriverInboxScreenState extends State<DriverInboxScreen> {
  Map<String, dynamic> data = {};
  final chatService = ChatService(); // Create an instance of ChatService
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    fetchData();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('https://admin.movel.id/', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    socket.on('chat_created', (data) {
      print('Received chat_created event: $data');
      fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pesan baru diterima!'),
          duration: Duration(seconds: 5),
        ),
      );
    });
    socket.on('chat_updated', (data) {
      print('Received chat_updated event: $data');
      fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pesan diperbarui!'),
          duration: Duration(seconds: 5),
        ),
      );
    });
    socket.on('chat_deleted', (data) {
      print('Received chat_deleted event: $data');
      fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pesan dihapus!'),
          duration: Duration(seconds: 5),
        ),
      );
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/chats'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      print("fetch_data_DriverInboxScreen ${data['chats']?.map((chat) {
            print('Chat status_label: ${chat['status_label']}');
            return chat;
          }).where((chat) => int.parse(chat['status_label'].toString()) != 6).toList()}");
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Kotak Masuk driver",
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'Ongoing'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildChatList(
                data['chats']?.where((chat) {
                      print('Chat status_label: ${chat['status_label']}');
                      return int.parse(chat['status_label'].toString()) != 6;
                    }).toList() ??
                    [],
                data,
                fetchData,
                chatService,
              ),
              _buildChatList(
                data['chats']?.where((chat) {
                      print('Chat status_label: ${chat['status_label']}');
                      return int.parse(chat['status_label'].toString()) == 6;
                    }).toList() ??
                    [],
                data,
                fetchData,
                chatService,
              ),
            ],
          )),
    );
  }
}

Widget _buildChatList(List<dynamic> chatList, dynamic data,
    VoidCallback fetchData, ChatService chatService) {
  return chatList.isNotEmpty
      ? SingleChildScrollView(
          child: Column(
            children: chatList.map((chat) {
              return ChatTile(
                chat: chat,
                data: data,
                fetchData: fetchData,
                chatService: chatService,
              );
            }).toList(),
          ),
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
        ); // Display when empty // Placeholder widget when there are no chats
}

class ChatTile extends StatelessWidget {
  final dynamic chat;
  final dynamic data;
  final VoidCallback fetchData;
  final ChatService chatService;

  ChatTile({
    required this.chat,
    required this.data,
    required this.fetchData,
    required this.chatService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data['chats'].map<Widget>(
        (chat) {
          print("chat driver : ${chat["order"]['status_order_id']}");
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreenDriver(
                          chatId: chat['id'].toString(),
                          name: chat['user']['name'],
                          // profilePicture: chat['receiver']['photo']
                          // .replaceFirst('/photos/public', ''),
                        )),
              );
            },
            title: Row(
              children: [
                Container(
                  width: 50,
                  height: 60,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: chat['user'] != null
                          ? Image.network(
                              chat['user']['passenger']['photo']
                                  .replaceFirst('/photos/public', ''),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : Container(), // Placeholder widget
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data != null) ...[
                        Text(
                          '${chat['user']['name']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                      Text(
                        data != null && data['user'] != null
                            ? "Halo ${chat['user']['name']}"
                            : 'Loading...', // Placeholder text
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        data != null && data['user'] != null
                            ? "${chat["order"]['status_order_id']}"
                            : 'Loading...', // Placeholder text
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade600,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      surfaceTintColor: Colors.white,
                      title: Text('Hapus Chat'),
                      content:
                          Text('Apakah Anda yakin ingin menghapus chat ini?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.red.shade700,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            String token = prefs.getString('token') ?? '';

                            Navigator.of(context).pop();
                            await chatService.deleteChat(
                              token,
                              chat['id'],
                              "https://api.movel.id/api/user/chat",
                            );
                            fetchData();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ).toList(),
    );
  }
}
