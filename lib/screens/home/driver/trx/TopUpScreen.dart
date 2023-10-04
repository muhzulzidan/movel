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
                        'Saldo',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(height: 8),
                      Text(
                        'Rp. ${NumberFormat.currency(locale: 'id', symbol: '').format(saldo)}',
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
                    'Jl. Jend. Ahmad Yani No. 50.',
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
                    // onPressed: () => launch('tel:+6281234567890'),
                    // onPressed: null,
                    onPressed: () => launchUrl(
                        'https://wa.me/+6281354789375?text=Hello' as Uri),

                    icon: Icon(Icons.call),
                    label: Text('Hubungi Admin'),
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
