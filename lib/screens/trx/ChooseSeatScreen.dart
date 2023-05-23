import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'KonfirmasiPesananScreen.dart';

class ChooseSeatScreen extends StatefulWidget {
  const ChooseSeatScreen({Key? key}) : super(key: key);

  @override
  _ChooseSeatScreenState createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  List<String> _seats = [];
  Set<String> _selectedSeats = <String>{};
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchSeatData();
  }

  Future<void> fetchSeatData() async {
    final String url = 'https://api.movel.id/api/user/drivers/list_seat_car';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> seats = data['data'];

      setState(() {
        _seats = seats
            .where((seat) => seat['is_filled'] == 0)
            .map((seat) => seat['label_seat'] as String)
            .toList();
      });
    } else {
      throw Exception('Failed to fetch seat data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
        title: Text(
          'Pilih Kursi Anda',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
          ),
          child: Text(
            "Pilih kursi sesuai keinginan Anda \n untuk kenyamanan maksimal",
            style: TextStyle(
              // fontSize: 19,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            "Depan",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          // constraints: BoxConstraints.expand(),
          width: 200,
          height: 280,
          alignment: Alignment.center,
          padding: EdgeInsets.all(29),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/car.png'), // Replace with your desired background image
              // fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(
                10.0), // Adjust the border radius as needed
          ),
          child: GridView.builder(
            itemCount: _seats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 7,
              childAspectRatio: .7,
            ),
            itemBuilder: (context, index) {
              final seat = _seats[index];
              final isSelected = _selectedSeats.contains(seat);
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(),
                child: InkWell(
                  onTap: () {
                    // TODO: Select the seat
                    setState(() {
                      if (isSelected) {
                        _selectedSeats.remove(seat);
                      } else {
                        _selectedSeats.add(seat);
                      }
                    });
                  },
                  splashColor: Colors.amber,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isSelected
                          ? Colors.deepPurple.shade700
                          : Colors.transparent,
                      // color: Colors.yellow, // Set the background color when the seat is selected
                      border: Border.all(
                        color:
                            Colors.deepPurple.shade700, // Set the border color
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _seats[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Pastikan kursi yang kamu pilih sudah"),
        Text(
          "sesuai keinginan kamu",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.292,
            ),
            Positioned(
              bottom: 0, // Position the image at the bottom of the stack
              left: 0,
              right: 0,
              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/grayCars.png'), // Replace with your desired background image
                    fit: BoxFit.fitWidth,
                  ),
                ),
                // child: Image.asset("assets/grayCars.png")
              ),
            ),
            Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      "Keterangan : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ungu :  Kursi sudah dipesan "),
                        Text("Putih : Kursi tersedia"),
                      ],
                    ),
                  ],
                )),
            Positioned(
              bottom: 60, // Adjust the position of the button as needed
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KonfirmasiPesananScreen()),
                    );
                  },
                  child: Text(
                    "Oke",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
