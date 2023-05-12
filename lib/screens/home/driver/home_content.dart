import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DriverHomeContent extends StatefulWidget {
  const DriverHomeContent({super.key});

  @override
  State<DriverHomeContent> createState() => _DriverHomeContentState();
}

class _DriverHomeContentState extends State<DriverHomeContent> {
  int saldo = 900000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("driverContent"),
      // ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple[800],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/driverHero.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // height: double.infinity,
                  ),
                  Positioned(
                    // height: double.infinity,
                    top: 50,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.power_settings_new, color: Colors.white),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Tidak Aktif',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    top: 120,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.deepPurple[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Atur Rute dan Jadwal',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    bottom: 15,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Pesan Sekarang',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    bottom: 15,
                    left: 25,
                    right: 25,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Saldo:",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    "Rp $saldo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement top up functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  backgroundColor: Colors.deepPurple[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.control_point,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Top Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Cek Jumlah dan kursi penumpangmu hari ini ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '4',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '5',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '6',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement seat functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            backgroundColor: Colors.grey[800],
                            shape: CircleBorder(),
                            elevation: 4,
                          ),
                          child: Text(
                            '7',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
