import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';

import '../home_content.dart';

class JadwalScreen extends StatefulWidget {
  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  TextEditingController _selectedDateController = TextEditingController();
  TextEditingController _selectedTimeController = TextEditingController();

  // color
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  ColorLabel? selectedColor;
  JamLabel? selectedjam;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lokasiAsalController = TextEditingController();
  final TextEditingController _destinasiController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();

  String _selectedLocation = '';

  List<dynamic> _kotaAsal = [];
  List<dynamic> _filteredKotaAsal = [];
  List<dynamic> _filteredKotaTujuan = [];
  List<dynamic> _kotaTujuan = [];
  int? _selectedKotaTujuanId = 18;
  String? _selectedKotaTujuanNama;
  int? _selectedKotaAsalId = 6;
  String? _selectedKotaAsalNama;

  double containerHeight = 0.0;

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  bool _asalVisibility = true;
  bool _tujuanVisibility = true;
  bool _jadwalVisibility = true;
  bool _jamVisibility = true;

  String _selectedJam = "1"; // Variable to store the selected jam value

  List<DropdownMenuItem<String>> _jamOptions = [
    DropdownMenuItem(value: 'Pagi (1)', child: Text('Pagi (1)')), // 1
    DropdownMenuItem(value: 'Siang (2)', child: Text('Siang (2)')), // 2
    DropdownMenuItem(value: 'Malam (3)', child: Text('Malam (3)')), // 3
  ];

  List<String> _activeSections = [
    'tujuan',
    'jam',
    'asal',
    'jadwal'
  ]; // Initialize it with an empty string
  bool _showObject = true;

  // List<Map<String, dynamic>> _filteredKotaAsal = [
  //   {'id': 1, 'nama_kota': 'Bone'},
  //   {'id': 2, 'nama_kota': 'Makassar'},
  //   {'id': 3, 'nama_kota': 'Sengkang'},
  // ];

  List<Map<String, dynamic>> _searchResult = [];

  // String? _selectedKotaAsalNama;
  // int? _selectedKotaAsalId;

  // TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the default selected date to today
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();

    _fetchData().then((data) {
      setState(() {
        _filteredKotaAsal = data;
        _kotaAsal = data;
        _filteredKotaTujuan = data;
        _kotaTujuan = data;
      });
    }).catchError((error) {
      print('Error: $error');
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final screenHeight = MediaQuery.of(context).size.height;
      setState(() {
        containerHeight = screenHeight - keyboardHeight;
      });
    });
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

    if (response.statusCode == 200) {
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
      // TODO: Implement password change logic.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rute terjadwal!')),
      );
    }
    await Future.delayed(Duration(seconds: 2)); // Add a 2-second delay

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverHomeContent()),
    );
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
    final List<DropdownMenuEntry<JamLabel>> jamEntries =
        <DropdownMenuEntry<JamLabel>>[];
    for (final JamLabel jam in JamLabel.values) {
      jamEntries.add(
        DropdownMenuEntry<JamLabel>(
          value: jam, label: jam.label,
          // enabled: jam.label != 'Pagi'
        ),
      );
    }

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
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 21, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0),
                                      child: DropdownButtonFormField<String>(
                                        onTap: () {},
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          // contentPadding: EdgeInsets.symmetric(
                                          //     horizontal: 21, vertical: 10),
                                          // hintText: 'tanggal/bulan/tahun',
                                          // suffixIcon: Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       right: 20),
                                          //   child: Icon(
                                          //       Icons.calendar_month_outlined),
                                          // ),
                                        ),
                                        icon: Icon(Icons.schedule),
                                        style: TextStyle(color: Colors.black54),
                                        value: _selectedJam,
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: "1",
                                            child: Text(
                                              'Pagi',
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "2",
                                            child: Text('Siang'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "3",
                                            child: Text('Malam'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedJam = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
        _selectedDateController.text =
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedTimeController.text =
            "${_selectedTime.hour}:${_selectedTime.minute}";
      });
    }
  }
}

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

enum JamLabel {
  pagi('Pagi', 1),
  siang('Siang', 2),
  malam('Malam', 3);

  const JamLabel(this.label, this.value);

  final String label;
  final int value;
}
