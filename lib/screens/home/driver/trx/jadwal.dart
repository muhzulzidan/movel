import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';

import '../driver_home_content.dart';

class JadwalScreen extends StatefulWidget {
  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  TextEditingController _selectedDateController = TextEditingController();
  TextEditingController _selectedTimeController = TextEditingController();

  // color
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  // ColorLabel? selectedColor;
  // JamLabel? selectedjam;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lokasiAsalController = TextEditingController();
  late TextEditingController _destinasiController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _kotaAsal = [];
  List<dynamic> _filteredKotaAsal = [];
  List<dynamic> _filteredKotaTujuan = [];
  List<dynamic> _kotaTujuan = [];
  String _selectedLocation = '';

  int? _selectedKotaTujuanId = 18;
  String? _selectedKotaTujuanNama;
  int? _selectedKotaAsalId = 6;
  String? _selectedKotaAsalNama;

  bool hasExistingData = false; // Add this flag at the class level
  bool _asalVisibility = true;
  bool _showObject = true;

  double containerHeight = 0.0;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _pickedTime;
  late String _pickedDate;

  List<String> _activeSections = [
    'tujuan',
    'jam',
    'asal',
    'jadwal'
  ]; // Initialize it with an empty string

  @override
  void initState() {
    super.initState();
    // Set the default selected date to today
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    Future.wait([
      _fetchData(),
      getExistingRouteAndSchedule(),
    ]).then((List responses) {
      final data = responses[0];
      final routeData = responses[1];

      setState(() {
        _filteredKotaAsal = data;
        _kotaAsal = data;
        _filteredKotaTujuan = data;
        _kotaTujuan = data;
      });

      String? kotaAsalName;
      String? kotaTujuanName;
      print("routeData $routeData");
      try {
        // Find the city names that match the IDs in the existing route and schedule
        final kotaAsal = _kotaAsal
            .firstWhere((city) => city['id'] == routeData['kota_asal_id']);
        final kotaTujuan = _kotaTujuan
            .firstWhere((city) => city['id'] == routeData['kota_tujuan_id']);
        print(routeData['kota_asal_id']);
        print(_kotaAsal);
        // Assign the names to the initialized variables
        kotaAsalName = kotaAsal[
            'nama_kota']; // Replace 'name' with the actual key for the city name
        kotaTujuanName = kotaTujuan[
            'nama_kota']; // Replace 'name' with the actual key for the city name

        // Set hasExistingData to true since we have valid data
        hasExistingData = true; // <-- Add this line here
      } catch (e) {
        print('An error occurred: $e');
      }

      // Use the names here
      if (kotaAsalName != null && kotaTujuanName != null) {
        _lokasiAsalController.text = kotaAsalName;
        _destinasiController.text = kotaTujuanName;
        _selectedKotaAsalId = routeData['kota_asal_id'];
        _selectedKotaTujuanId = routeData['kota_tujuan_id'];
        _pickedDate = routeData['date_departure'];
        _pickedTime = routeData['time_departure'];

        // Set the default selected date to today
        // Convert _pickedDate to DateTime
        _selectedDate = DateTime.parse(_pickedDate);

        // Convert _pickedTime to TimeOfDay
        final timeParts = _pickedTime.split(':');
        _selectedTime = TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

        // Format the date to your desired format
        final formattedDate =
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
        // Format the time to your desired format
        final formattedTime = "${timeParts[0]}:${timeParts[1]}";

        // Initialize _selectedDateController and _selectedTimeController
        _selectedDateController.text = formattedDate;
        _selectedTimeController.text = formattedTime;
        // ... and so on
        setState(() {}); // Call setState to refresh the UI
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final screenHeight = MediaQuery.of(context).size.height;
      setState(() {
        containerHeight = screenHeight - keyboardHeight;
      });
    });
  }

  Future<Map<String, dynamic>?> getExistingRouteAndSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Requests.get(
      'https://api.movel.id/api/user/drivers/rute_jadwal',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return response.json();
    } else {
      print(
          'Failed to fetch existing route and schedule. Status code: ${response.statusCode}');
      return null;
    }
  }

  Future<List<dynamic>> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Requests.get(
      'https://api.movel.id/api/user/kota_kab/search',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.json();
      if (data.containsKey('status')) {
        // Handle response with 'status' key
        throw Exception(data['status']);
      } else {
        final cities = data['data'];
        return cities;
      }
    } else {
      throw Exception(
          'Failed to load data, Status Code: ${response.statusCode}');
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
    setState(() {
      if (query.isEmpty) {
        _filteredKotaAsal = _kotaAsal;
      } else {
        _filteredKotaAsal = _kotaAsal.where((city) {
          final name = city['nama_kota'].toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = ('https://api.movel.id/api/user/drivers/rute_jadwal');
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final _time = _selectedTime.toString();
      print("submitform asal $_selectedKotaAsalId");
      print("submitform tujuan $_selectedKotaTujuanId");
      print("submitform tujuan $_pickedDate");
      print("submitform tujuan $_pickedTime");

      final body = {
        'kota_asal_id': _selectedKotaAsalId,
        'kota_tujuan_id': _selectedKotaTujuanId,
        'date_departure': _pickedDate,
        'time_departure': _pickedTime.toString(),
      };

      final response = await Requests.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Request successful, handle the response
        print(response.body);
        await prefs.setBool('aktif', true); // Update with your desired value

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rute terjadwal!')),
        );
        await Future.delayed(Duration(seconds: 2)); // Add a 2-second delay
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DriverHomeContent()),
        );
      } else {
        // Request failed, handle the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rute Gagal!')),
        );
        print('Request failed with status: ${response.statusCode}');
      }
    }
  }

  void _handleTap(String section) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      if (_activeSections.length == 1 && _activeSections.contains(section)) {
        // If the tapped section is the only active section, add all sections
        _activeSections = ['tujuan', 'jam', 'asal', 'jadwal'];
      } else {
        // Set the tapped section as the only active section
        _activeSections = [section];
      }
      _showObject = !_showObject && _activeSections.contains(section);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade700,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Atur Rute dan Jadwal',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            // textAlign: TextAlign.center,
          ),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                // height: 500,
                color: Colors.deepPurple.shade700,
                child: Column(children: [
                  Container(
                    // color: Colors.deepPurple.shade700,
                    child: Padding(
                        padding: _showObject
                            ? const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15)
                            : EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            SizedBox(height: _asalVisibility ? 10 : 0),
                            Visibility(
                              visible: _activeSections.contains('asal'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _showObject &&
                                          _activeSections.contains('asal')
                                      ? Text(
                                          "Lokasi Asal",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: TextFormField(
                                      controller: _lokasiAsalController,
                                      // obscureText: !_showOldPassword,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 21, vertical: 10),
                                        // labelText: 'Old Password',
                                        hintText: 'Cari',
                                        suffixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Icon(
                                            Icons.location_on,
                                          ),
                                        ),
                                      ),
                                      onEditingComplete: () {
                                        _handleTap("asal");
                                      },
                                      onTap: () {
                                        _handleTap("asal");
                                      },
                                      onChanged: (value) {
                                        // TODO: Implement location search
                                        _handleSearch(value);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Lokasi Asal tidak boleh kosong.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _activeSections.contains('tujuan'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _showObject &&
                                          _activeSections.contains('tujuan')
                                      ? Text(
                                          "Lokasi Tujuan",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: TextFormField(
                                      controller: _destinasiController,
                                      onEditingComplete: () {
                                        _handleTap("tujuan");
                                      },
                                      onTap: () {
                                        _handleTap("tujuan");
                                      },
                                      decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                          hintStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 21, vertical: 10),
                                          // labelText: 'Old Password',

                                          hintText: 'Cari',
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Icon(
                                              Icons.location_on,
                                            ),
                                          )),
                                      onChanged: (value) {
                                        // TODO: Implement location search
                                        _handleSearch(value);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'kata sandi tidak boleh kosong.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _activeSections.contains('jadwal'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jadwal Keberangkatan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: TextFormField(
                                      controller: _selectedDateController,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 21, vertical: 10),
                                        hintText: 'tanggal/bulan/tahun',
                                        suffixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Icon(
                                              Icons.calendar_month_outlined),
                                        ),
                                      ),
                                      onTap: () {
                                        _showDatePicker(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _showObject &&
                                  _activeSections.contains('jadwal'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jam Keberangkatan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: TextFormField(
                                      controller: _selectedTimeController,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 21, vertical: 10),
                                        hintText: 'Pilih Jam Keberangkatan',
                                        suffixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 21),
                                          child: Icon(Icons.schedule),
                                        ),
                                      ),
                                      onTap: () {
                                        _showTimePicker(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                            // Visibility(
                            //   visible: _showObject &&
                            //       _activeSections.contains('jadwal'),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "Jam Keberangkatan",
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 12),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Container(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal: 21, vertical: 1),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(100),
                            //         ),
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 0),
                            //           child: DropdownButtonFormField<String>(
                            //             onTap: () {},
                            //             decoration: InputDecoration(
                            //               border: InputBorder.none,
                            //               // contentPadding: EdgeInsets.symmetric(
                            //               //     horizontal: 21, vertical: 10),
                            //               // hintText: 'tanggal/bulan/tahun',
                            //               // suffixIcon: Padding(
                            //               //   padding: const EdgeInsets.only(
                            //               //       right: 20),
                            //               //   child: Icon(
                            //               //       Icons.calendar_month_outlined),
                            //               // ),
                            //             ),
                            //             icon: Icon(Icons.schedule),
                            //             style: TextStyle(color: Colors.black54),
                            //             value: _selectedJam,
                            //             items: [
                            //               DropdownMenuItem<String>(
                            //                 value: "1",
                            //                 child: Text(
                            //                   'Pagi',
                            //                 ),
                            //               ),
                            //               DropdownMenuItem<String>(
                            //                 value: "2",
                            //                 child: Text('Siang'),
                            //               ),
                            //               DropdownMenuItem<String>(
                            //                 value: "3",
                            //                 child: Text('Malam'),
                            //               ),
                            //             ],
                            //             onChanged: (String? value) {
                            //               setState(() {
                            //                 _selectedJam = value!;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        )),
                  ),
                  Visibility(
                    visible: !_showObject && _activeSections.contains('asal'),
                    child: Container(
                      // height: containerHeight,
                      height: 410,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: _filteredKotaAsal != null
                                ? ListView.builder(
                                    itemCount: _filteredKotaAsal.length,
                                    itemBuilder: (context, index) {
                                      final city = _filteredKotaAsal[index];

                                      return ListTile(
                                        title:
                                            Text(city['nama_kota'] as String),
                                        onTap: () {
                                          setState(() {
                                            _selectedKotaAsalNama =
                                                city['nama_kota'];
                                            _selectedKotaAsalId = city['id'];
                                            _lokasiAsalController.text =
                                                _selectedKotaAsalNama!;
                                          });
                                          _handleTap("asal");
                                          print("city kota asal : $city");
                                          print(
                                              "selected kota asal : $_selectedKotaAsalNama");
                                        },
                                      );
                                    },
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_showObject && _activeSections.contains('tujuan'),
                    child: Container(
                      // height: containerHeight,
                      height: 410,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: _filteredKotaAsal != null
                                ? ListView.builder(
                                    itemCount: _filteredKotaAsal.length,
                                    itemBuilder: (context, index) {
                                      final city = _filteredKotaAsal[index];

                                      return ListTile(
                                        title:
                                            Text(city['nama_kota'] as String),
                                        onTap: () {
                                          setState(() {
                                            _selectedKotaTujuanNama =
                                                city['nama_kota'];
                                            _selectedKotaTujuanId = city['id'];
                                            _destinasiController.text =
                                                _selectedKotaTujuanNama!;
                                          });
                                          _handleTap("tujuan");
                                          print(_selectedKotaTujuanNama);
                                          print(_selectedKotaTujuanNama);
                                        },
                                      );
                                    },
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _showObject,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: Colors.amber,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: Text(
                              'Simpan',
                              style: TextStyle(
                                  // fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        final pickedDate =
            ("${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}");
        _pickedDate = pickedDate;
        _selectedDateController.text =
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      });
      print("_pickedDate : $_pickedDate");
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        final pickedTime =
            ("${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}");
        _pickedTime = pickedTime;
        _selectedTime = picked;
        final formattedTime =
            _selectedTime.format(context); // Format the selected time
        _selectedTimeController.text = formattedTime;
      });
      print("_pickedTime $_pickedTime");
    }
  }
}
