import 'dart:math';

import 'package:flutter/material.dart';

class OrderProgressScreen extends StatelessWidget {
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
                icon: Icons.bookmark_add,
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
                icon: Icons.check_circle,
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: buildDriverProfile()),
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
        // Column(
        //   children: [
        //     buildPromoImage('assets/promo.png'),
        //     // buildPromoImage('assets/promo.png'),
        //   ],
        // ),
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

  Widget buildDriverProfile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(10.0),
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
                    // TODO: Implement chat functionality
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
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 4,
                    minimumSize:
                        Size(double.infinity, 0), // Fill available width
                  ),
                  onPressed: () {
                    // TODO: Implement cancel order functionality
                  },
                  child: Text(
                    "Chat dengan Sopir",
                    textAlign: TextAlign.center,
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
