import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PilihLokasiAsalScreen extends StatefulWidget {
  const PilihLokasiAsalScreen({Key? key}) : super(key: key);

  @override
  State<PilihLokasiAsalScreen> createState() => _PilihLokasiAsalScreenState();
}

class _PilihLokasiAsalScreenState extends State<PilihLokasiAsalScreen> {
  String _selectedLocation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Cari sopir',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("#60009A"),
      ),
      body: Column(
        children: [
          // Purple Background
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            color: HexColor("#60009A"),
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

          // // Search Field
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       children: [
          //         // Search Text Field
          //         TextFormField(
          //           decoration: InputDecoration(
          //             hintText: 'Cari Lokasi Asal Anda',
          //             prefixIcon: Icon(Icons.search),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Expanded(child: Placeholder()),
          //       ],
          //     ),
          //   ),
          // ),

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
                    child: Image.asset(
                      "assets/buntutMobil.png",
                    ),
                  ),
                ),

                // Text and Buttons
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Atau pilih kota asalmu di bawah ini",
                              style: TextStyle(),
                            )),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: ListTile(
                            // leading: Icon(Icons.place),
                            title: Text('Home'),
                            onTap: () {
                              setState(() {
                                _selectedLocation = 'Home';
                              });
                            },
                            selected: _selectedLocation == 'Home',
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.place),
                          title: Text('Work'),
                          onTap: () {
                            setState(() {
                              _selectedLocation = 'Work';
                            });
                          },
                          selected: _selectedLocation == 'Work',
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
