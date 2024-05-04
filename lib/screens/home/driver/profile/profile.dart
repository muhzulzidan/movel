import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movel/screens/auth/intro.dart';
import 'package:movel/controller/auth/auth_state.dart';
import 'package:movel/screens/home/driver/profile/alamat.dart';
import 'package:movel/screens/home/driver/profile/edit_profile.dart';
import 'package:movel/screens/home/driver/profile/pengaturan.dart';
import 'package:movel/screens/home/driver/profile/pusat_bantuan.dart';
import 'package:movel/screens/home/driver/profile/riwayat_pesanan.dart';
import 'package:movel/screens/home/driver/profile/LihatJenisMobilScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';

// import '../home/token.dart';
import 'change_password.dart';

class DriverProfileScreen extends StatefulWidget {
  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  Future<void> logout(BuildContext context, String token) async {
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
    }
  }

  String _userName = '';
  late String _userPhoto = '';
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
        _userPhoto = user[0]['photo'];

        _userData = user[0];
      });
      print('profile driver screen : $_userData');
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
    // print("_userPhoto : $_userPhoto");
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: Column(
            children: [
              // SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(color: Colors.deepPurple.shade700),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                                  _userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                // Text('Edit Profil'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Edit Profil',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 12, color: Colors.white),
                                  ],
                                ),
                              ])),
                      // SizedBox(width: 0),
                      FutureBuilder(
                        future:
                            _loadUserData(), // Replace this with your actual future
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepPurple.shade700,
                                backgroundImage:
                                    AssetImage('assets/placeholderPhoto.png'),
                              ),
                            ); // Show loading spinner while waiting
                          } else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepPurple.shade700,
                                backgroundImage:
                                    AssetImage('assets/placeholderPhoto.png'),
                              ),
                            ); // Show error message if something went wrong
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepPurple.shade700,
                                backgroundImage: NetworkImage(
                                    'https://api.movel.id/storage/${_userData['photo'].replaceFirst('public/', '')}'),
                              ),
                            );
                          }
                        },
                      )
                      // SizedBox(width: 2),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // Text(_userData['photo'] ?? 'Email'),
                    // Text(
                    //   _userData['photo'] != null
                    //       ? 'https://api.movel.id/storage/${_userData['photo'].replaceFirst('public/', '')}'
                    //       : 'Email',
                    // ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      // leading: Icon(Icons.person),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // '$_userData',
                            'Lihat Jenis Mobil',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Divider(
                            height: 30,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      // trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // // TODO: Navigate to personal information screen.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LihatJenisMobilScreen()),
                        );
                      },
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
                            color: Colors.black12,
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
                            color: Colors.black12,
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
                            color: Colors.black12,
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
                            color: Colors.black12,
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
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: AlertDialog(
                                  surfaceTintColor: Colors.white,
                                  contentPadding:
                                      EdgeInsets.only(top: 30, bottom: 10),
                                  buttonPadding: EdgeInsets.zero,
                                  actionsPadding: EdgeInsets.zero,
                                  content: Text(
                                    'Anda yakin ingin keluar?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  actions: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 30),
                                                backgroundColor: Colors.white,
                                                surfaceTintColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                elevation: 4,
                                              ),
                                              onPressed: () => Navigator.of(
                                                      context)
                                                  .pop(), // Close the dialog
                                              child: Text(
                                                'Batal',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 30),
                                                backgroundColor: Colors.amber,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                elevation: 4,
                                              ),
                                              onPressed: () async {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                final token =
                                                    prefs.getString('token');
                                                // Navigator.of(context)
                                                //     .pop(); // Close the dialog
                                                logout(context,
                                                    token!); // Log out the user
                                              },
                                              child: Text(
                                                'Ya',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //     bottom: 20,
        //     right: 0,
        //     child: Container(
        //       alignment: Alignment.centerRight,
        //       child: _userPhoto != null
        //           ? Image.network(
        //               'https://api.movel.id/storage/${_userPhoto.replaceFirst('/public/', '')}')
        //           : CircularProgressIndicator(), // or some other placeholder widget
        //     )),

        // FutureBuilder(
        //   future: _loadUserData(), // assuming _loadUserData() returns a Future
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator(); // or some other placeholder widget
        //     } else if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     } else {
        //       return Image.network(
        //           'https://api.movel.id/storage/${_userPhoto.replaceFirst('/public/', '')}');
        //     }
        //   },
        // )
      ]),
    );
  }
}
