import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movel/screens/trx/ChooseSeatScreen.dart';
import 'package:movel/screens/trx/KonfirmasiPesananScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;

import '../trx/ChooseLocationScreen.dart';

var items = [
  {
    "foto": "assets/ardi.png",
    "nama": "Adi",
    "mobil": "Alphard 2022",
    "kursi": "7 kursi",
    "merokok": "tidak merokok",
  },
  {
    "foto": "assets/driver.png",
    "nama": "Ahmad",
    "mobil": "Fortuner 2023",
    "kursi": "3 kursi",
    "merokok": "merokok",
  },
  {
    "foto": "assets/ardi.png",
    "nama": "Imam",
    "mobil": "Fortuner 2023",
    "kursi": "7 kursi",
    "merokok": "tidak merokok",
  },
  {
    "foto": "assets/driver.png",
    "nama": "Agung",
    "mobil": "Fortuner 2023",
    "kursi": "4 kursi",
    "merokok": "merokok",
  },
];

var promo = [
  {
    "foto": "assets/promo.png",
  },
  {
    "foto": "assets/promo2.png",
  },
  {
    "foto": "assets/promo.png",
  },
  {
    "foto": "assets/promo2.png",
  },
];

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({Key? key}) : super(key: key);

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var tokenText;
  int _current = 0;
  List<dynamic> activeDrivers = [];
  String baseUrl = 'https://api.movel.id';
  List<dynamic> kotaData = [];

  Future<Map<String, dynamic>> fetchOrderResume(
      {required int driverDepartureId,
      required List<int> seatCarChoices}) async {
    final response = await http.post(
      Uri.parse('https://api.movel.id/api/user/orders/resume'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'driver_departure_id': driverDepartureId,
        'seat_car_choices': seatCarChoices,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order resume');
    }
  }

  Future<List<dynamic>> fetchKotaData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await Requests.get(
        'https://api.movel.id/api/user/kota_kab/search',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response: ${response.content()}"); // print the raw response

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        return response.json()['data'];
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load kota data');
      }
    } catch (e) {
      print("Error: $e"); // print any errors that occur
      return [];
    }
  }

  Future<void> fetchActiveDrivers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await Requests.get(
        'https://api.movel.id/api/user/drivers/active-drivers',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Response: ${response.content()}"); // print the raw response

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        setState(() {
          activeDrivers = response.json();
          print("activeDrivers: $activeDrivers"); // print here
        });
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load active drivers');
      }
    } catch (e) {
      print("Error: $e"); // print any errors that occur
    }
  }

  @override
  void initState() {
    super.initState();
    fetchActiveDrivers();
    fetchKotaData().then((data) {
      setState(() {
        kotaData = data;
      });
    });
  }

  Widget buildKotaName(Map<String, dynamic> activeDriver) {
    if (kotaData.isNotEmpty) {
      String getKotaName(int id) {
        var kota =
            kotaData.firstWhere((k) => k['id'] == id, orElse: () => null);
        return kota != null ? kota['nama_kota'] : 'Unknown';
      }

      return Text(
        '${getKotaName(activeDriver["kota_asal_id"])} - ${getKotaName(activeDriver["kota_tujuan_id"])}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      );
    } else {
      // By default, show a loading spinner.
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(
            //   height: 25,
            // ),
            Stack(
              children: [
                Image.asset(
                  'assets/Hero.png',
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 15,
                  left: 70,
                  right: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        // print('context: $context');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseLocationScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rute yang tersedia",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text("Lihat Semua"),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 20),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                ),
                itemCount: (activeDrivers.length / 2).ceil(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;

                  return Row(
                    children: [first, second].map((idx) {
                      if (idx < activeDrivers.length) {
                        return Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseSeatScreen(
                                    driverId: activeDrivers[idx]["id"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: EdgeInsets.only(
                                right: 5,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(
                                    10), // Add some margin to give space for the shadow
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.2), // Change the color and opacity as needed
                                      spreadRadius: 1, // Change as needed
                                      blurRadius: 2, // Change as needed
                                      offset: Offset(0, 2), // Change as needed
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: NetworkImage(
                                              '$baseUrl/${activeDrivers[idx]["photo"]}'
                                                  .replaceFirst(
                                                      'public/', 'storage/'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${activeDrivers[idx]["name"]}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            buildKotaName(activeDrivers[idx]),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              '${DateFormat('d MMMM yyyy').format(DateTime.parse(activeDrivers[idx]["date_departure"]))}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Promo Hari Ini",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text("Lihat Semua"),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            // Container(
            //   padding: EdgeInsetsDirectional.only(start: 20),
            //   height: 200,
            //   child: CarouselSlider.builder(
            //     options: CarouselOptions(
            //       aspectRatio: 2.0,
            //       enlargeCenterPage: false,
            //       viewportFraction: 1,
            //       // height: 200,
            //     ),
            //     itemCount: (promo.length / 2).ceil(),
            //     itemBuilder: (context, index, realIdx) {
            //       final int first = index * 2;
            //       final int second = first + 1;
            //       return Container(
            //         // height: 500,
            //         child: ListView(
            //           scrollDirection: Axis.horizontal,
            //           children:
            //               // [first, second].map((idx)
            //               promo.map((i) {
            //             // if (idx < promo.length) {
            //             return Container(
            //               margin: EdgeInsets.only(right: 5),
            //               child: Image.asset(
            //                 '${i["foto"]}',
            //               ),
            //             );
            //             // } else {
            //             //   return Container();
            //             // }
            //           }).toList(),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
