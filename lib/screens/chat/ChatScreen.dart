import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movel/controller/chat/chat_service.dart';
import 'package:movel/controller/chat/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String name;
  final String profilePicture;
  ChatScreen(
      {required this.chatId, required this.name, required this.profilePicture});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatService = ChatService(); // Create an instance of ChatService

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  @override
  void initState() {
    super.initState();
    getToken().then((token) {
      chatService.fetchChats(
          token, "https://api.movel.id/api/user/passenger/chats");
      chatService
          .fetchMessages(token, widget.chatId,
              "https://api.movel.id/api/user/passenger/chats")
          .then((messages) {
        _messageController.add(messages);
      });
    });
    print("widget chatId : ${widget.chatId}");
    print("messages : ${_messageController}");
  }

  // List<String> _messages = [
  //   "Hi, how can I help you?",
  //   "I'd like to book a ride, please.",
  //   "Sure, where are you located?",
  //   "I'm at the airport.",
  //   "Great, I'll send a driver your way.",
  //   "Thank you!",
  // ];

  // Stream<List<Message>> _messages = Stream.empty();
  StreamController<List<Message>> _messageController =
      StreamController<List<Message>>();
  TextEditingController _textEditingController = TextEditingController();

  void _sendMessage(String message) {
    getToken().then((token) {
      chatService.postMessage(token, widget.chatId, message,
          "https://api.movel.id/api/user/passenger/chats");
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
      body: Column(
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
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index];
                      final isDriver = !message.isDriver;
                      print("message : ${message}");
                      // Parse the created_at field and format it
                      final createdAt = message.created_at != null
                          ? DateFormat('kk:mm ')
                              .format(DateTime.parse(message.created_at!))
                          : 'Date not available';

                      return Container(
                        alignment: isDriver
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDriver
                                ? Colors.deepPurple.shade100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                // offset: Offset(0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isDriver
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 0,
                                ),
                                child: Text(
                                  message.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(createdAt,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w800,
                                  )),
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
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _sendMessage(_textEditingController.text);
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
