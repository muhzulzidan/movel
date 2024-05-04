import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  EditProfileScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple.shade500, // Lighter shade
      ),
      body: Padding(
        padding: EdgeInsets.all(0), // Padding around the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade500), // Lighter shade
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/placeholderPhoto.png'),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            Card(
              // Card for a raised effect
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text('Nama Pengguna'),
                    ),
                    Expanded(
                      child: Text('${userData["name"]}',
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold)), // Different font style
                    ),
                  ],
                ),
              ),
            ),
            // Divider(
            //   color: Colors.white,
            // ),
            Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text('E-mail'),
                    ),
                    Expanded(
                      child: Text('${userData["email"]}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            // Divider(
            //   color: Colors.white,
            // ),
            Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text('No. Handphone'),
                    ),
                    Expanded(
                      child: Text('${userData["no_hp"]}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            // Divider(
            //   color: Colors.white,
            // ),
            Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text('Alamat'),
                    ),
                    Expanded(
                      child: Text(
                        userData["alamat"] ?? "kosong",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Divider(
            //   color: Colors.white,
            // ),
            Card(
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Log Out'),
                onTap: () {
                  // TODO: Log out the user and navigate to the login screen.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
