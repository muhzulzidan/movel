import 'package:flutter/material.dart';

import 'home/home.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Kotak Masuk",
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: ListTile(
                title: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/driverProfile.png",
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                          "Halo Zidan, \nKami ingin memberitahu Anda bahwa perjalanan Anda dengan sopir kami sudah berhasil diatur.",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
          Container(
            width: double.infinity,
            child: ListTile(
                title: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/driverProfile.png",
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Halo Zidan, \nKami ingin memberitahu Anda bahwa perjalanan Anda dengan sopir kami sudah berhasil diatur.",
                        style: TextStyle(fontSize: 13),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
