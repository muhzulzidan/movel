import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class CekDetailPesananScreen extends StatefulWidget {
  final String name;
  final int orderid;
  final int statusOrder;
  final String pickupLocation;
  final String destination;
  final String orderDate;

  CekDetailPesananScreen({
    required this.name,
    required this.statusOrder,
    required this.orderid,
    required this.pickupLocation,
    required this.destination,
    required this.orderDate,
  });

  @override
  _CekDetailPesananScreenState createState() => _CekDetailPesananScreenState();
}

class _CekDetailPesananScreenState extends State<CekDetailPesananScreen> {
  // late Future<List<dynamic>> _acceptedOrdersFuture = Future.value([]);
  // Map<String, dynamic>? _orderDetails;

  late int _statusOrderFuture = widget.statusOrder;

  @override
  void initState() {
    super.initState();
    // _fetchOrderDetails();
  }

  Future<void> _updatePesanan(String orderid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final url = 'https://api.movel.id/api/user/orders/$orderid/pick_location';
      final response = await Requests.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.json();
        print("jsonData : $jsonData");
        _fetchAcceptedOrders();
      } else {
        _fetchAcceptedOrders();
        throw Exception('Failed to update pesanan');
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }

  Future<void> _tibaDiTitikJemput(String orderid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final url =
          'https://api.movel.id/api/user/orders/$orderid/pick_location_arrive';
      final response = await Requests.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.json();
        print("jsonData : $jsonData");
        _fetchAcceptedOrders();
      } else {
        _fetchAcceptedOrders();
        throw Exception('Failed to update pesanan');
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }

  Future<void> _pesananSelesai(String orderid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final url = 'https://api.movel.id/api/user/orders/$orderid/complete';
      final response = await Requests.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.json();
        print("jsonData : $jsonData");
        _fetchAcceptedOrders();
      } else {
        final jsonData = response.json();
        _fetchAcceptedOrders();
        final message = jsonData['message'];
        // Print some debug information
        print("Showing SnackBar with message: $message");
        print("Using context: $context");
        _showSnackBar(context, message);
        throw Exception('Failed to update pesanan');
      }
    } catch (e) {
      print("error");
      print(e);
      _showSnackBar(context, 'An error occurred');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    // final snackBar = SnackBar(
    //   content: Text(message),
    //   duration: Duration(seconds: 3),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurple.shade700,
        // behavior: SnackBarBehavior.floating,
      ),
    );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _fetchAcceptedOrders() async {
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
        final acceptedOrders = jsonData['data'];
        final filteredOrder = acceptedOrders.firstWhere(
          (order) => order['id'] == widget.orderid,
          orElse: () => null,
        );

        setState(() {
          if (filteredOrder != null) {
            _statusOrderFuture = filteredOrder['status_order'];
          } else {
            _statusOrderFuture = 0;
          }
        });

        // Filter the accepted orders by orderId

        print("detail_pesanan _fetchAcceptedOrders : $filteredOrder");
      } else {
        print("Failed to fetch accepted orders");
        print(response.body);
        print(response.json());
        // throw Exception('Failed to fetch accepted orders');
        throw Exception(response.body);
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_statusOrderFuture);
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Pesanan'),
        ),
        body:
            // _orderDetails != null    ?
            Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  buildProgressTile(
                    status: 3,
                    title: "Pesanan Diterima",
                    icon: Icons.bookmark_add,
                  ),
                  buildProgressTile(
                    status: 5,
                    title: "Menuju ke Lokasi Anda",
                    icon: Icons.directions_run,
                  ),
                  buildProgressTile(
                    status: 6,
                    title: "Telah Tiba di Lokasi Anda",
                    icon: Icons.directions_car,
                  ),
                  buildProgressTile(
                    status: 7,
                    title: "Anda Telah Tiba di Tujuan",
                    icon: Icons.check_circle,
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: buildDriverProfile()),
          ],
        )
        // : Center(
        //     child: CircularProgressIndicator(),
        //   ),
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
              color: status == _statusOrderFuture
                  ? Colors.deepPurple.shade700
                  : Colors.black,
              icon,
              size: 32, // Adjust the size as needed
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: status == _statusOrderFuture
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

  Widget updatepesanan({
    required VoidCallback onPressed,
    required String title,
    required int status,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8),
            backgroundColor:
                status == _statusOrderFuture ? Colors.amber : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            elevation: 4,
            minimumSize: Size(double.infinity, 0), // Fill available width
          ),
          onPressed: onPressed,
          // icon: Icon(Icons.cancel),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 2,
        ),
      ],
    );
  }

  Widget buildDriverProfile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                "assets/placeholderPhoto.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Titik Jemput : ${widget.pickupLocation}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                updatepesanan(
                  status: 5,
                  title: "Menuju ke Titik Jemput",
                  onPressed: () => _updatePesanan("${widget.orderid}"),
                ),
                updatepesanan(
                  status: 6,
                  title: "Tiba di Titik Jemput",
                  onPressed: () => _tibaDiTitikJemput("${widget.orderid}"),
                ),
                updatepesanan(
                  status: 7,
                  title: "Selesai",
                  onPressed: () => _pesananSelesai("${widget.orderid}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
