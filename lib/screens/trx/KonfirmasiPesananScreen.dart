import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pesanan.dart';
import 'OrderProgressScreen.dart';
import 'package:movel/controller/auth/current_index_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
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
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class KonfirmasiPesananScreen extends StatelessWidget {
  final Map<String, dynamic> responseData;

  KonfirmasiPesananScreen({required this.responseData});

  @override
  Widget build(BuildContext context) {
    print("konfirmasi pesanan : $responseData");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // backgroundColor: Colors.deepPurple.shade500,
        centerTitle: true,
        title: Text(
          'Konfirmasi Pesanan',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
          ),
          Positioned(
            right: -30,
            bottom: -30,
            child: Image.asset(
              'assets/konfirmasiCars.png',
              // fit: BoxFit.,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(
                  //   height: 50,
                  // ),
                  Card(
                    color: Colors.deepPurple.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomRow(
                              label: 'Nama Sopir',
                              value: ': ${responseData['driver_name']}',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Umur',
                              value: ': ${responseData['driver_age']}',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Merokok',
                              value: ': ${responseData['is_smoking']}',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Type Mobil',
                              value: ': ${responseData['car_merk']}',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Tahun Mobil',
                              value: ': ${responseData['car_prod_year']}',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Kode Kursi',
                              value:
                                  ': ${responseData['seat_car_choices'].toString()}',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Harga',
                              value:
                                  ': ${responseData['price_order'].toString()}',
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 80,
            right: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13),
                backgroundColor: Colors.amber,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: () async {
                final String apiUrl = 'https://api.movel.id/api/user/orders';
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');
                final driverid = responseData['id'];
                final seatCarChices =
                    responseData['seat_car_choices'].toString();
                print("onpress driver id : $driverid");
                print("onpress seatcarchoices $seatCarChices");
                final requestBody = '''
                  {
                  "driver_departure_id": $driverid,
                  "seat_car_choices": ${seatCarChices}
                  }
                  ''';

                final response = await http.post(
                  Uri.parse(apiUrl),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: requestBody,
                );

                if (response.statusCode == 200) {
                  // Handle successful response here

                  // Update the bottom navigation index by calling the function with the desired index
                  final currentIndexProvider =
                      Provider.of<CurrentIndexProvider>(context, listen: false);
                  currentIndexProvider.setIndex(2);

                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PesananScreen(),
                    ),
                  );
                } else {
                  // Handle error response here
                  print(
                      'Request failed with status code ${response.statusCode}');
                }
              },
              child: Text(
                'Konfirmasi Pesanan',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
