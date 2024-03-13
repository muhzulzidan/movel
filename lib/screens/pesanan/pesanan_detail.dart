import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverDetailScreen extends StatelessWidget {
  final Map<String, dynamic> driverData;

  DriverDetailScreen({required this.driverData});

  @override
  Widget build(BuildContext context) {
    print("driverData : $driverData");
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Sopirnya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(driverData['driver_photo']),
                  radius: 30,
                ),
                title: Text(driverData['driver_name']),
                subtitle: Text('Email: ${driverData['driver_email']}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(driverData['kota_asal'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Kota Asal'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(driverData['kota_tujuan'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Kota Tujuan'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(driverData['car_plate_number'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Nomor Plat Mobil'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                    DateFormat('d MMMM yyyy', 'id_ID')
                        .format(DateTime.parse(driverData['date_order'])),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Tanggal Pesanan'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(driverData['time_order'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Waktu Pesanan'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                    driverData['is_smoking_allowed'] == 1 ? 'Ya' : 'Tidak',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Boleh Merokok'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
