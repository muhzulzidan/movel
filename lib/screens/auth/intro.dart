// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:hexcolor/hexcolor.dart';
import 'package:movel/screens/auth/login.dart';
import 'package:movel/screens/auth/register.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

var items = [
  {
    "foto": "assets/images/money.png",
    "heading": "Harga Pasti dan Jelas",
    "desc":
        "Anda dapat merencanakan perjalanan dengan lebih mudah dan aman tanpa khawatir akan biaya yang tidak terduga."
  },
  {
    "foto": "assets/images/sopir.png",
    "heading": "Sopir Profesional",
    "desc":
        "Sopir berintegritas, bertanggungjawab dan memahami rute perjalanan dengan baik"
  },
  {
    "foto": "assets/images/fleksibe.png",
    "heading": "Lebih Fleksibel",
    "desc": "Pesan kapan saja dan di mana saja"
  },
];

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  var isLogin = false.obs;
  int _current = 0;
  var itemCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 400,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: items.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                          width: double.infinity,
                          height: VisualDensity.maximumDensity,
                          // padding: EdgeInsets.symmetric(vertical: 40),
                          // decoration: BoxDecoration(color: HexColor("#F2F2F2")),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Image(
                                    image: AssetImage(
                                      '${i["foto"]}',
                                    ),
                                    height: 250),
                              ),
                              // SizedBox(
                              //   height: 40,
                              // ),
                              // SizedBox(
                              //   height: 50,
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [
                                    Text(
                                      '${i["heading"]}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        '${i["desc"]}',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  );
                }).toList(),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(color: HexColor("#F2F2F2")),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: items.asMap().entries.map((entry) {
            //       return GestureDetector(
            //         // onTap: () =>
            //         //     _controller.animateToPage(entry.key),
            //         child: Container(
            //           width: 12,
            //           height: 12,
            //           margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
            //           decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: (Theme.of(context).brightness == Brightness.dark
            //                       ? Colors.white
            //                       : Colors.deepPurple.shade700)
            //                   ?.withOpacity(_current == entry.key ? 1 : 0.1)),
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),

            SizedBox(
              height: 50,
            ),
            Container(
              // decoration: BoxDecoration(color: HexColor("#F2F2F2")),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.asMap().entries.map((entry) {
                  return GestureDetector(
                    // onTap: () =>
                    //     _controller.animateToPage(entry.key),
                    child: Container(
                      width: 10,
                      height: 10,
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.deepPurple.shade700)
                              .withOpacity(_current == entry.key ? 1 : 0.1)),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //   return Column(
  //     children: [
  //       SubmitButton(
  //         onPressed: () => loginController.loginWithEmail(),
  //         title: 'Login',
  //       )
  //     ],
  //   );
  // }
}
