import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'ChooseSeatScreen.dart';

class DriverProfileScreen extends StatelessWidget {
  final String driverName = 'John Doe';
  final String driverImage = 'assets/driverProfile.png';
  final String carBrand = 'Honda Jazz';
  final String carColor = 'Silver';
  final int seatsAvailable = 4;
  final bool isSmokingAllowed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Sopir',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: HexColor("#60009A"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driverName,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person_4,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '45 tahun',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '$carBrand - $carColor',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.chair_alt,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'kyrsi 7',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.smoking_rooms,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'sebat lah',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(children: [
                    Container(
                      height: 200,
                      width: 150,
                    ),
                    Positioned(
                      bottom: 0,
                      right: -100,
                      child: Container(
                        height: 250,
                        width: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(driverImage),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                ),
                Positioned(
                  top: 130,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 300, // Adjust the height as needed
                    decoration: BoxDecoration(
                      color: HexColor(
                          "#60009A"), // Replace with your desired background color
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 80,
                            ),
                            backgroundColor: Colors.amber,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseSeatScreen()),
                            );
                          },
                          child: Text(
                            "Pilih",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Rating: 4.5", // Replace with your rating value
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 30,
                  right: 30,
                  child: Image.asset(
                    "assets/mobilDriver.png", // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
