import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class DetailCarScreen extends StatefulWidget {
  final String token;

  DetailCarScreen({required this.token});

  @override
  _DetailCarScreenState createState() => _DetailCarScreenState();
}

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Text(
            ": $value",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailCarScreenState extends State<DetailCarScreen> {
  late Map<String, dynamic> _carDetails;

  @override
  void initState() {
    super.initState();
    _carDetails = {}; // Initialize _carDetails with an empty map
    _fetchCarDetails();
  }

  Future<void> _fetchCarDetails() async {
    try {
      final url = 'https://api.movel.id/api/user/cars';
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      final response = await Requests.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = response.json();
        final carData = jsonData['data'];
        setState(() {
          _carDetails = carData;
        });
      } else {
        throw Exception('Failed to fetch car details');
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: _carDetails.isNotEmpty
          ? Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                ),
                // Positioned(
                //   right: -30,
                //   bottom: -30,
                //   child: Image.asset(
                //     'assets/konfirmasiCars.png',
                //     // fit: BoxFit.,
                //   ),
                // ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // SizedBox(
                          //   height: 50,
                          // ),
                          Card(
                            color: Colors.deepPurple.shade500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 180,
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
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
                                          top: 30,
                                          left: 0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${_carDetails['merk']}',
                                                style: TextStyle(
                                                  height: 1,
                                                  fontSize: 24,
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${_carDetails['production_year']}',
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
                                          top: 30,
                                          right: 0,
                                          child: Container(
                                            child: Image.asset(
                                              "assets/mobilDriver.png",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Data STNK Sopir",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    CustomRow(
                                      label: 'Merk',
                                      value: '${_carDetails['merk']}',
                                    ),
                                    CustomRow(
                                      label: 'Type',
                                      value: '${_carDetails['type']}',
                                    ),
                                    CustomRow(
                                      label: 'Jenis',
                                      value: '${_carDetails['jenis']}',
                                    ),
                                    CustomRow(
                                      label: 'Model',
                                      value: '${_carDetails['model']}',
                                    ),
                                    CustomRow(
                                      label: 'Production Year',
                                      value:
                                          '${_carDetails['production_year']}',
                                    ),
                                    CustomRow(
                                      label: 'Isi Silinder',
                                      value: '${_carDetails['isi_silinder']}',
                                    ),
                                    CustomRow(
                                      label: 'License Plate Number',
                                      value:
                                          '${_carDetails['license_plate_number']}',
                                    ),
                                    CustomRow(
                                      label: 'Machine Number',
                                      value: '${_carDetails['machine_number']}',
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
