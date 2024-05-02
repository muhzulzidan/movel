import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movel/controller/auth/current_index_provider.dart';
import 'package:movel/screens/chat/ChatScreen.dart';
import 'package:movel/screens/pesanan/pesanan_detail.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'chat/inbox.dart';
import "package:movel/controller/chat/chat_service.dart";

class PesananScreen extends StatefulWidget {
  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  // final Function(int) updateSelectedIndex;
  Map<String, dynamic>? orderStatus;
  ChatService chatService = ChatService();
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _fetchOrderStatus();

    socket = IO.io('https://admin.movel.id', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Socket Connected');
    });
    List<String> events = [
      'new_order',
      'order_pick_location',
      'order_pick_location_arrive',
      'order_complete',
      'order_cancel_accept',
      'order_cancel_reject',
      'order_accept',
    ];

    for (var event in events) {
      socket.on(event, (data) {
        print('pesanan screen');
        print('$event event: $data');
        _fetchOrderStatusUpdated();
        // Show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$event'),
            duration: Duration(seconds: 5),
          ),
        );
      });
    }

    socket.connect();
    if (orderStatus != null) {
      Map<String, String> data = {
        'receiver_id': orderStatus!['driver_id'].toString(),
        'order_id': orderStatus!['id_order'].toString(),
      };

      print("pesanan $data");
    }
  }

  Future<int> createChat(String details) async {
    // Check if orderStatus is not null
    if (orderStatus != null) {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // Define the data to send
      Map<String, String> data = {
        'receiver_id': orderStatus!['driver_id'].toString(),
        'details': details,
        'order_id': orderStatus!['id_order'].toString(),
      };

      // Make the POST request
      var response = await http.post(
        Uri.parse('https://api.movel.id/api/user/passenger/chats'),
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
    } else {
      return -1; // Replace -1 with your default value
    }
  }

  Future<void> _fetchOrderStatusUpdated() async {
    final data = await _fetchOrderStatusData();
    print("pesanan fetchorder status data $data");
    if (data != null && mounted) {
      // Check if the widget is still mounted
      setState(() {
        orderStatus = data;
      });
    }
  }

  Future<void> _fetchOrderStatus() async {
    if (orderStatus == null) {
      final data = await _fetchOrderStatusData();
      if (data != null) {
        setState(() {
          orderStatus = data;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchOrderStatusData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      final response = await Requests.get(
        'https://api.movel.id/api/user/orders/passenger/status',
        // Add any required headers here
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.json();
        print("fetchorder status data $responseData");
        return responseData['data'];
      } else {
        return null; // Return null if the request failed
      }
    } catch (e) {
      print("API request error: $e");
      return null;
    }
  }

  // const PesananScreen({Key? key, required this.updateSelectedIndex})
  @override
  Widget build(BuildContext context) {
    print("orderStatus : $orderStatus");

    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Progress Pesanan Anda"),
      ),
      body: (orderStatus == null ||
              orderStatus?['status_order_id'] == 7 ||
              orderStatus?['status_order_id'] == 8 ||
              orderStatus?['status_order_id'] == 0)
          ? Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 100,
                      color: Colors.deepPurple.shade700,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tidak ada pesanan.",
                      style: TextStyle(
                        inherit: false, // Add this line

                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Silakan pesan di layar utama.",
                      style: TextStyle(
                        inherit: false, // Add this line

                        fontSize: 18,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    buildProgressTile(
                      title: "Pesanan Diterima",
                      icon: Icons.bookmark_added,
                      status: 3,
                    ),
                    buildProgressTile(
                      title: "Sopir Menuju ke Lokasi Anda",
                      icon: Icons.directions_run,
                      status: 5,
                    ),
                    buildProgressTile(
                      title: "Sopir Telah Tiba di Lokasi Anda",
                      icon: Icons.directions_car,
                      status: 6,
                    ),
                    buildProgressTile(
                      title: "Anda Telah Tiba di Tujuan",
                      icon: Icons.place,
                      status: 7,
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: buildDriverProfile(context)),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "Promo Hari Ini",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              // buildPromoImage('assets/promo.png'),
            ]),
    );
  }

  Widget buildPromoImage(String imageUrl) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProgressTile(
      {required String title, required int status, required IconData icon}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              color: status == orderStatus?['status_order_id']
                  ? Colors.deepPurple.shade700
                  : Colors.black,
              size: 32, // Adjust the size as needed
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: status == orderStatus?['status_order_id']
                    ? Colors.deepPurple.shade700
                    : Colors.black,
                fontSize: 12,
                // Adjust the font size as needed
              ),
              maxLines: 2,
              textAlign: TextAlign.center, // Align the text to center if needed
              overflow: TextOverflow
                  .ellipsis, // Show ellipsis if the text exceeds two lines
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDriverProfile(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DriverDetailScreen(driverData: orderStatus!),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade500,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                width: 100,
                height: 100,
                child: ClipOval(
                  child: (orderStatus?['driver_photo'] != null &&
                          orderStatus?['driver_photo'] != '')
                      ? Image.network(
                          orderStatus?['driver_photo'],
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/placeholderPhoto.png'),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    " ${orderStatus?['driver_name']} ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    " ${orderStatus?['car_plate_number']}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 4,
                      minimumSize:
                          Size(double.infinity, 0), // Fill available width
                    ),
                    onPressed: () {
                      // Show confirmation modal
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: AlertDialog(
                              content: Text(
                                "Yakin ingin membatalkan pesanan?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              buttonPadding: EdgeInsets.zero,
                              actionsPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                              actions: [
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        elevation: 4,
                                      ),
                                      onPressed: () async {
                                        // Close the dialog
                                        Navigator.of(context).pop();

                                        // Show a loading indicator
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        );

                                        // Make the API request
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final token = prefs.getString('token');
                                        final response = await Requests.post(
                                          'https://api.movel.id/api/user/orders/passenger/cancel',
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          },
                                        );

                                        // Dismiss the loading indicator
                                        Navigator.of(context).pop();

                                        if (response.statusCode == 200) {
                                          // Show a success message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Pembatalan sedang ditinjau!"),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          // Show an error message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Gagal membatalkan pesanan!"),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "ya",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        elevation: 4,
                                      ),
                                      onPressed: () {
                                        // User chose not to cancel
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text("Tidak"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Batalkan Pesanan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 1),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 4,
                      minimumSize:
                          Size(double.infinity, 0), // Fill available width
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String token = prefs.getString('token') ?? '';
                      // //
                      // // Get the CurrentIndexProvider
                      // final currentIndexProvider =
                      //     Provider.of<CurrentIndexProvider>(context,
                      //         listen: false);

                      // // Set the _currentIndex to the index of the 'Kotak Masuk' tab
                      // currentIndexProvider.setIndex(
                      //     1); // Set this to the index of the 'Kotak Masuk' tab

                      // Check if a chat already exists
                      bool chatExists = await chatService.chatExists(
                        token,
                      );
                      if (chatExists) {
                        print('Chat already exists');

                        // Get the ID of the latest chat
                        int? latestChatId =
                            await chatService.getLatestChatId(token);
                        if (latestChatId != null) {
                          // Navigate to the ChatScreen for the existing chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: latestChatId.toString(),
                                name: orderStatus!['driver_name'],
                                profilePicture: orderStatus!['driver_photo'],
                                // ...existing code...
                              ),
                            ),
                          );
                        }
                        return;
                      }

                      // // Create a chat
                      int chatId;
                      try {
                        chatId = await createChat(
                            'chat makinnnggg'); // Replace 'Chat details' with your actual chat details
                      } catch (e) {
                        print('Failed to create chat: $e');
                        return;
                      }

                      // Navigate to the ChatScreen and pass the necessary data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatId: chatId.toString(),
                            name: orderStatus!['driver_name'],
                            profilePicture: orderStatus!['driver_photo'],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Chat dengan Sopir pesanan",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.start,
                              maxLines: 1, // Add this line
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 20,
                          ),
                        )
                      ],
                    ),
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
