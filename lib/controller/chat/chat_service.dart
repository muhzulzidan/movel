// chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'message.dart'; // Import the Message class

class ChatService {
  final String baseUrl = 'https://api.movel.id/api/user/passenger';
  final String baseUrlDriver = 'https://api.movel.id/api/user';

  Future<int?> getLatestChatId(String token) async {
    // Make the GET request
    print("chat exists : ${baseUrl}/chats/");
    var response = await http.get(
      Uri.parse('$baseUrl/chats/'), // Replace with your actual endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response : ${response.statusCode}");
    print("response : ${response.body}");

    // Check the response
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      var data = jsonDecode(response.body);
      // If the server returns a chat, return the ID of the latest chat
      if (data != null && data['chats'] is List && data['chats'].isNotEmpty) {
        print("chat exists : true");
        return data['chats'].last['id'];
      } else {
        print("No chats found");
        return null;
      }
    } else {
      // If the server returns an error or no chat, return null
      print("Failed to load chats");
      return null;
    }
  }

  Future<int?> getLatestDriverChatId(String token) async {
    // Make the GET request
    print("chat exists : ${baseUrlDriver}/chats/");
    var response = await http.get(
      Uri.parse('$baseUrlDriver/chats/'), // Replace with your actual endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response : ${response.statusCode}");
    print("response : ${response.body}");

    // Check the response
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      var data = jsonDecode(response.body);
      // If the server returns a chat, return the ID of the latest chat
      if (data != null && data['chats'] is List && data['chats'].isNotEmpty) {
        print("chat exists : true");
        return data['chats'].last['id'];
      } else {
        print("No chats found");
        return null;
      }
    } else {
      // If the server returns an error or no chat, return null
      print("Failed to load chats");
      return null;
    }
  }

  Future<bool> chatExists(String token, int orderId) async {
    // Make the GET request

    print("chat exists : ${baseUrl}/chats/");
    var response = await http.get(
      Uri.parse('$baseUrl/chats/'), // Replace with your actual endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response : ${response.statusCode}");
    print("response : ${response.body}");

    // Check the response
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Map<String, dynamic> data = jsonDecode(response.body);

      // Get the list of chats
      List<dynamic> chats = data['chats'];

      // Check if there's a chat with the specified order ID
      for (var chat in chats) {
        if (chat['order_id'] == orderId) {
          print("Chat exists for order ID: $orderId");
          return true;
        }
      }

      // If no chat with the specified order ID is found, return false
      print("No chat exists for order ID: $orderId");
      return false;
    } else {
      // If the server returns an error, return false
      print("Failed to load chats");
      return false;
    }
  }

  Future<bool> chatExistsDriver(String token, int orderId) async {
    // Make the GET request

    print("chat exists : ${baseUrlDriver}/chats/");
    var response = await http.get(
      Uri.parse('$baseUrlDriver/chats/'), // Replace with your actual endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response : ${response.statusCode}");
    print("response : ${response.body}");

    // Check the response
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Map<String, dynamic> data = jsonDecode(response.body);

      // Get the list of chats
      List<dynamic> chats = data['chats'];

      // Check if there's a chat with the specified order ID
      for (var chat in chats) {
        if (chat['order_id'] == orderId) {
          print("Chat exists for order ID: $orderId");
          return true;
        }
      }

      // If no chat with the specified order ID is found, return false
      print("No chat exists for order ID: $orderId");
      return false;
    } else {
      // If the server returns an error, return false
      print("Failed to load chats");
      return false;
    }
  }

  Future<void> createChat(String token, String driverId) async {
    // Define the data to send
    Map<String, String> data = {
      'receiver_id': driverId.toString(),
      // Add any other data required to create a chat
    };

    // Make the POST request
    var response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    // Check the response
    if (response.statusCode != 201) {
      throw Exception('Could not create chat: ${response.body}');
    }
  }

  Future<void> createChatDriver(String token, String driverId) async {
    // Define the data to send
    Map<String, String> data = {
      'receiver_id': driverId.toString(),
      // Add any other data required to create a chat
    };

    // Make the POST request
    var response = await http.post(
      Uri.parse('$baseUrlDriver/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    // Check the response
    if (response.statusCode != 201) {
      throw Exception('Could not create chat: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchChats(String token, String url) async {
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
      return jsonData; // Return the JSON data
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<void> deleteChat(String token, int chatId, String url) async {
    final response = await http.delete(
      Uri.parse('$url/$chatId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("delete chat $chatId");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete chat');
    }
  }

  Future<List<Message>> fetchMessages(String token, String chatId) async {
    final response = await http.get(
      Uri.parse('$baseUrlDriver/chats/$chatId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("fetchMessages : ${baseUrlDriver}/chats/${chatId}/messages");

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
