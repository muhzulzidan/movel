import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../driver_home.dart';

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                ": $value",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class PesananBaruScreen extends StatefulWidget {
  final List<dynamic> newOrders;

  PesananBaruScreen({
    required this.newOrders,
  });

  @override
  State<PesananBaruScreen> createState() => _PesananBaruScreenState();
}

bool _acceptButtonEnabled = true;
bool _rejectButtonEnabled = true;

class _PesananBaruScreenState extends State<PesananBaruScreen> {
  Future<void> acceptOrder(BuildContext context, int orderId) async {
    setState(() {
      _acceptButtonEnabled = false;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = 'https://api.movel.id/api/user/orders/$orderId/driver/accept';
    final headers = {
      'Authorization': 'Bearer $token', // Replace <token> with the actual token
    };

    final response = await Requests.put(url, headers: headers);

    if (response.statusCode == 200) {
      // Order accepted successfully
      print(response.json());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomeDriverPage()),
      );
    } else {
      // Failed to accept the order
      print(response.json());
      throw Exception('Failed to accept the order');
    }

    setState(() {
      _acceptButtonEnabled = true;
    });
  }

  Future<void> rejectOrder(BuildContext context, int orderId) async {
    setState(() {
      _rejectButtonEnabled = false;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = 'https://api.movel.id/api/user/orders/$orderId/driver/reject';
    final headers = {
      'Authorization': 'Bearer $token', // Replace <token> with the actual token
    };

    final response = await Requests.put(url, headers: headers);

    if (response.statusCode == 200) {
      // Order rejected successfully
      print(response.json());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomeDriverPage()),
      );
    } else {
      // Failed to reject the order
      print(response.json());
      throw Exception('Failed to reject the order');
    }

    setState(() {
      _rejectButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("PesananBaruScreen : ${widget.newOrders[0]}");
    print("PesananBaruScreen : ${widget.newOrders[0]["id"]}");
    // print("PesananBaruScreen : ${acceptedOrders['passenger_name']}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Baru'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Image.asset(
                      'assets/konfirmasiCars.png',
                      // fit: BoxFit.,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child:

                                // Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                // children: acceptedOrders.map<Widget>((order) {
                                // return
                                Card(
                              color: Colors.deepPurple.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomRow(
                                      label: 'Nama',
                                      value: widget.newOrders[0]
                                          ['passenger_name'],
                                    ),
                                    CustomRow(
                                      label: 'Asal Kota',
                                      value: widget.newOrders[0]['kota_asal'],
                                    ),
                                    CustomRow(
                                      label: 'Kota Tujuan',
                                      value: widget.newOrders[0]['kota_tujuan'],
                                    ),
                                    CustomRow(
                                      label: 'Tanggal',
                                      value: widget.newOrders[0]
                                          ['date_departure'],
                                    ),
                                    CustomRow(
                                      label: 'Jam',
                                      value: widget.newOrders[0]
                                          ['time_departure'],
                                    ),
                                    CustomRow(
                                      label: 'Kode Kursi',
                                      value: widget.newOrders[0]
                                              ['label_seat_car']
                                          .join(', '),
                                    ),

                                    // CustomRow(
                                    //   label: 'Jam',
                                    //   value: order['jam'],
                                    // ),
                                    // CustomRow(
                                    //   label: 'Kode Kursi',
                                    //   value: order['kode_kursi'],
                                    // ),
                                    // CustomRow(
                                    //   label: 'Titik Jemput',
                                    //   value: order['titik_jemput'],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            // }).toList(),
                            // )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Implement logic for rejecting the order
                                      rejectOrder(
                                          context, widget.newOrders[0]["id"]);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 13),
                                      backgroundColor: Colors.grey,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    child: Text(
                                      'Tolak',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    // onPressed: () {
                                    //   // Implement logic for accepting the order
                                    //   acceptOrder(context, widget.newOrders[0]["id"]);
                                    // },
                                    onPressed: _acceptButtonEnabled
                                        ? () {
                                            // Implement logic for accepting the order
                                            acceptOrder(context,
                                                widget.newOrders[0]["id"]);
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 13),
                                      backgroundColor: Colors.amber,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    child: Text(
                                      'Terima',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.alarm,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '28 Detik Tersisa',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
