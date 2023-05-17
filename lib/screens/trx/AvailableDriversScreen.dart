import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'DriverProfileScreen.dart';

class AvailableDriversScreen extends StatefulWidget {
  @override
  _AvailableDriversScreenState createState() => _AvailableDriversScreenState();
}

class _AvailableDriversScreenState extends State<AvailableDriversScreen> {
  List<dynamic> _availableDrivers = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableDrivers();
  }

  Future<void> fetchAvailableDrivers() async {
    final url = Uri.parse('https://api.movel.id/api/user/drivers/available');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _availableDrivers = data['drivers'];
        });
      } else {
        // Handle the error response
        final errorMessage = jsonDecode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle the network error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: HexColor("#60009A"),
        title: Text(
          'Sopir yang Tersedia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                // height: 20,
                ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Sopir',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                // implement searching logic here
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pilih Sopirmu',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _availableDrivers.length,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         elevation: 2.0,
            //         shadowColor: Colors.grey[200],
            //         child: ListTile(
            //           leading: CircleAvatar(
            //             backgroundImage: AssetImage('assets/driver.png'),
            //           ),
            //           title: Text(
            //             _availableDrivers[index],
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           subtitle: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text('Tidak merokok'),
            //               Text('Kursi: 4'),
            //               Text('Mobil: Honda Jazz'),
            //             ],
            //           ),
            //           // trailing: Icon(Icons.arrow_forward_ios),
            //           onTap: () {
            //             // TODO: Navigate to driver details screen
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),

            Expanded(
              child: GridView.builder(
                itemCount: _availableDrivers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2.0,
                    shadowColor: Colors.grey[200],
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      onPressed: () {
                        // TODO: Implement button press action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DriverProfileScreen()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/driver.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0)),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _availableDrivers[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Tidak merokok',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '4 kursi',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Honda Jazz',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 5),
                          Container(
                            height: 5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
