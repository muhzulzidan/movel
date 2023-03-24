import 'package:flutter/material.dart';
import 'package:movel/screens/auth/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/token.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Text(
                        "Zidan",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                      Text("Edit Profil")
                    ],
                  ),
                ),
                // SizedBox(width: 0),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/zidan.png'),
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
                  // leading: Icon(Icons.person),
                  title: Text('Personal Information'),
                  // trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to personal information screen.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TokecScreen()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  // leading: Icon(Icons.lock),
                  title: Text('Change Password'),
                  // trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // TODO: Navigate to change password screen.
                  },
                ),
                Divider(),
                ListTile(
                  // leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out'),
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
          Container(
              alignment: Alignment.centerRight,
              child: Image.asset("assets/bgProfile.png"))
        ],
      ),
    );
  }
}

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
