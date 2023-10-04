import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cek_progress_pesanan.dart';

class PesananDriverDiterimaScreen extends StatefulWidget {
  @override
  State<PesananDriverDiterimaScreen> createState() =>
      _PesananDriverDiterimaScreenState();
}

class OrderListItem extends StatelessWidget {
  final String name;
  final int orderid;
  final String pickupLocation;
  final String destination;
  final String orderDate;
  final int statusOrder;

  const OrderListItem({
    required this.name,
    required this.orderid,
    required this.pickupLocation,
    required this.destination,
    required this.orderDate,
    required this.statusOrder,
  });

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  backgroundColor: Colors.deepPurple.shade700,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  // Implement chat functionality
                },
                child: Text(
                  'Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
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
                              statusOrder : statusOrder,
                            )),
                  );
                },
                child: Text(
                  'Cek Progres Pesanan',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
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
  @override
  void initState() {
    super.initState();
    _fetchAcceptedOrders();
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
        setState(() {
          _acceptedOrdersFuture = Future.value(acceptedOrders);
        });
        print("pesanan_driver_diterima : $jsonData");
        print(acceptedOrders);
      } else {
        print("Failed to fetch accepted orders");
        print(response.body);
        print(response.json());
        // throw Exception('Failed to fetch accepted orders');
      }
    } catch (e) {
      print(e);
      setState(() {
        _acceptedOrdersFuture = Future.error(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.only(left: 20),
            child: Text('Pesanan yang Sudah Diterima')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<dynamic>>(
            future: _acceptedOrdersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final acceptedOrders = snapshot.data!;

                return ListView.builder(
                  itemCount: acceptedOrders.length,
                  itemBuilder: (context, index) {
                    final order = acceptedOrders[index];
                    final orderId = order['id'];
                    final name = order['passenger_name'];
                    final pickupLocation = order['kota_asal'];
                    final destination = order['kota_tujuan'];
                    final orderDate = order['date_order'];
                    final statusOrder = order['status_order'];

                    return Column(
                      children: [
                        OrderListItem(
                          statusOrder: statusOrder,
                          orderid: orderId,
                          name: name,
                          pickupLocation: pickupLocation,
                          destination: destination,
                          orderDate: orderDate,
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Text('Failed to fetch accepted orders');
              }
            }),
      ),
    );
  }
}
