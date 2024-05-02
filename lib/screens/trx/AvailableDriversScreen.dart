import 'package:requests/requests.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DriverProfileScreen.dart';

class AvailableDriversScreen extends StatefulWidget {
  @override
  _AvailableDriversScreenState createState() => _AvailableDriversScreenState();
}

class _AvailableDriversScreenState extends State<AvailableDriversScreen> {
  List<Map<String, dynamic>> _availableDrivers = [];
  // final dio = Dio();
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAvailableDrivers();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final _selectedKotaAsalId = prefs.getInt('selectedKotaAsalId');
    final _selectedKotaTujuanId = prefs.getInt('selectedKotaTujuanId');
    final _selectedDate = prefs.getString('selectedDate');
    final _selectedTime = prefs.getString('selectedTime');

    print("date : $_selectedDate");
    print("time: ${_selectedTime}");
    print("asal : $_selectedKotaAsalId");
    print("tujuan : $_selectedKotaTujuanId");
  }

  Future<void> fetchAvailableDrivers() async {
    const url = 'https://api.movel.id/api/user/drivers/available';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    final _selectedKotaAsalId = prefs.getInt('selectedKotaAsalId');
    final _selectedKotaTujuanId = prefs.getInt('selectedKotaTujuanId');
    final _selectedDate = prefs.getString('selectedDate');
    final _selectedTime = prefs.getString('selectedTime');
    // Convert the string back to an int.
    int? _selectedTimeAsInt = int.tryParse(_selectedTime ?? "");

    final body = {
      "kota_asal_id": _selectedKotaAsalId,
      "kota_tujuan_id": _selectedKotaTujuanId,
      "date_departure": _selectedDate,
      "time_departure_id": _selectedTimeAsInt
    };

    print("Sending request with headers: $headers");
    print("Sending request with body: $body");
    try {
      final response = await Requests.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Handle successful response
        final data = response.json();
        final dataRequest = response.request;
        print(dataRequest);
        print("data : $data");
        print("headhers : ${response.headers}");
        final List<Map<String, dynamic>> driverDataList =
            List<Map<String, dynamic>>.from(data['data']);
        setState(() {
          _availableDrivers = driverDataList;
        });
      } else {
        // Handle the error response
        if (response.statusCode == 400) {
          final errorMessage = response.json()['message'];
          final data = response.json();
          print(data);
          print(response.headers);
          print(response.statusCode);
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
        } else {
          final errorMessage = (response.json())['message'];
          final data = (response.json());
          print(data);
          print(response.statusCode);
          print(response.body);
          print(response.headers);
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
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $error'),
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

  // List<dynamic> _availableDrivers = [
  //   'Driver 1',
  //   'Driver 2',
  //   'Driver 3',
  //   'Driver 4',
  //   'Driver 5',
  //   'Driver 6',
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple.shade700,
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
            Expanded(
              child: GridView.builder(
                itemCount: _availableDrivers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2.0,
                    surfaceTintColor: Colors.white,
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
                              builder: (context) => DriverProfileScreen(
                                    driverData: _availableDrivers[index],
                                  )),
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
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _availableDrivers[index]['driver_name']
                                          as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),

                                    _availableDrivers[index]['is_smoking'] ==
                                            'Merokok'
                                        ? Icon(
                                            Icons.smoking_rooms_rounded,
                                            color: Colors.black,
                                          )
                                        : _availableDrivers[index]
                                                    ['is_smoking'] ==
                                                'Tidak Merokok'
                                            ? Icon(
                                                Icons.smoke_free,
                                                color: Colors.black,
                                              )
                                            : SizedBox(), // Placeholder if none of the conditions are met
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                      color: Colors.black45,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      _availableDrivers[index]['car_merk'] +
                                          ' (' +
                                          _availableDrivers[index]
                                              ['car_prod_year'] +
                                          ')',
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.airline_seat_recline_normal,
                                      color: Colors.black45,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      _availableDrivers[index]
                                                  ["car_seat_capacity"]
                                              .toString() +
                                          " kursi",
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontSize: 10,
                                      ),
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
                              color: Colors.transparent,
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
