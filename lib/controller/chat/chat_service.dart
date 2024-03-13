// chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'message.dart'; // Import the Message class

class ChatService {
  Future<void> fetchChats(String token, String url) async {
    final response = await http.get(
      Uri.parse('$url'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var userId = jsonData['user']['id'];
      var chats = jsonData['chats'];
      print('User ID: $userId');
      print('Chats: $chats');
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<List<Message>> fetchMessages(
      String token, String chatId, String url) async {
    final response = await http.get(
      Uri.parse('$url/$chatId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("fetchMessages : ${url}/${chatId}/$token");

    if (response.statusCode == 200) {
      List<Message> _messages = [];
      if (response.body.isNotEmpty) {
        var jsonData = jsonDecode(response.body);
        for (var message in jsonData) {
          _messages.add(Message.fromJson(message));
        }
      }
      return _messages; // Return the list of messages
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> postMessage(
      String token, String chatId, String message, String url) async {
    final response = await http.post(
      Uri.parse('$url/$chatId/messages'),
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
      print('Message sent: $message');
    } else {
      print('Failed to send message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to send message');
    }
  }
}
