// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:movel/screens/auth/intro.dart';
import 'package:movel/controller/auth/auth_state.dart';
import 'package:movel/screens/profile/alamat.dart';
import 'package:movel/screens/profile/edit_profile.dart';
import 'package:movel/screens/profile/pengaturan.dart';
import 'package:movel/screens/profile/pusat_bantuan.dart';
import 'package:movel/screens/profile/riwayat_pesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

import '../home/token.dart';
import 'change_password.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> logout(BuildContext context, String token) async {
    // final dio = Dio();
    // var cookieJar = CookieJar();

    // Add the CookieJar to Dio's HttpClientAdapter

    // final options = Options(
    //   headers: {
    //     'Authorization': 'Bearer $token',
    //   },
    // );

    final response = await Requests.post(
      'https://api.movel.id/api/user/logout',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Logout was successful
      final responseData = response.json();
      print(responseData);
      print(response.headers);
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    } else {
      print(response);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed')),
      );
      // Logout failed
    }
  }

  String _userName = '';
  // String _userName = '';
  // String _u = '';
  late Map<String, dynamic> _userData = {};

  Future<void> _loadUserData() async {
    late String token;

    Future<void> _getSharedPrefrences() async {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';
    }

    try {
      final userService = UserService();
      final user = await userService.getUser();
      setState(() {
        // _userName = user["user"]["name"].toString();
        _userName = user[0]['name'].toString();

        _userData = user[0];
      });
      print('profile testtt');
      print(_userName);
    } catch (e) {
      print("dari profil : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _anjay();
    try {
      _loadUserData();
    } catch (e) {
      print('Caught profilscren exception: $e');
    }
  }

  _anjay() async {
    final prefs = await SharedPreferences.getInstance();
    // final SharedPreferences? prefs = await _prefs;
    // print(prefs?.get('message'));
    final token = prefs.getString('token');
    // tokenText = token;
    print("ini profile token get : $token");
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
                          // '$_userData',
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
                      print(token);
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
