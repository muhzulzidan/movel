import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 110,
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
                ": $value",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class PesananBaruScreen extends StatelessWidget {
  final List<dynamic> acceptedOrders;

  PesananBaruScreen({
    required this.acceptedOrders,
  });
  @override
  Widget build(BuildContext context) {
    print("PesananBaruScreen : ${acceptedOrders}");
    // print("PesananBaruScreen : ${acceptedOrders['passenger_name']}");
    return Scaffold(
        appBar: AppBar(
          title: Text('Pesanan Baru'),
        ),
        body: Stack(children: [
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
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: acceptedOrders.map<Widget>((order) {
                                return Card(
                                  color: Colors.deepPurple.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomRow(
                                          label: 'Nama',
                                          value: order['passenger_name'],
                                        ),
                                        CustomRow(
                                          label: 'Asal Kota',
                                          value: order['kota_asal'],
                                        ),
                                        CustomRow(
                                          label: 'Kota Tujuan',
                                          value: order['kota_tujuan'],
                                        ),
                                        CustomRow(
                                          label: 'Tanggal',
                                          value: order['date_order'],
                                        ),
                                        // CustomRow(
                                        //   label: 'Jam',
                                        //   value: order['jam'],
                                        // ),
                                        // CustomRow(
                                        //   label: 'Kode Kursi',
                                        //   value: order['kode_kursi'],
                                        // ),
                                        // CustomRow(
                                        //   label: 'Titik Jemput',
                                        //   value: order['titik_jemput'],
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implement logic for rejecting the order
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 13),
                                    backgroundColor: Colors.grey,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Text(
                                    'Tolak',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implement logic for accepting the order
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 13),
                                    backgroundColor: Colors.amber,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Text(
                                    'Terima',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.alarm,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '28 Detik Tersisa',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )))
        ]));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
