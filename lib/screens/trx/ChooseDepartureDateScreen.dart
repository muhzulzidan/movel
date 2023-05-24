// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AvailableDriversScreen.dart';

class ChooseDepartureDateScreen extends StatefulWidget {
  @override
  _ChooseDepartureDateScreenState createState() =>
      _ChooseDepartureDateScreenState();
}

class _ChooseDepartureDateScreenState extends State<ChooseDepartureDateScreen> {
  // final dio = Dio();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  TextEditingController _selectedDateController = TextEditingController();
  TextEditingController _selectedTimeController = TextEditingController();

  String _getTimeCategory(TimeOfDay time) {
    // Define time ranges for each category
    final morningTime = TimeOfDay(hour: 5, minute: 0);
    final afternoonTime = TimeOfDay(hour: 11, minute: 0);
    final eveningTime = TimeOfDay(hour: 15, minute: 0);
    final nightTime = TimeOfDay(hour: 18, minute: 0);

    // Compare the selected time with the time ranges
    if (_isTimeInRange(time, morningTime, afternoonTime)) {
      return "1";
    } else if (_isTimeInRange(time, afternoonTime, eveningTime)) {
      return '2';
    } else if (_isTimeInRange(time, eveningTime, nightTime)) {
      return '3';
    } else {
      return '4';
    }
  }

  bool _isTimeInRange(
    TimeOfDay time,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) {
    final currentTimeInMinutes = time.hour * 60 + time.minute;
    final startTimeInMinutes = startTime.hour * 60 + startTime.minute;
    final endTimeInMinutes = endTime.hour * 60 + endTime.minute;

    return currentTimeInMinutes >= startTimeInMinutes &&
        currentTimeInMinutes < endTimeInMinutes;
  }

  // void _setDateTime() async {
  //   if (_selectedTime == null) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('Please select both date and time of departure.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //     return;
  //   }

  //   // Convert TimeOfDay to category
  //   String timeCategory = _getTimeCategory(_selectedTime);

  //   const url = 'https://api.movel.id/api/user/rute_jadwal/date_time';
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     // 'Content-Type': 'application/json',
  //     // "Connection": 'keep-alive'
  //   };
  //   final body = {
  //     // 'date_departure': DateFormat('yyyy-MM-dd').format(_selectedDate),
  //     // 'time_departure_id': timeCategory,
  //     "date_departure": "2023-05-20",
  //     "time_departure_id": "1"
  //     // 'time_departure_id': '${_selectedTime.hour}:${_selectedTime.minute}',
  //   };

  //   try {
  //     final response = await Requests.post(url, headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       final data = response.json();
  //       print(data);
  //       print(response.headers);
  //       print(response.request);
  //       // Date and time successfully set, navigate to the next screen
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => AvailableDriversScreen()),
  //       );
  //     } else {
  //       // Handle the error response
  //       final errorMessage = (response.json())['message'];
  //       final errorMessageraw = (response.json());
  //       print(errorMessageraw);
  //       print(response.headers);
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text('Error'),
  //           content: Text(errorMessage),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     // Handle the network error
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('An error occurred. Please try again.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // Set the default selected date to today
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentukan Tanggal Keberangkatan',
          style: TextStyle(fontSize: 15, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: HexColor("#60009A"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: HexColor("#60009A")),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tanggal Keberangkatan",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextFormField(
                        controller: _selectedDateController,
                        decoration: InputDecoration(
                          labelStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                          hintText: 'Pilih Tanggal Keberangkatan',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 21),
                            child: Icon(Icons.calendar_month_outlined),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                              _selectedDateController.text =
                                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jam Keberangkatan",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextFormField(
                        controller: _selectedTimeController,
                        decoration: InputDecoration(
                          labelStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                          hintText: 'Pilih Jam Keberangkatan',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 21),
                            child: Icon(Icons.schedule),
                          ),
                        ),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null && picked != _selectedTime) {
                            setState(() {
                              _selectedTime = picked;
                              _selectedTimeController.text =
                                  "${_selectedTime.hour}:${_selectedTime.minute}";
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13),
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
                      builder: (context) => AvailableDriversScreen()),
                );
              },
              // onPressed: _submitForm,
              child: Text(
                'Simpan',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 300,
                height: 350,
                decoration: BoxDecoration(),
                child: Image.asset(
                  'assets/Waktukeberangkatan.png',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
