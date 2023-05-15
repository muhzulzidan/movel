import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:movel/screens/home/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../profile/alamat.dart';
import '../profile/change_password.dart';
import '../profile/riwayat_pesanan.dart';
import 'ChooseDestination.dart';

class ChooseLocationScreen extends StatefulWidget {
  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

FocusNode _searchFocusNode = FocusNode();

Future<Map<String, dynamic>> _fetchData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final headers = {'Authorization': 'Bearer $token'};

  final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/kota_kab/search'),
      headers: headers);

  if (response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> setKotaAsal(int kotaAsalId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  final body = {'kota_asal_id': kotaAsalId};
  final response = await http.post(
      Uri.parse('https://api.movel.id/api/user/rute_jadwal/kota_asal'),
      headers: headers,
      body: jsonEncode(body));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    print(
        'Set kota asal successfull with kota_asal_id: ${data['kota_asal_id']}');
    // Do something with the response data if needed
  } else {
    throw Exception('Failed to set kota asal');
  }
}

List<Map<String, dynamic>> buildListData(BuildContext context) {
  return [
    {
      "title": "Makassar",
      "onTap": () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TokecScreen()),
        );
      },
    },
    {
      "title": "Bone",
      "onTap": () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
        );
      },
    },
    {
      "title": "Riwayat pesanan",
      "onTap": () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RiwayatPesananScreen()),
        );
      },
    },
    {
      "title": "Pusat bantuan",
      "onTap": () {
        // TODO: Navigate to pusat bantuan screen.
      },
    },
    {
      "title": "Pengaturan",
      "onTap": () {
        // TODO: Navigate to pengaturan screen.
      },
    },
    {
      "title": "Alamat",
      "onTap": () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlamatScreen()),
        );
      },
    },
    {
      "title": "Keluar",
      "onTap": () async {
        // TODO: Log out the user and navigate to the login screen.
      },
    },
  ];
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  String _selectedLocation = '';
  bool _isLoading = false;
  bool _showOptions = false;
  bool _showObject = true;

  FocusNode _searchFocusNode = FocusNode();

  void _handleTap() {
    print('onTap');
    setState(() {
      _showObject = !_showObject;
      print(_showObject);
    });
  }

  var login;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Pilih Lokasi Asal Anda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("#60009A"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: HexColor("#60009A")),
            height: _showObject
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.1,
            child: Stack(children: [
              Positioned(
                left: 90,
                top: 80,
                child: Visibility(
                  visible: _showObject,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'MO',
                        style: TextStyle(
                            color: HexColor("#FFD12E"),
                            height: .8,
                            fontSize: 100,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Vel',
                        style: TextStyle(
                            color: HexColor("#FFD12E"),
                            height: .8,
                            fontSize: 110,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Visibility(
                  visible: _showObject,
                  child: Image.asset(
                    "assets/avanza-gray-(1)_optimized.png",
                    width: 170,
                    height: 300,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    height: 49,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: TextFormField(
                        onTap: _handleTap,
                        onEditingComplete: () {
                          _handleTap();
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.black),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Cari',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // TODO: Implement location search
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Visibility(
            visible: !_showObject,
            child: Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _fetchData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final data = snapshot.data;
                            if (data!.containsKey('status')) {
                              // Check if the response has 'status' key
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cek Kotak Email Anda!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      data['status'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Otherwise, it's a response with all cities data
                              final cities = data['data'] as List<dynamic>;
                              return ListView.builder(
                                itemCount: cities.length,
                                itemBuilder: (context, index) {
                                  final city = cities[index];

                                  return ListTile(
                                      title: Text(city['nama_kota']),
                                      onTap:
                                          // Do something when   a city is tapped
                                          () async {
                                        try {
                                          await setKotaAsal(city['id']);
                                          // Do something after successfully setting kota asal
                                        } catch (e) {
                                          // Handle the error if setting kota asal fails
                                        }
                                      });
                                },
                              );
                              // Process the cities data and return a widget tree
                            }
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    // child: FutureBuilder<Map<String, dynamic>>(
                    //   future: _fetchData(),
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<List<dynamic>> snapshot) {
                    //     if (snapshot.hasData) {
                    //       // Render the list of locations
                    //       final data = snapshot.data!;
                    //       return ListView.builder(
                    //         itemCount: data.length,
                    //         itemBuilder: (BuildContext context, int index) {
                    //           return ListTile(
                    //             title: Text(data[index]["title"]),
                    //             onTap: () {
                    //               // Handle location selection
                    //             },
                    //           );
                    //         },
                    //       );
                    //     } else if (snapshot.hasError) {
                    //       // Render the error message
                    //       return Text('${snapshot.error}');
                    //     } else {
                    //       // Render a loading spinner
                    //       return Center(child: CircularProgressIndicator());
                    //     }
                    //   },
                    // ),
                  ),

                  // for (final data in buildListData(context))
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: buildListData(context).length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return ListTile(
                  //         title: Text(buildListData(context)[index]["title"]),
                  //         onTap: buildListData(context)[index]["onTap"],
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _showObject,
            child: Expanded(
              flex: 1,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Row(
                  children: [
                    // Image cut in half
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ClipRect(
                        child: Image.asset(
                          "assets/buntutMobil.png",
                        ),
                      ),
                    ),

                    // Text and Buttons
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                alignment: Alignment.topRight,
                                child: RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    text: 'Atau pilih ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'kota asalmu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: ' di bawah ini!'),
                                    ],
                                  ),
                                )
                                // Text(
                                //   textAlign: TextAlign.end,
                                //   "Atau pilih kota asalmu di bawah ini",
                                //   style: TextStyle(),
                                // )

                                ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 45,
                                  width: 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.grey[100],
                                  ),
                                  child: ListTile(
                                    // leading: Icon(Icons.place),

                                    title: Text(
                                      'Makassar',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          height: .1),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedLocation = 'Makassar';
                                      });
                                    },
                                    selected: _selectedLocation == 'Makassar',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 45,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.grey[100],
                                  ),
                                  child: ListTile(
                                    // leading: Icon(Icons.place),

                                    title: Text(
                                      'Sengkang',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          height: .1),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedLocation = 'Sengkang';
                                      });
                                    },
                                    selected: _selectedLocation == 'Sengkang',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 45,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.grey[100],
                                  ),
                                  child: ListTile(
                                    // leading: Icon(Icons.place),

                                    title: Text(
                                      'Sengkang',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          height: .1),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedLocation = 'Sengkang';
                                      });
                                    },
                                    selected: _selectedLocation == 'Sengkang',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Colors.amber,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseDestinationScreen()),
                                  );
                                },
                                // onPressed: _isLoading ? null : login,
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Oke',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 17),
                                      ),
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
        ],
      ),
    );
  }
}
