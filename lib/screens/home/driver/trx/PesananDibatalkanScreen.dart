import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PesananDibatalkanScreen extends StatefulWidget {
  @override
  State<PesananDibatalkanScreen> createState() =>
      _PesananDibatalkanScreenState();
}

class _PesananDibatalkanScreenState extends State<PesananDibatalkanScreen> {
  @override
  void initState() {
    super.initState();
    _fetchRejectedOrders();
  }

  Future<List<dynamic>>? _rejectedOrdersFuture;

  Future<void> _fetchRejectedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final url = 'https://api.movel.id/api/user/orders/driver/rejected';
      final headers = {
        'Accept': 'application/json',
        'Authorization':
            'Bearer $token', // Replace <token> with the actual token
      };

      final response = await Requests.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = response.json();
        final rejectedOrders = jsonData['data'] ??
            []; // If jsonData['data'] is null, assign an empty list

        setState(() {
          _rejectedOrdersFuture = Future.value(rejectedOrders);
        });
      } else {
        print(response.body);
        print(response.json());
        // throw Exception('Failed to fetch rejected orders');
      }
    } catch (e) {
      setState(() {
        _rejectedOrdersFuture = Future.error(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Pesanan Dibatalkan'),
          ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pesanan dibatalkan!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FutureBuilder<List<dynamic>>(
                    future: _rejectedOrdersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final rejectedOrders = snapshot.data!;
                        if (rejectedOrders.isEmpty) {
                          // Check if the list is empty
                          return Column(
                            children: [
                              Center(
                                  child: Text('Belum ada pesanan dibatalkan')),
                            ],
                          );
                        }
                        return Column(
                          children: rejectedOrders.map((order) {
                            final name = order['passenger_name'];
                            final location = order['kota_tujuan'];

                            return Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.shade100,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          location,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16), // Add a gap of 16 pixels
                              ],
                            );
                          }).toList(),
                        );
                      } else {
                        return Text('No cancelled orders');
                      }
                    },
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: [
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.deepPurple.shade100,
            //           elevation: 4,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //         ),
            //         onPressed: () {},
            //         child: Padding(
            //           padding: EdgeInsets.all(16),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 'Alif',
            //                 style: TextStyle(
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               SizedBox(width: 8),
            //               Text(
            //                 'BTN Pepabri',
            //                 style: TextStyle(
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       SizedBox(height: 16),
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.deepPurple.shade100,
            //           elevation: 4,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //         ),
            //         onPressed: () {},
            //         child: Padding(
            //           padding: EdgeInsets.all(16),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 'Zidan',
            //                 style: TextStyle(
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               SizedBox(width: 8),
            //               Text(
            //                 'Perumnas Tibojong',
            //                 style: TextStyle(
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
