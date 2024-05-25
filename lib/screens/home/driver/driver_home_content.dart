import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  late WebSocketChannel _channel;
  late IO.Socket socket;

  int saldo = 0; // Initialize with 0 or some default value
  List<Map<String, dynamic>> _seats = [];
  bool _hasAcceptedOrders = false;

  // List<String> _seats = ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C'];
  Set<int> _selectedSeats = <int>{};

  bool _isButtonPressed = false;
  bool _isBerangkat = false;
  bool _isLoading = true;
  String? _kotaAsalName;
  String? _kotaTujuanName;

  @override
  void initState() {
    super.initState();

    connectToServer();

    _loadButtonPressedState();
    fetchRouteData();
    fetchSeatData().then((seatData) {
      print("seatData $seatData");
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

    fetchSaldo();
    _fetchAcceptedOrders();
    // Fetch the active status of the driver
    _fetchActiveStatus();
  }

  void connectToServer() {
    socket = IO.io('https://admin.movel.id', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    List<String> events = [
      'order_pick_location',
      'order_pick_location_arrive',
      'order_complete',
      'order_cancel_accept',
      'order_cancel_reject',
      'new_order',
      'order_accept',
    ];

    for (var event in events) {
      socket.on(event, (data) {
        print('$event event: $data');
        fetchSeatData().then((seatData) {
          print("seatData $seatData");
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
      });
    }

    socket.on('top_up', (data) {
      print('Received top_up event: $data');
      fetchSaldo(); // Refetch saldo when a top_up event is received
    });

    // Listen for the new_order event
    socket.on('new_order', (data) {
      // Update the list of orders
      print('Received new_order event: $data');
      _fetchAcceptedOrders();
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Future<bool> _fetchActiveStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/drivers/active-status'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var activeStatus = jsonDecode(response.body)['isActive'];
      setState(() {
        _isButtonPressed = activeStatus == 1;
      });
      return activeStatus == 1; // Return the active status
    } else {
      // Handle error
      print('Failed to fetch active status');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch active status')),
      );
      return false; // Return false if there was an error
    }
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
        if (jsonData['status'] == false &&
            jsonData['message'] == 'Order tidak ditemukan') {
          setState(() {
            _hasAcceptedOrders = false;
          });
        } else {
          final acceptedOrders = jsonData['data'];
          if (acceptedOrders.isNotEmpty) {
            setState(() {
              _hasAcceptedOrders = true;
            });
          } else {
            setState(() {
              _hasAcceptedOrders = false;
            });
          }
          print('acceptedOrders: $acceptedOrders');
          print('_hasAcceptedOrders: $_hasAcceptedOrders');
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _hasAcceptedOrders = true;
        });
        print("Failed to fetch accepted orders");
        print(response.body);
        print(response.json());
      } else {
        print("Failed to fetch accepted orders");
        print(response.body);
        print(response.json());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addSeatForDriver(List<int> seatIds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'https://api.movel.id/api/user/orders/driver/take_self';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    // final body = jsonEncode({
    //   'seat_car_choices': seatIds,
    // });

    final body = '''
    {
    "seat_car_choices": $seatIds
    }
    ''';
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print('Response: ${response.content()}');
      // print('Response: ${response.json()}');
    } catch (e) {
      print('Error making the request: $e');
    }
  }

  Future<void> fetchRouteData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Requests.get(
      'https://api.movel.id/api/user/drivers/rute_jadwal',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('API Response: ${response.content()}');
      final routeData = response.json();
      setState(() {
        _kotaAsalName = routeData['kota_asal'];
        _kotaTujuanName = routeData['kota_tujuan'];
      });
    } else {
      print('Failed to fetch route data. Status code: ${response.statusCode}');
    }
  }

// Function to check if a route and schedule exist
  Future<bool> checkRouteAndSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Requests.get(
      'https://api.movel.id/api/user/drivers/rute_jadwal',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = response.json();
      if (jsonResponse != null && jsonResponse.containsKey('id')) {
        print("Route and schedule exist: $jsonResponse");
        return true; // Route and schedule exist
      } else {
        print("Route and schedule do not exist: $jsonResponse");
        return false; // Route and schedule do not exist
      }
    } else if (response.statusCode == 404 &&
        response.body.contains("Rute jadwal not found")) {
      // Handle the specific error message or status code for "Rute jadwal not found"
      return false;
    } else {
      print("Error status code: ${response.statusCode}");
      print("Error response body: ${response.body}");
      throw Exception('Failed to check route and schedule');
    }
  }

  Future<void> setDriverActive() async {
    print("setDriverActive");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Requests.put(
      'https://api.movel.id/api/user/drivers/active',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = response.json();
      if (!jsonData['success']) {
        print(response.json());
        throw Exception('Failed to set driver to active');
      }
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            title: Text('Saldo Tidak Cukup'),
            content: Text('Tolong top up saldo Anda terlebih dahulu'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print(response.json());
      throw Exception('Unexpected error occurred');
    }
  }

  Future<void> fetchSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await Requests.get(
        'https://api.movel.id/api/user/drivers/balance',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.json();
        setState(() {
          saldo = int.parse(data['saldo']);
        });
      } else {
        print("Failed to load balance");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  // void _loadButtonPressedState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final aktif = prefs.getBool('aktif') ??
  //       false; // Set the default value to false if it doesn't exist
  //   setState(() {
  //     _isButtonPressed = aktif;
  //   });
  //   print("_isButtonPressed : $_isButtonPressed");
  //   print("aktif : $aktif");
  // }

  Future<void> _loadButtonPressedState() async {
    final prefs = await SharedPreferences.getInstance();
    final aktif = prefs.getBool('aktif') ?? false; // Default value is false
    setState(() {
      _isButtonPressed = aktif;
    });

    // Make the API request
    try {
      final response = await Requests.get(
        'https://api.movel.id/api/user/drivers/rute_jadwal',
        // Add any required headers here
      );

      if (response.statusCode == 200) {
        final jsonData = response.json();
        final isActive = jsonData['is_active'] == 1;
        if (isActive) {
          _isButtonPressed = true; // Set the button to active
        } else {
          _isButtonPressed = false; // Set the button to inactive
        }
      } else if (response.statusCode == 404) {
        _isButtonPressed = false; // Set the button to inactive
      }
    } catch (e) {
      print("API request error: $e");
    }

    print("_isButtonPressed : $_isButtonPressed");
    print("aktif : $aktif");
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
                            // Deactivate the driver
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('aktif', false);
                            final token = prefs.getString('token');

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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Status Driver Tidak aktif!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Status Driver Tidak berubah!')),
                              );
                            }
                          } else {
                            bool routeExists = await checkRouteAndSchedule();
                            if (routeExists) {
                              await setDriverActive();
                              bool isActive =
                                  await _fetchActiveStatus(); // Fetch the active status from the server
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('aktif',
                                  isActive); // Update the local state based on the server's state
                              setState(() {
                                _isButtonPressed =
                                    isActive; // Update the button's state based on the server's state
                              });
                              if (isActive) {
                                // Only show the snackbar if the driver is active
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Status Driver Aktif!')),
                                );
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JadwalScreen()),
                              );
                            }
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
                          if (_hasAcceptedOrders) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tidak Bisa Mengubah Rute lagi.'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red.shade700,
                                // behavior: SnackBarBehavior.floating,
                              ),
                            );
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
                          backgroundColor: Colors.deepPurple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          _kotaAsalName != null && _kotaTujuanName != null
                              ? '$_kotaAsalName - $_kotaTujuanName'
                              : 'Atur Rute dan Jadwal',
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
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth:
                                    140, // Set your desired minimum width here
                              ),
                              child: Container(
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
                                      "Poin:",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      "${NumberFormat('#,###', 'id_ID').format(saldo)} Poin",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
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
                                        builder: (context) =>
                                            TopUpScreen(saldo: saldo),
                                      ),
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
                    height: 30,
                  ),
                  Center(
                    child: Column(
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
                          width: 30,
                          height: 10,
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
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // SizedBox(
                  //   width: 180,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor:
                  //           _isBerangkat ? Colors.amberAccent : Colors.grey,
                  //       padding: EdgeInsets.symmetric(vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20.0),
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       // TODO: Add your logic here
                  //       setState(() {
                  //         _isBerangkat = !_isBerangkat;
                  //       });
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(
                  //           Icons.check_circle,
                  //           color: _isBerangkat ? Colors.black : Colors.white,
                  //         ),
                  //         SizedBox(width: 8.0),
                  //         Text(
                  //           "Berangkat",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.w700,
                  //             color: _isBerangkat ? Colors.black : Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
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
    // final bool isSelected = _selectedSeats.contains(labelSeat);

    final int idLabel = seat['id_label'] as int;
    final bool isSelected = _selectedSeats.contains(idLabel);

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
                        surfaceTintColor: Colors.white,
                        content: Text(
                          'yakin ingin menambahkan penumpang?',
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
                                    surfaceTintColor: Colors.white,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ).then((confirmed) async {
                final int idLabel = seat['id_label'] as int;

                if (confirmed != null && confirmed) {
                  setState(() {
                    if (_selectedSeats.contains(idLabel)) {
                      _selectedSeats.remove(idLabel);
                    } else {
                      _selectedSeats.add(idLabel);
                    }
                  });
                  print('Selected Seat IDs: $_selectedSeats');

                  await addSeatForDriver(_selectedSeats.toList());
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
