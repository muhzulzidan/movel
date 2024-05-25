import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../driver_home_content.dart';

class TopUpScreen extends StatelessWidget {
  final int saldo;

  TopUpScreen({required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 24, right: 10, bottom: 5, top: 40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade700,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverHomeContent()),
                      );
                    },
                    icon: Icon(Icons.close),
                    color: Colors.white,
                  ),
                  Text(
                    "Top up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.deepPurple.shade700),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 38, top: 25, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Poin Anda',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(height: 8),
                      Text(
                        '${NumberFormat.currency(locale: 'id', symbol: '').format(saldo)} Poin. ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Hai, untuk melakukan top up hanya dapat melalui Admin, '
                    'mohon untuk mengunjungi kantor Movel di',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jl. Lapawawoi Kr Sigeri Kel. Biru, Depannya Mesjid Nurul Hamirah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Terima kasih sudah bekerja sama dengan kami.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => launchUrl(Uri.parse(
                        'https://wa.me/+6285298751997?text=Movel%20Admin%20Top%20Up%20Poin%20Driver%20Movel%20ID%20%3A%20')),
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Hubungi Admin',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
