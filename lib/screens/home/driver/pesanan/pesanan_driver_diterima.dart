import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movel/controller/auth/auth_state.dart';
import 'package:movel/controller/chat/chat_service.dart';
import 'package:movel/screens/home/driver/chat/ChatScreenDriver.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'cek_progress_pesanan.dart';

class PesananDriverDiterimaScreen extends StatefulWidget {
  @override
  State<PesananDriverDiterimaScreen> createState() =>
      _PesananDriverDiterimaScreenState();
}

class OrderListItem extends StatelessWidget {
  final String name;
  final String userId;
  final String driverId;
  final int orderid;
  final String pickupLocation;
  final String destination;
  final String orderDate;
  final int statusOrder;
  final Map<String, dynamic> userData;

  const OrderListItem({
    required this.userData,
    required this.name,
    required this.userId,
    required this.driverId,
    required this.orderid,
    required this.pickupLocation,
    required this.destination,
    required this.orderDate,
    required this.statusOrder,
  });

  Future<int> createChat(String details) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    // Define the data to send
    Map<String, String> data = {
      'receiver_id': userId.toString(),
      'details': details,
      'order_id': orderid.toString(),
    };

    // Make the POST request
    var response = await http.post(
      Uri.parse('https://api.movel.id/api/user/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    // Check the response
    if (response.statusCode == 201) {
      print('Chat created successfully');
      var responseBody = json.decode(response.body);
      return responseBody['chat']['id']; // Return the ID of the created chat
    } else {
      throw Exception('Could not create chat: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("orderid : $orderid");
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            'Titik Jemput: $pickupLocation',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 2),
          Text(
            'Tujuan: $destination',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 2),
          Text(
            'Tanggal Pemesanan: $orderDate',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 4), // half of the previous SizedBox
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor: Colors.deepPurple.shade700,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String token = prefs.getString('token') ?? '';

                      // Initialize the ChatService instance
                      final chatService = ChatService();

                      // Check if a chat already exists
                      bool chatExists =
                          await chatService.chatExistsDriver(token, orderid);
                      if (chatExists) {
                        print('Chat already exists');

                        // Get the ID of the latest chat
                        int? latestChatId =
                            await chatService.getLatestDriverChatId(token);
                        if (latestChatId != null) {
                          // Navigate to the ChatScreen for the existing chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreenDriver(
                                chatId: latestChatId.toString(),
                                name: name,
                              ),
                            ),
                          );
                        }
                        return;
                      }

                      // Create a chat
                      int chatId;
                      try {
                        chatId = await createChat("$userData");
                      } catch (e) {
                        print('Failed to create chat: $e');
                        return;
                      }

                      // Navigate to the ChatScreen and pass the necessary data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreenDriver(
                            chatId: chatId.toString(),
                            name: name,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 4), // half of the previous SizedBox
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor: Colors.amber,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () {
                      // Implement progress check functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CekDetailPesananScreen(
                                  orderid: orderid,
                                  pickupLocation: pickupLocation,
                                  name: name,
                                  destination: destination,
                                  orderDate: orderDate,
                                  statusOrder: statusOrder,
                                )),
                      );
                    },
                    child: Text(
                      'Cek Progres Pesanan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _PesananDriverDiterimaScreenState
    extends State<PesananDriverDiterimaScreen> {
  late Future<List<dynamic>> _acceptedOrdersFuture = Future.value([]);
  late IO.Socket socket;
  late WebSocketChannel channel;
  bool _hasAcceptedOrders = true;
  String _userName = '';
  late Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _acceptedOrdersFuture = _fetchAcceptedOrders();
    _loadUserData();
    socket = IO.io('https://admin.movel.id', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected order_complete PesananDriverDiterimaScreen websocket');
    });

    socket.on('order_complete', (data) async {
      print('order_complete PesananDriverDiterimaScreen event: $data');
      setState(() {
        _acceptedOrdersFuture = _fetchAcceptedOrders();
      });
    });

    socket.connect();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    late String _token;

    Future<void> _getSharedPrefrences() async {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token') ?? '';
    }

    try {
      final userService = UserService();
      final user = await userService.getUser();
      print("PesananDriverDiterimaScreen user : $user");
      setState(() {
        // _userName = user["user"]["name"].toString();
        _userName = user[0]['name'].toString();

        userData = user[0];
      });
      print('profile testtt');
      print(_userName);
      print("user data PesananDriverDiterimaScreen: $userData");
    } catch (e) {
      print("dari profil : $e");
    }
  }

  Future<List<dynamic>> _fetchAcceptedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final url = 'https://api.movel.id/api/user/orders/driver/accepted';
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Requests.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = response.json();
        if (jsonData['status'] == false &&
            jsonData['message'] == 'Order tidak ditemukan') {
          setState(() {
            _hasAcceptedOrders = false;
          });
          return [];
        } else {
          final acceptedOrders = jsonData['data'];
          setState(() {
            _hasAcceptedOrders = acceptedOrders.isNotEmpty;
          });
          return acceptedOrders;
        }
      } else {
        print("Failed to fetch accepted orders");
        print(response.body);
        print(response.json());
        return []; // Return an empty list if the status code is not 200
      }
    } catch (e) {
      print(e);
      return []; // Return an empty list if an exception is thrown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.only(left: 20),
            child: Text('Pesanan yang asd Sudah Diterima')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<dynamic>>(
            future: _acceptedOrdersFuture,
            builder: (context, snapshot) {
              if (!_hasAcceptedOrders) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        size: 100.0,
                        color: Colors.deepPurple.shade700,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: 180, // Set the width to your desired value
                        child: Text(
                          'Tidak ada pesanan yang diterima',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final acceptedOrders = snapshot.data!;
                if (acceptedOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.inbox,
                          size: 100.0,
                          color: Colors.deepPurple.shade200,
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: 180, // Set the width to your desired value
                          child: Text(
                            'Tidak ada pesanan yang diterima',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: acceptedOrders.length,
                    itemBuilder: (context, index) {
                      final order = acceptedOrders[index];
                      final orderId = order['id'];
                      final name = order['passenger_name'];
                      final userId = order['passenger_id'].toString();
                      final pickupLocation = order['kota_asal'];
                      final destination = order['kota_tujuan'];
                      final orderDate = order['date_order'];
                      final statusOrder = order['status_order'];
                      print("pesanan driver diterima : $acceptedOrders");
                      return Column(
                        children: [
                          OrderListItem(
                            statusOrder: statusOrder,
                            orderid: orderId,
                            name: name,
                            driverId: userData['id'].toString(),
                            userId: userId,
                            pickupLocation: pickupLocation,
                            destination: destination,
                            orderDate: orderDate,
                            userData: userData,
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.inbox,
                        size: 100.0,
                        color: Colors.deepPurple.shade200,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: 180, // Set the width to your desired value
                        child: Text(
                          'Tidak ada pesanan yang diterima',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
