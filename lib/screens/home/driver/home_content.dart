import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'trx/PesananDibatalkanScreen.dart';
import 'trx/TopUpScreen.dart';
import 'trx/jadwal.dart';

class DriverHomeContent extends StatefulWidget {
  const DriverHomeContent({super.key});

  @override
  State<DriverHomeContent> createState() => _DriverHomeContentState();
}

class _DriverHomeContentState extends State<DriverHomeContent> {
  int saldo = 900000;
  List<Map<String, dynamic>> _seats = [];

  // List<String> _seats = ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C'];
  Set<String> _selectedSeats = <String>{}; // Keep track of selected seats
  bool _isButtonPressed = false;
  bool _isBerangkat = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadButtonPressedState();
    fetchSeatData().then((seatData) {
      setState(() {
        _seats = seatData;
        _isLoading = false;
      });
    }).catchError((error) {
      print('Error fetching seat data: $error');
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _loadButtonPressedState() async {
    final prefs = await SharedPreferences.getInstance();
    final aktif = prefs.getBool('aktif') ??
        false; // Set the default value to false if it doesn't exist
    setState(() {
      _isButtonPressed = aktif;
    });
    print("_isButtonPressed : $_isButtonPressed");
  }

  Future<List<Map<String, dynamic>>> fetchSeatData() async {
    final apiUrl = 'https://api.movel.id/api/user/drivers/seat_cars';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Extract the seat data from the response
      final seatData = responseData['data'] as List<dynamic>;
      final seatList =
          seatData.map((seat) => seat as Map<String, dynamic>).toList();
      print("home response data $responseData");
      print("home seatdata driver : $seatData");
      return seatList;
    } else {
      final responseData = jsonDecode(response.body);
      print("error seatdata driver : ${responseData}");
      throw Exception('Failed to fetch seat data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("driverContent"),
      // ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/driverHero.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // height: double.infinity,
                  ),
                  Positioned(
                    // height: double.infinity,
                    top: 50,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_isButtonPressed) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('aktif', false);
                            final token = prefs.getString('token');
                            // Make the PUT request to the endpoint

                            final response = await Requests.put(
                              'https://api.movel.id/api/user/drivers/inactive',
                              headers: {
                                'Authorization': 'Bearer $token',
                              },
                            );
                            if (response.statusCode == 200) {
                              setState(() {
                                _isButtonPressed = false;
                              });
                              // Request successful, handle the response
                              print(response.body);
                              print('Inactive request success');
                            } else {
                              // Request failed, handle the error
                              print(
                                  'Inactive request failed with status: ${response.statusCode}');
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JadwalScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: _isButtonPressed
                              ? Colors.amberAccent
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: _isButtonPressed ? 20 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.power_settings_new,
                                color: _isButtonPressed
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _isButtonPressed ? 'Aktif' : "Tidak Aktif",
                                style: TextStyle(
                                  color: _isButtonPressed
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    top: 120,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JadwalScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.deepPurple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Atur Rute dan Jadwal',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    bottom: 15,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
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
                    // height: double.infinity,
                    bottom: 15,
                    left: 25,
                    right: 25,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Saldo:",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    "Rp $saldo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement top up functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  backgroundColor: Colors.deepPurple.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TopUpScreen()),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.control_point,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Top Up',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Cek Jumlah dan kursi penumpangmu hari ini ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    // constraints: BoxConstraints.expand(),
                    width: 280,
                    height: 200,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(29),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/otoWhite.png'), // Replace with your desired background image
                        // fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the border radius as needed
                    ),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_seats.length > 0)
                                      buildSeatCard(_seats[0]),
                                    SizedBox(width: 4),
                                    if (_seats.length > 1)
                                      buildSeatCard(_seats[1]),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_seats.length > 2)
                                      buildSeatCard(_seats[2]),
                                    if (_seats.length > 3) SizedBox(width: 4),
                                    if (_seats.length > 3)
                                      buildSeatCard(_seats[3]),
                                    if (_seats.length > 4) SizedBox(width: 4),
                                    if (_seats.length > 4)
                                      buildSeatCard(_seats[4]),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_seats.length > 5)
                                      buildSeatCard(_seats[5]),
                                    SizedBox(width: 4),
                                    if (_seats.length > 6)
                                      buildSeatCard(_seats[6]),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pesanan Dibatalkan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {
                            // to do
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PesananDibatalkanScreen()),
                            );
                          },
                          child: Text(
                            "Lihat",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isBerangkat ? Colors.amberAccent : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Add your logic here
                        setState(() {
                          _isBerangkat = !_isBerangkat;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: _isBerangkat ? Colors.black : Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Berangkat",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _isBerangkat ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSeatCard(Map<String, dynamic> seat) {
    final String labelSeat = seat['label_seat'] as String;
    final bool isSelected = _selectedSeats.contains(labelSeat);

    final int isFilled = seat['is_filled'] as int; // Update the casting to int
    final Color backgroundColor = isSelected ? Colors.amber : Colors.white;
    final TextStyle textStyle = TextStyle(
      fontSize: labelSeat == 'Sopir' ? 10 : 15,
      fontWeight: FontWeight.bold,
      color: isFilled == 1
          ? Colors.black
          : isSelected
              ? Colors.deepPurple.shade700
              : Colors.black,
    );

    print("buildseattcard is sselected : $isSelected");

    return isFilled == 1
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 4),
            child: Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.amber,
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
              ),
              child: RotatedBox(
                quarterTurns: 3,
                child: Center(
                  child: Text(
                    labelSeat,
                    style: textStyle,
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      AlertDialog(
                        // title: Text('Yakin ingin menambahkan penumpang?'),
                        content: Text(
                          'Yakin ingin menambahkan penumpang?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        actions: <Widget>[
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    elevation: 4,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    "Tidak",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    elevation: 4,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    "ya",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // TextButton(
                                //   onPressed: () {
                                //     Navigator.of(context).pop(false); // No
                                //   },
                                //   child: Text('Tidak'),
                                // ),
                                // TextButton(
                                //   onPressed: () {
                                //     Navigator.of(context).pop(true); // Yes
                                //   },
                                //   child: Text('Ya'),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ).then((confirmed) {
                if (confirmed != null && confirmed) {
                  setState(() {
                    final String selectedSeat = seat['label_seat'] as String;
                    if (_selectedSeats.contains(selectedSeat)) {
                      _selectedSeats.remove(selectedSeat);
                    } else {
                      _selectedSeats.add(selectedSeat);
                    }
                  });
                }
              });
            },
            splashColor: Colors.amber,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 4),
              child: Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: backgroundColor,
                  border: Border.all(
                    color: isSelected ? Colors.amber : Colors.white,
                    width: 2,
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Center(
                    child: Text(
                      labelSeat,
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
