import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:movel/screens/home/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../profile/alamat.dart';
import '../profile/change_password.dart';
import '../profile/riwayat_pesanan.dart';
import 'ChooseDepartureDateScreen.dart';
import 'ChooseDestination.dart';

class ChooseDestinationScreen extends StatefulWidget {
  @override
  _ChooseDestinationScreenState createState() =>
      _ChooseDestinationScreenState();
}

final _formKey = GlobalKey<FormState>();

class _ChooseDestinationScreenState extends State<ChooseDestinationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = '';
  bool _isLoading = false;
  bool _showOptions = false;
  bool _showObject = true;
  List<dynamic> _kotaTujuan = [];
  List<dynamic> _filteredKotaTujuan = [];
  int? _selectedKotaTujuanId;
  String? _selectedKotaTujuanNama;

  @override
  void initState() {
    super.initState();
    // _fetchData();
    _fetchData().then((data) {
      if (data != null) {
        setState(() {
          _filteredKotaTujuan = data;
          _kotaTujuan = data;
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  FocusNode _searchFocusNode = FocusNode();

  void _handleTap() {
    print('onTap');
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _showObject = !_showObject;
      print(_showObject);
    });
  }

  Future<List<dynamic>> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/kota_kab/search'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('status')) {
        // Handle response with 'status' key
        throw Exception(data['status']);
      } else {
        final cities = data['data'];
        print('Request URL: ${response.request?.url}');
        print('Response Status Code: ${response.statusCode}');
        print(data);
        return cities;
      }
    } else {
      throw Exception(
          'Failed to load data, Status Code: ${response.statusCode}');
    }
  }

  Future<void> setKotaDestinasi(
    int kotaTujuanId,
  ) async {
    _isLoading = true;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final body = {'kota_tujuan_id': kotaTujuanId};
    final response = await http.post(
        Uri.parse('https://api.movel.id/api/user/rute_jadwal/kota_tujuan'),
        headers: headers,
        body: jsonEncode(body));

    _isLoading = false;

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final responseData = jsonDecode(response.body);

      print(responseData);
      // print( 'Set kota asal successfull with kota_tujuan_id: ${data['kota_tujuan_id']}');
      // Do something with the response data if needed
    } else {
      throw Exception('Failed to set kota asal');
    }
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredKotaTujuan = _kotaTujuan;
      } else {
        _filteredKotaTujuan = _kotaTujuan.where((city) {
          final name = city['nama_kota'].toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery);
        }).toList();
      }
    });
  }

  // void _handleSearch(String query) {
  //   setState(() {
  //     _filteredKotaAsal = _filteredKotaAsal.where((city) {
  //       final name = city['nama_kota'].toString().toLowerCase();
  //       final searchQuery = query.toLowerCase();
  //       return name.contains(searchQuery);
  //     }).toList();
  //   });
  // }

  var login;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Pilih Destinasi Anda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("#60009A"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/tujuan.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: _showObject
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.1,
            child: Stack(children: [
              Positioned(
                right: 30,
                top: 80,
                child: Visibility(
                  visible: _showObject,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'VEL',
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
                        controller: _searchController,
                        // controller: TextEditingController(text: _selectedKotaAsalNama),
                        onTap: _handleTap,
                        onEditingComplete: () {
                          _handleTap();
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.black),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Cari',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // TODO: Implement location search
                          _handleSearch(value);
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
                    child: _filteredKotaTujuan != null
                        ? ListView.builder(
                            itemCount: _filteredKotaTujuan.length,
                            itemBuilder: (context, index) {
                              final city = _filteredKotaTujuan[index];
                              // print(city);

                              return ListTile(
                                title: Text(city['nama_kota'] as String),
                                onTap: () {
                                  setState(() {
                                    _selectedKotaTujuanNama = city['nama_kota'];
                                    _selectedKotaTujuanId = city['id'];
                                    _searchController.text =
                                        _selectedKotaTujuanNama!;
                                  });
                                  _handleTap();
                                  print(_selectedKotaTujuanNama);
                                },
                              );
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  )
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 150,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                        selected:
                                            _selectedLocation == 'Makassar',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 45,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                        selected:
                                            _selectedLocation == 'Sengkang',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 45,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                        selected:
                                            _selectedLocation == 'Sengkang',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
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
                                  setKotaDestinasi(_selectedKotaTujuanId!);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseDepartureDateScreen()),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ClipRect(
                        child: Image.asset(
                          "assets/tujuanCar.png",
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
