import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'KonfirmasiPesananScreen.dart';

class ChooseSeatScreen extends StatefulWidget {
  final int driverId;

  const ChooseSeatScreen({Key? key, required this.driverId}) : super(key: key);
  @override
  _ChooseSeatScreenState createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  List<Map<String, dynamic>> _seats = [];
  Set<Map<String, dynamic>> _selectedSeats = <Map<String, dynamic>>{};

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchSeatData();
  }

  Future<void> fetchSeatData() async {
    setState(() {
      _isLoading = true;
    });

    final String url =
        'https://api.movel.id/api/user/drivers/available/${widget.driverId}/seat_cars';
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
      final List<dynamic> seats = data['data']['label_seats'];

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

  Future<void> _submitOrder() async {
    // Prepare the request body
    final List<String> seatChoices =
        _selectedSeats.map((seat) => seat['id_label'] as String).toList();

    print(seatChoices);
    print(widget.driverId);

    final requestBody = '''
    {
    "driver_departure_id": ${widget.driverId},
    "seat_car_choices": $seatChoices
    }
    ''';

    // Make the API request
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String url = 'https://api.movel.id/api/user/orders/resume';

    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      // Navigate to the KonfirmasiPesananScreen
      final responseData = json.decode(response.body);

      print(responseData);
      print(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              KonfirmasiPesananScreen(responseData: responseData['data']),
        ),
      );
    } else {
      // Handle error response
      try {
        final Map<String, dynamic> errorData = json.decode(response.content());
        final errorMessage = errorData['message'];
        print(response.request);
        print(response.json());
        print(response);
        throw Exception('Failed to submit order: $errorMessage');
      } catch (e) {
        print(response.json());
        print(response.request);
        print(response.body);
        print(response.headers);
        // print(response.json());
        throw Exception('Failed to submit order: Unknown error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_seats);
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade700,
            ),
            child: Text(
              "Pilih kursi sesuai keinginan Anda \n untuk kenyamanan maksimal",
              style: TextStyle(
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
            width: 200,
            height: 280,
            alignment: Alignment.center,
            padding: EdgeInsets.all(29),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/car.png'),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_seats.length > 0) buildSeatCard(_seats[0]),
                          SizedBox(width: 4),
                          if (_seats.length > 1) buildSeatCard(_seats[1]),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_seats.length > 2) buildSeatCard(_seats[2]),
                          SizedBox(width: 4),
                          if (_seats.length > 3) buildSeatCard(_seats[3]),
                          SizedBox(width: 4),
                          if (_seats.length > 4) buildSeatCard(_seats[4]),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_seats.length > 5) buildSeatCard(_seats[5]),
                          SizedBox(width: 4),
                          if (_seats.length > 6) buildSeatCard(_seats[6]),
                        ],
                      ),
                    ],
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
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.292,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 230,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/grayCars.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
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
                ),
              ),
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      _submitOrder();
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
