import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movel/screens/pesanan/pesanan_detail.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/inbox.dart';

class PesananScreen extends StatefulWidget {
  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  // final Function(int) updateSelectedIndex;
  Map<String, dynamic>? orderStatus;

  @override
  void initState() {
    super.initState();
    _fetchOrderStatus();
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
    bool isOrderReceived = orderStatus?['status_order_id'] == 2;
    bool isDriverEnRoute = orderStatus?['status_order_id'] == 4;
    bool isDriverArrived = orderStatus?['status_order_id'] == 5;
    bool isOrderCompleted = orderStatus?['status_order_id'] == 6;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Progres Pesanan Anda"),
      ),
      body: (orderStatus == null)
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
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Navigate to the home screen
                    //     Navigator.of(context).pushNamed(
                    //         '/home'); // Replace '/home' with the route to your home screen
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding:
                    //         EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    //     backgroundColor: Colors.deepPurple.shade700,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(100),
                    //     ),
                    //     elevation: 4,
                    //   ),
                    //   child: Text(
                    //     'Kembali ke Layar Utama',
                    //     style: TextStyle(
                    //         inherit: false, // Add this line
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w700,
                    //         fontSize: 16),
                    //   ),
                    // ),
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
                      isHighlighted: isOrderReceived,
                    ),
                    buildProgressTile(
                      title: "Sopir Menuju ke Lokasi Anda",
                      icon: Icons.directions_run,
                      isHighlighted: isDriverEnRoute,
                    ),
                    buildProgressTile(
                      title: "Sopir Telah Tiba di Lokasi Anda",
                      icon: Icons.directions_car,
                      isHighlighted: isDriverArrived,
                    ),
                    buildProgressTile(
                      title: "Anda Telah Tiba di Tujuan",
                      icon: Icons.place,
                      isHighlighted: isOrderCompleted,
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
      {required String title,
      required IconData icon,
      bool isHighlighted = false}) {
    Color backgroundColor =
        isHighlighted ? Colors.purple : Colors.grey; // Change colors as needed

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // color: backgroundColor,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isHighlighted
                  ? Colors.deepPurple.shade700
                  : Colors.black, // Change icon color based on highlight
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isHighlighted
                    ? Colors.deepPurple.shade700
                    : Colors.black, // Change text color based on highlight
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
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
                    icon: Icon(Icons.cancel),
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
                    onPressed: () {
                      // TODO: Implement chat functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InboxScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Chat dengan Sopir",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.send,
                            color: Colors.blue,
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
