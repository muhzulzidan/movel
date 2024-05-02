import 'dart:async';
import '../../../../controller/chat/message.dart';
import '../../../../controller/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ChatScreenDriver extends StatefulWidget {
  final String chatId;
  final String name;
  final String profilePicture;

  ChatScreenDriver(
      {required this.chatId, required this.name, required this.profilePicture});

  @override
  _ChatScreenDriverState createState() => _ChatScreenDriverState();
}

class _ChatScreenDriverState extends State<ChatScreenDriver> {
  late IO.Socket socket;
  final chatService = ChatService(); // Create an instance of ChatService
  final ScrollController _scrollController = ScrollController();

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    getToken().then((token) {
      chatService.fetchChats(token,
          "https://api.movel.id/api/user/chats"); // Use the ChatService instance
      chatService
          .fetchMessages(
        token,
        widget.chatId,
      )
          .then((messages) {
        _messageController.add(messages);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      });
    });

    connectToServer();

    print("widget chatId : ${widget.chatId}");
    print("messages : ${_messageController}");
  }

  void connectToServer() {
    socket = IO.io('https://admin.movel.id/', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    socket.on('message_sent', (data) {
      print('Received message_sent driver event: $data');

      getToken().then((token) {
        chatService.fetchChats(token,
            "https://api.movel.id/api/user/chats"); // Use the ChatService instance
        chatService
            .fetchMessages(
          token,
          widget.chatId,
        )
            .then((messages) {
          _messageController.add(messages);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            }
          });
        });
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  Future<void> postMessage(String token, String chatId, String message) async {
    final response = await http.post(
      Uri.parse('https://api.movel.id/api/user/chats/$chatId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'content': message,
      }),
    );

    print('Message sent: $chatId');
    if (response.statusCode == 201) {
      // If the server returns a 201 CREATED response, the message was sent successfully.
      print('Message sent: $message');
    } else {
      // If the server returns an unsuccessful response code, print the status code and response body for debugging.
      print('Failed to send message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to send message');
    }
  }

  // Stream<List<Message>> _messages = Stream.empty();
  StreamController<List<Message>> _messageController =
      StreamController<List<Message>>();
  TextEditingController _textEditingController = TextEditingController();

  void _sendMessage(String message) {
    // setState(() {
    //   _messages.add(Message(
    //     sender: 'Your Name', // replace with the actual sender's name
    //     content: message,
    //     profilePicture:
    //         'Your Profile Picture URL', // replace with the actual sender's profile picture URL
    //     isDriver: true, // replace with the actual sender's role
    //   ));
    //   _textEditingController.clear();
    // });

    // Send the message to the server.
    getToken().then((token) {
      postMessage(token, widget.chatId, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        title: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // BackButton(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ), // Adjust the padding as needed
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget
                      .profilePicture), // Display the sender's profile picture
                ),
              ),
              Flexible(
                child: Text(
                  widget.name,
                  style: TextStyle(color: Colors.white),
                ), // Display the sender's name
              ),
            ],
          ),
        ),
        titleSpacing: 0,
        // leadingWidth: 50,
        leading: BackButton(
          color: Colors.white, // Set the color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _messageController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final message = snapshot.data![index];
                        final isDriver = message.isDriver;
                        final createdAt = message.created_at != null
                            ? DateFormat('kk:mm ')
                                .format(DateTime.parse(message.created_at!))
                            : 'Date not available';

                        return Container(
                          alignment: isDriver
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDriver
                                  ? Colors.deepPurple.shade700
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: isDriver
                                    ? Radius.circular(15)
                                    : Radius.circular(0),
                                bottomRight: isDriver
                                    ? Radius.circular(0)
                                    : Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isDriver
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDriver
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _sendMessage(_textEditingController.text ?? '');
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
