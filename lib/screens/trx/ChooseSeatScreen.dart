import 'package:flutter/material.dart';

import 'KonfirmasiPesananScreen.dart';

class ChooseSeatScreen extends StatefulWidget {
  const ChooseSeatScreen({Key? key}) : super(key: key);

  @override
  _ChooseSeatScreenState createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  List<String> _seats = ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Kursi Anda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Expanded(
            child: GridView.builder(
              itemCount: _seats.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[200],
                  child: InkWell(
                    onTap: () {
                      // TODO: Select the seat
                    },
                    child: Center(
                      child: Text(
                        _seats[index],
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text("Pastikan kursi yang kamu pilih sudah sesuai keinginan kamu"),
          Text("Keterangan : "),
          Text("Ungu :  Kursi sudah dipesan "),
          Text("Putih : Kursi tersedia"),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KonfirmasiPesananScreen()),
                );
              },
              child: Text("Oke"))
        ]),
      ),
    );
  }
}
