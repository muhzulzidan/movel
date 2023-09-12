import 'package:flutter/material.dart';

class DriverInboxScreen extends StatefulWidget {
  @override
  _DriverInboxScreenState createState() => _DriverInboxScreenState();
}

class _DriverInboxScreenState extends State<DriverInboxScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Kotak Masuk",
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(

                text: "Terjadwal",
              ),
              Tab(

                text: "Sedang Proses",
              ),
              Tab(

                text: "Riwayat",
              ),
            ],
          ),

        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ListTile(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ChatScreen()),
                          // );
                        },
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
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
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
                  SizedBox(
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
            ),
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
