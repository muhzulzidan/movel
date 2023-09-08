import 'package:flutter/material.dart';

class AlamatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alamat'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Alamat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Rumah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  // TODO: Add logic to navigate to Tambahkan Rumah screen.
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 10),
                      Text('Tambahkan Rumah'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tempat Kerja',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  // TODO: Add logic to navigate to Tambahkan Tempat Kerja screen.
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(width: 10),
                      Text('Tambahkan Tempat Kerja'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Alamat Lainnya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  // TODO: Add logic to navigate to Tambah Baru screen.
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text('Tambah Baru'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
