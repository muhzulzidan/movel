import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChooseSeatScreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DriverProfileScreen extends StatefulWidget {
  final Map<String, dynamic> driverData;
  DriverProfileScreen({required this.driverData});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  Map<String, dynamic> driverData = {};
  bool isLoading = true;
  late int id = widget.driverData["id"];
  @override
  void initState() {
    super.initState();
    fetchDriverData();
    //     final id = widget.driverData["id"];
    // print(id);
  }

  Future<void> fetchDriverData() async {
    final id = widget.driverData["id"];
    final String url = 'https://api.movel.id/api/user/drivers/available/$id';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await Requests.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.json();
      print(data);
      setState(() {
        driverData = data['data'] as Map<String, dynamic>;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch driver data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String driverName = driverData.containsKey('driver_name')
        ? driverData['driver_name'] as String
        : '';
    final String driverImage = 'assets/driverProfile.png';
    final String carBrand = driverData.containsKey('car_merk')
        ? driverData['car_merk'] as String
        : '';
    final int year = driverData.containsKey('driver_age')
        ? driverData['driver_age'] as int
        : 0;
    final int seatsAvailable = driverData.containsKey('car_seat_capacity')
        ? driverData['car_seat_capacity'] as int
        : 0;
    final int rating = driverData.containsKey('rating')
        ? driverData['rating'] is int
            ? driverData['rating']
            : int.tryParse(driverData['rating']) ?? 0
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Sopir',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driverName,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_4,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${year} tahun',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '$carBrand',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.airline_seat_recline_normal,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '$seatsAvailable kursi',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                widget.driverData['is_smoking'] == 'Merokok'
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.smoking_rooms,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            widget.driverData['is_smoking']
                                                as String,
                                            style: TextStyle(),
                                          ),
                                        ],
                                      )
                                    : widget.driverData['is_smoking'] ==
                                            'Tidak Merokok'
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.smoke_free,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                widget.driverData['is_smoking']
                                                    as String,
                                                style: TextStyle(),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 150,
                            ),
                            Positioned(
                              bottom: 0,
                              right: -100,
                              child: Container(
                                height: 250,
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(driverImage),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.449,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 130,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade700,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: 80,
                                  ),
                                  backgroundColor: Colors.amber,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseSeatScreen(driverId: id)),
                                  );
                                },
                                child: Text(
                                  "Pilih",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: RatingBarIndicator(
                                  rating: driverData.containsKey('rating')
                                      ? (driverData['rating'] is String
                                          ? double.tryParse(
                                                  driverData['rating']) ??
                                              0.0
                                          : driverData['rating'].toDouble())
                                      : 0.0,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 25,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Text(
                                "Rating : ${driverData['rating']}",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 30,
                        right: 30,
                        child: Image.asset(
                          "assets/mobilDriver.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
