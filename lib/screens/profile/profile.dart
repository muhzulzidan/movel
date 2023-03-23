import 'package:flutter/material.dart';

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
                  onTap: () {
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
