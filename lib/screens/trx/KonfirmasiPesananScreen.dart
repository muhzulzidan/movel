import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../pesanan.dart';
import 'OrderProgressScreen.dart';
import 'package:movel/controller/auth/current_index_provider.dart';

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class KonfirmasiPesananScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // backgroundColor: Colors.deepPurple.shade500,
        centerTitle: true,
        title: Text(
          'Konfirmasi Pesanan',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
          ),
          Positioned(
            right: -30,
            bottom: -30,
            child: Image.asset(
              'assets/konfirmasiCars.png',
              // fit: BoxFit.,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SizedBox(
                    //   height: 50,
                    // ),
                    Card(
                      color: Colors.deepPurple.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomRow(
                              label: 'Nama Sopir',
                              value: ': John Doe',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Umur',
                              value: ': 30',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Type Mobil',
                              value: ': Sedan',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Merokok',
                              value: ': Tidak',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Kode Kursi',
                              value: ': A1',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Asal Kota',
                              value: ': City A',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Kota Tujuan',
                              value: ': City B',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Tanggal',
                              value: ': 10 Mei 2023',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Pukul',
                              value: ': 09:00 - 12:00',
                            ),
                            SizedBox(height: 16.0),
                            CustomRow(
                              label: 'Harga',
                              value: ': Rp. 300.000',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 80,
            right: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13),
                backgroundColor: Colors.amber,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: () {
                // Update the bottom navigation index by calling the function with the desired index
                final currentIndexProvider =
                    Provider.of<CurrentIndexProvider>(context, listen: false);
                currentIndexProvider.setIndex(2);
                // TODO: Implement payment and confirmation logic
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PesananScreen(),
                  ),
                );
              },
              child: Text(
                'Konfirmasi Pesanan',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
