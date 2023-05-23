import 'package:flutter/material.dart';

import 'ChooseSeatScreen.dart';

class DriverProfileScreen extends StatelessWidget {
  final String driverName = 'John Doe';
  final String driverImage = 'assets/driver.png';
  final String carBrand = 'Honda Jazz';
  final String carColor = 'Silver';
  final int seatsAvailable = 4;
  final bool isSmokingAllowed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sopir'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(driverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.directions_car, color: Colors.grey[500]),
                      SizedBox(width: 8),
                      Text(
                        '$carBrand - $carColor',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Informasi Sopir',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Nama Sopir'),
                    subtitle: Text(driverName),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_taxi),
                    title: Text('Mobil'),
                    subtitle: Text('$carBrand - $carColor'),
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Kapasitas'),
                    subtitle: Text('$seatsAvailable kursi'),
                  ),
                  ListTile(
                    leading: Icon(Icons.smoking_rooms),
                    title: Text('Merokok'),
                    subtitle: Text(isSmokingAllowed
                        ? 'Diperbolehkan'
                        : 'Tidak Diperbolehkan'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseSeatScreen()),
                  );
                },
                child: Text("Pilih"))
          ],
        ),
      ),
    );
  }
}
