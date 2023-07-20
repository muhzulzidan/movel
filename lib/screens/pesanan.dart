import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'chat/inbox.dart';

class PesananScreen extends StatelessWidget {
  // final Function(int) updateSelectedIndex;

  // const PesananScreen({Key? key, required this.updateSelectedIndex})
  //     : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Progres Pesanan Anda"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              buildProgressTile(
                title: "Pesanan Diterima",
                icon: Icons.bookmark_added,
              ),
              buildProgressTile(
                title: "Sopir Menuju ke Lokasi Anda",
                icon: Icons.directions_run,
              ),
              buildProgressTile(
                title: "Sopir Telah Tiba di Lokasi Anda",
                icon: Icons.directions_car,
              ),
              buildProgressTile(
                title: "Anda Telah Tiba di Tujuan",
                icon: Icons.place,
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: buildDriverProfile(context)),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                "Promo Hari Ini",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        buildPromoImage('assets/promo.png'),
      ]),
    );
  }

  Widget buildPromoImage(String imageUrl) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProgressTile({required String title, required IconData icon}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32, // Adjust the size as needed
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                // Adjust the font size as needed
              ),
              maxLines: 2,
              textAlign: TextAlign.center, // Align the text to center if needed
              overflow: TextOverflow
                  .ellipsis, // Show ellipsis if the text exceeds two lines
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDriverProfile(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                "assets/placeholderPhoto.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "DW 4573 WT",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 4,
                    minimumSize:
                        Size(double.infinity, 0), // Fill available width
                  ),
                  onPressed: () {
                    // Show confirmation modal
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: AlertDialog(
                            content: Text(
                              "Yakin ingin membatalkan pesanan?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            buttonPadding: EdgeInsets.zero,
                            actionsPadding: EdgeInsets.symmetric(horizontal: 0),
                            actions: [
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      elevation: 4,
                                    ),
                                    onPressed: () {
                                      // User confirmed the cancellation
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      // TODO: Implement cancel order functionality
                                    },
                                    child: Text(
                                      "ya",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      elevation: 4,
                                    ),
                                    onPressed: () {
                                      // User chose not to cancel
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text("Tidak"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.cancel),
                  label: Text(
                    "Batalkan Pesanan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 1),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 4,
                    minimumSize:
                        Size(double.infinity, 0), // Fill available width
                  ),
                  onPressed: () {
                    // TODO: Implement chat functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InboxScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Chat dengan Sopir",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.send,
                          color: Colors.blue,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
