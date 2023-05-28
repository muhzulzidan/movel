import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class JadwalScreen extends StatefulWidget {
  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lokasiAsalController = TextEditingController();
  final _destinasiController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _showObject = true;

  List<Map<String, dynamic>> _filteredKotaAsal = [
    {'id': 1, 'nama_kota': 'Bone'},
    {'id': 2, 'nama_kota': 'Makassar'},
    {'id': 3, 'nama_kota': 'Sengkang'},
  ];

  List<Map<String, dynamic>> _searchResult = [];

  String? _selectedKotaAsalNama;
  int? _selectedKotaAsalId;

  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _lokasiAsalController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleOldPasswordVisibility() {
    setState(() {
      _showOldPassword = !_showOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _showNewPassword = !_showNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement password change logic.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully!')),
      );
    }
  }

  void _handleTap() {
    // print('onTap');
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _showObject = !_showObject;
      // print(_showObject);
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
          color: Colors.deepPurple.shade700,
          child: Column(
            children: [
              Visibility(
                visible: _showObject,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.deepPurple.shade700,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lokasi Asal",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
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
                                          fontSize: 12, color: Colors.black54),
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 21, vertical: 10),
                                      // labelText: 'Old Password',
                                      hintText: 'Cari',
                                      suffixIcon: Icon(
                                        Icons.location_on,
                                      ),
                                    ),
                                    onTap: _handleTap,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Lokasi Asal tidak boleh kosong.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lokasi Tujuan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: !_showNewPassword,
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
                                        suffixIcon: Icon(
                                          Icons.location_on,
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'kata sandi tidak boleh kosong.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jadwal Keberangkatan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !_showConfirmPassword,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 21, vertical: 10),
                                      // labelText: 'Old Password',
                                      hintText: 'Konfirmasi Kata Sandi Baru',
                                      suffixIcon: IconButton(
                                        icon: Icon(_showConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed:
                                            _toggleConfirmPasswordVisibility,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'kata sandi tidak boleh kosong.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jam Keberangkatan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !_showConfirmPassword,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 21, vertical: 10),
                                      // labelText: 'Old Password',
                                      hintText: 'Konfirmasi Kata Sandi Baru',
                                      suffixIcon: IconButton(
                                        icon: Icon(_showConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed:
                                            _toggleConfirmPasswordVisibility,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'kata sandi tidak boleh kosong.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
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
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !_showObject,
                child: Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              // TODO: Implement search/filter logic
                              setState(() {
                                _searchResult = _filteredKotaAsal.where((city) {
                                  final cityName = city['nama_kota'] as String;
                                  return cityName
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                                }).toList();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _filteredKotaAsal != null
                              ? ListView.builder(
                                  itemCount: _filteredKotaAsal.length,
                                  itemBuilder: (context, index) {
                                    final city = _filteredKotaAsal[index];

                                    return ListTile(
                                      title: Text(city['nama_kota'] as String),
                                      onTap: () {
                                        setState(() {
                                          _selectedKotaAsalNama =
                                              city['nama_kota'];
                                          _selectedKotaAsalId = city['id'];
                                          _searchController.text =
                                              _selectedKotaAsalNama!;
                                        });
                                        _handleTap();
                                        print(_selectedKotaAsalNama);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
