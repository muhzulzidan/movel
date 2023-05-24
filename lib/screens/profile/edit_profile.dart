import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  EditProfileScreen({required this.userData});

  // int no_hp = "userData["no_hp"]";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.purple.shade700),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/placeholderPhoto.png'),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          Divider(),
          Column(
            children: [Text('$userData')],
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text('Nama Pengguna'),
                ),
                Expanded(
                  child: Text('${userData["name"]}'),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text('E-mail'),
                ),
                Expanded(
                  child: Text('${userData["email"]}'),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text('No. Handphone'),
                ),
                Expanded(
                  child: Text('${userData["no_hp"]}'),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text('Alamat'),
                ),
                Expanded(
                  child: Text(
                    userData["alamat"] ?? "kosong",
                  ),
                ),
              ],
            ),
          ),
          Divider(),

          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Personal Information'),
          //   trailing: Icon(Icons.arrow_forward_ios),
          //   onTap: () {
          //     // TODO: Navigate to personal information screen.
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.lock),
          //   title: Text('Change Password'),
          //   trailing: Icon(Icons.arrow_forward_ios),
          //   onTap: () {
          //     // TODO: Navigate to change password screen.
          //   },
          // ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              // TODO: Log out the user and navigate to the login screen.
            },
          ),
        ],
      ),
    );
  }
}
