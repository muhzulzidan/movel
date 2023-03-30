import 'package:flutter/material.dart';
import 'package:movel/screens/auth/intro.dart';
import 'package:movel/controller/auth/auth_state.dart';
import 'package:movel/screens/profile/alamat.dart';
import 'package:movel/screens/profile/edit_profile.dart';
import 'package:movel/screens/profile/pengaturan.dart';
import 'package:movel/screens/profile/pusat_bantuan.dart';
import 'package:movel/screens/profile/riwayat_pesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../home/token.dart';
import 'change_password.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> logout(BuildContext context, String token) async {
    final url = Uri.parse('https://admin.movel.id/api/user/logout');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Logout was successful
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed')),
      );
      // Logout failed
    }
  }

  String _userName = '';
  // String _u = '';
  late Map<String, dynamic> _userData = {};

  Future<void> _loadUserData() async {
    try {
      final userService = UserService();
      final user = await userService.getUser();
      setState(() {
        _userName = user["user"]["name"].toString();
        _userData = user;
      });
      print('testtt');
      print(_userName);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      _loadUserData();
    } catch (e) {
      print('Caught exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(userData: _userData),
                          ),
                        );
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "${_userData["user"]["name"]}",
                              "${_userName}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            // Text('Edit Profil'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Edit Profil'),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ])
                      // Text(
                      //   "${_userData["user"]["name"]}",
                      //   // "${_userName}",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 25,
                      //       color: Colors.black),
                      // ),
                      ),
                  // SizedBox(width: 0),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/placeholderPhoto.png'),
                    ),
                  ),
                  // SizedBox(width: 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    // leading: Icon(Icons.person),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to personal information screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TokecScreen()),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    // leading: Icon(Icons.lock),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ubah kata sandi',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()),
                      );

                      // TODO: Navigate to change password screen.
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    // leading: Icon(Icons.lock),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Riwayat pesanan',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RiwayatPesananScreen()),
                      );
                      // TODO: Navigate to change password screen.
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    // leading: Icon(Icons.lock),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat bantuan',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PusatBantuanScreen(userName: _userName)));
                      // TODO: Navigate to change password screen.
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    // leading: Icon(Icons.lock),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengaturan',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PengaturanScreen()),
                      );
                      // TODO: Navigate to change password screen.
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    // leading: Icon(Icons.lock),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alamat',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlamatScreen()));
                      // TODO: Navigate to change password screen.
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    // leading: Icon(Icons.exit_to_app),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keluar',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      // final SharedPreferences? prefs = await _prefs;
                      // print(prefs?.get('message'));
                      final token = prefs.getString('token');
                      logout(context, token!);
                      // TODO: Log out the user and navigate to the login screen.
                    },
                  ),
                ],
              ),
            ),
            // Container(
            //     alignment: Alignment.centerRight,
            //     child: Image.asset("assets/bgProfile.png"))
          ],
        ),
        Positioned(
          bottom: 20,
          right: 0,
          child: Container(
            alignment: Alignment.centerRight,
            child: Image.asset("assets/bgProfile.png"),
          ),
        ),
      ]),
    );
  }
}
