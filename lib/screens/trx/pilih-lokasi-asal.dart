import 'package:flutter/material.dart';

class PilihLokasiAsalScreen extends StatelessWidget {
  const PilihLokasiAsalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("cari"),
      ),
      body: Column(
        children: [
          // Purple Background
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            color: Colors.purple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image cut in half
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ClipRect(
                    child: Image.network(
                      'https://via.placeholder.com/300x600',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Lokasi Asal Anda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Search Field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Text Field
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Cari Lokasi Asal Anda',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Expanded(child: Placeholder()),
                ],
              ),
            ),
          ),

          // Images and Buttons
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: Row(
              children: [
                // Image cut in half
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ClipRect(
                    child: Image.network(
                      'https://via.placeholder.com/300x600',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Text and Buttons
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lokasi Terakhir Anda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Tidak Ada Data',
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Batal'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                onPrimary: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Pilih'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Gunakan Lokasi Saat Ini'),
                          ),
                        ),
                      ],
                    ),
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
