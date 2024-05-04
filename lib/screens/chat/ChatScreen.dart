import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movel/controller/chat/chat_service.dart';
import 'package:movel/controller/chat/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/cupertino.dart';
import 'package:movel/controller/chat/chat_service.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String name;
  final String profilePicture;
  ChatScreen({
    required this.chatId,
    required this.name,
    required this.profilePicture,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatService = ChatService(); // Create an instance of ChatService
  late IO.Socket socket;
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> chatsData = {};

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

    getToken().then((token) async {
      var data = await chatService.fetchChats(
          token, "https://api.movel.id/api/user/passenger/chats");

      if (mounted) {
        setState(() {
          chatsData = data;
        });
      }

      chatService
          .fetchMessages(
        token,
        widget.chatId,
      )
          .then((messages) {
        if (!_messageController.isClosed) {
          _messageController.add(messages);
        }
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
      print('Received message_sent event: $data');

      getToken().then((token) async {
        var data = await chatService.fetchChats(
            token, "https://api.movel.id/api/user/passenger/chats");

        if (mounted) {
          setState(() {
            chatsData = data;
          });
        }

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
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  // Stream<List<Message>> _messages = Stream.empty();
  StreamController<List<Message>> _messageController =
      StreamController<List<Message>>();
  TextEditingController _textEditingController = TextEditingController();

  void _sendMessage(String message) {
    getToken().then((token) {
      chatService.postMessage(token, widget.chatId, message,
          "https://api.movel.id/api/user/passenger/chats");
    });
    _textEditingController.clear(); // Clear the TextField
  }

  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("chat screen  : ${chatsData}");
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
                  // "test",
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
                    controller: _scrollController,
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index];
                      final isDriver = !message.isDriver;
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
                                  color:
                                      isDriver ? Colors.white : Colors.black87,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _sendMessage(_textEditingController.text);
                    _textEditingController.clear(); // Clear the TextField
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
