import 'package:flutter/material.dart';

class AvailableDriversScreen extends StatefulWidget {
  @override
  _AvailableDriversScreenState createState() => _AvailableDriversScreenState();
}

class _AvailableDriversScreenState extends State<AvailableDriversScreen> {
  List<String> _availableDrivers = [
    'Sopir 1',
    'Sopir 2',
    'Sopir 3',
    'Sopir 4',
    'Sopir 5',
    'Sopir 6',
    'Sopir 7',
    'Sopir 8',
    'Sopir 9',
    'Sopir 10',
    'Sopir 11',
    'Sopir 12',
    'Sopir 13',
    'Sopir 14',
    'Sopir 15',
    'Sopir 16',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple[800],
        title: Text(
          'Sopir yang Tersedia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                // height: 20,
                ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Sopir',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                // implement searching logic here
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pilih Sopirmu',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _availableDrivers.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    shadowColor: Colors.grey[200],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/driver.png'),
                      ),
                      title: Text(
                        _availableDrivers[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tidak merokok'),
                          Text('Kursi: 4'),
                          Text('Mobil: Honda Jazz'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to driver details screen
                      },
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
