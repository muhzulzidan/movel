import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../trx/ChooseLocationScreen.dart';

var items = [
  {
    "foto": "assets/ardi.png",
    "nama": "Adi",
    "mobil": "Alphard 2022",
    "kursi": "7 kursi",
    "merokok": "tidak merokok",
  },
  {
    "foto": "assets/driver.png",
    "nama": "Ahmad",
    "mobil": "Fortuner 2023",
    "kursi": "3 kursi",
    "merokok": "merokok",
  },
  {
    "foto": "assets/ardi.png",
    "nama": "Imam",
    "mobil": "Fortuner 2023",
    "kursi": "7 kursi",
    "merokok": "tidak merokok",
  },
  {
    "foto": "assets/driver.png",
    "nama": "Agung",
    "mobil": "Fortuner 2023",
    "kursi": "4 kursi",
    "merokok": "merokok",
  },
];

var promo = [
  {
    "foto": "assets/promo.png",
  },
  {
    "foto": "assets/promo2.png",
  },
  {
    "foto": "assets/promo.png",
  },
  {
    "foto": "assets/promo2.png",
  },
];

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({Key? key}) : super(key: key);

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var tokenText;
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(
            //   height: 25,
            // ),
            Stack(
              children: [
                Image.asset(
                  'assets/Hero.png',
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 15,
                  left: 70,
                  right: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        // print('context: $context');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseLocationScreen()),
                        );
                      },
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
                  bottom: 0.0,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rute yang tersedia",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text("Lihat Semua"),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 20),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                ),
                itemCount: (items.length / 2).ceil(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;

                  return Row(
                    children: [first, second].map((idx) {
                      if (idx < items.length) {
                        return Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: HexColor("#fff"),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.only(
                              right: 5,
                            ),
                            child: Card(
                              elevation: 4,
                              shadowColor: Colors.black,
                              color: Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: AssetImage(
                                            '${items[idx]["foto"]}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${items[idx]["nama"]}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  // background: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              '${items[idx]["mobil"]}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              '${items[idx]["kursi"]}',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              '${items[idx]["merokok"]}',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  );
                },
              ),
            ),

            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Promo Hari Ini",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text("Lihat Semua"),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 20),
              height: 200,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  // height: 200,
                ),
                itemCount: (promo.length / 2).ceil(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Container(
                    // height: 500,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          // [first, second].map((idx)
                          promo.map((i) {
                        // if (idx < promo.length) {
                        return Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Image.asset(
                            '${i["foto"]}',
                          ),
                        );
                        // } else {
                        //   return Container();
                        // }
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
