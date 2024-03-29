import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailMobilDriverScreen.dart';

class LihatJenisMobilScreen extends StatefulWidget {
  @override
  State<LihatJenisMobilScreen> createState() => _LihatJenisMobilScreenState();
}

class _LihatJenisMobilScreenState extends State<LihatJenisMobilScreen> {
  List<Map<String, dynamic>> _seats = [];
  Set<Map<String, dynamic>> _selectedSeats = <Map<String, dynamic>>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSeatData();
  }

  Future<void> fetchSeatData() async {
    setState(() {
      _isLoading = true;
    });

    final String url = 'https://api.movel.id/api/user/cars/seat_car';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await Requests.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.json();
      final List<dynamic> seats = data['data']['car_seats'];

      setState(() {
        _seats = seats.map((seat) {
          final bool isFilled = seat['is_filled'] == 1;
          return {
            'id_label': seat['id_label'].toString(),
            'label_seat': seat['label_seat'] as String,
            'is_filled': isFilled,
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch seat data');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Jenis Mobil'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          JenisMobilCard(
            namaMobil: 'Avanza',
            tahunMobil: "2023",
            gambarMobil: 'assets/mobilDriver.png',
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Tipe Kursi Mobil",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Depan",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/car.png'), // Replace with your desired background image
                      // fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    // color: Colors.amber,
                  ),
                  child: RotatedBox(
                    quarterTurns: 4,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_seats.length > 0)
                                    buildSeatCard(_seats[0]),
                                  SizedBox(width: 4),
                                  if (_seats.length > 1)
                                    buildSeatCard(_seats[1]),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_seats.length > 2)
                                    buildSeatCard(_seats[2]),
                                  if (_seats.length > 3) SizedBox(width: 4),
                                  if (_seats.length > 3)
                                    buildSeatCard(_seats[3]),
                                  if (_seats.length > 4) SizedBox(width: 4),
                                  if (_seats.length > 4)
                                    buildSeatCard(_seats[4]),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_seats.length > 5)
                                    buildSeatCard(_seats[5]),
                                  SizedBox(width: 4),
                                  if (_seats.length > 6)
                                    buildSeatCard(_seats[6]),
                                ],
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

  Widget buildSeatCard(Map<String, dynamic> seat) {
    final String labelSeat = seat['label_seat'] as String;
    final bool isSelected = _selectedSeats.contains(seat);
    final bool isFilled = seat['is_filled'] as bool;
    final Color backgroundColor =
        isSelected ? Colors.deepPurple.shade700 : Colors.transparent;
    final TextStyle textStyle = TextStyle(
      fontSize: labelSeat == 'Sopir' ? 10 : 15,
      fontWeight: FontWeight.bold,
      color: isFilled
          ? Colors.white
          : isSelected
              ? Colors.white
              : Colors.black,
    );

    return isFilled
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 4),
            child: Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple.shade700,
                border: Border.all(
                  color: Colors.deepPurple.shade700,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  labelSeat,
                  style: textStyle,
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSeats.remove(seat);
                } else {
                  _selectedSeats.add(seat);
                }
              });
            },
            splashColor: Colors.amber,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 4),
              child: Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: backgroundColor,
                  border: Border.all(
                    color: Colors.deepPurple.shade700,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    labelSeat,
                    style: textStyle,
                  ),
                ),
              ),
            ),
          );
  }
}

class JenisMobilCard extends StatelessWidget {
  final String namaMobil;
  final String tahunMobil;
  final String gambarMobil;

  const JenisMobilCard({
    required this.namaMobil,
    required this.gambarMobil,
    required this.tahunMobil,
  });

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCarScreen(token: '$token'),
          ),
        );
      },
      child: Card(
        color: Colors.deepPurple.shade700,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Container(
              height: 180,
            ),
            Positioned(
              top: 32,
              left: 30,
              child: Row(
                children: [
                  Text(
                    "Jenis mobil yang terdaftar:",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaMobil,
                    style: TextStyle(
                      height: 1,
                      fontSize: 24,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tahunMobil,
                    style: TextStyle(
                      height: 1,
                      fontSize: 24,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 45,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  gambarMobil,
                  width: MediaQuery.of(context).size.width / 1.8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
