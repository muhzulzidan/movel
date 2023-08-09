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

// // This is the type used by the popup menu below.
// enum SampleItem { itemOne, itemTwo, itemThree }

class TimesofDepart {
  final int id;
  final String timeName;

  TimesofDepart({
    required this.id,
    required this.timeName,
  });
}

List<TimesofDepart> sampleItems = [
  TimesofDepart(id: 1, timeName: 'Pagi'),
  TimesofDepart(id: 2, timeName: 'Siang'),
  TimesofDepart(id: 3, timeName: 'Sore'),
  TimesofDepart(id: 4, timeName: 'Malam'),
  TimesofDepart(id: 5, timeName: 'Tengah Malam'),
];

class _ChooseDepartureDateScreenState extends State<ChooseDepartureDateScreen> {
  // final dio = Dio();
  TimesofDepart? selectedMenu;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedTimeValues;
  late String _selectedDateValues;
  TextEditingController _selectedDateController = TextEditingController();
  TextEditingController _selectedTimeController = TextEditingController();

  // String _getTimeCategory(TimeOfDay time) {
  //   // Define time ranges for each category
  //   final morningTime = TimeOfDay(hour: 5, minute: 0);
  //   final afternoonTime = TimeOfDay(hour: 11, minute: 0);
  //   final eveningTime = TimeOfDay(hour: 15, minute: 0);
  //   final nightTime = TimeOfDay(hour: 18, minute: 0);

  //   // Compare the selected time with the time ranges
  //   if (_isTimeInRange(time, morningTime, afternoonTime)) {
  //     return "1";
  //   } else if (_isTimeInRange(time, afternoonTime, eveningTime)) {
  //     return '2';
  //   } else if (_isTimeInRange(time, eveningTime, nightTime)) {
  //     return '3';
  //   } else {
  //     return '4';
  //   }
  // }

  // bool _isTimeInRange(
  //   TimeOfDay time,
  //   TimeOfDay startTime,
  //   TimeOfDay endTime,
  // ) {
  //   final currentTimeInMinutes = time.hour * 60 + time.minute;
  //   final startTimeInMinutes = startTime.hour * 60 + startTime.minute;
  //   final endTimeInMinutes = endTime.hour * 60 + endTime.minute;

  //   return currentTimeInMinutes >= startTimeInMinutes &&
  //       currentTimeInMinutes < endTimeInMinutes;
  // }

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
    fetchDataSharedpreference();

    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();

    // _selectedDateController.text =
    //     "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
    // _selectedTimeController.text =
    //     "${_selectedTime.hour}:${_selectedTime.minute}";
  }

  Future<void> fetchDataSharedpreference() async {
    final prefs = await SharedPreferences.getInstance();
    final _selectedKotaAsalId = prefs.getInt('selectedKotaAsalId');
    final _selectedKotaTujuanId = prefs.getInt('selectedKotaTujuanId');
    print(_selectedKotaAsalId);
    print(_selectedKotaTujuanId);
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
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.deepPurple.shade700),
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
                        onTap: () {
                          _showDatePicker(context);
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
                      child: PopupMenuButton<TimesofDepart>(
                        initialValue: selectedMenu,
                        // Callback that sets the selected popup menu item.
                        onSelected: (TimesofDepart item) {
                          setState(() {
                            selectedMenu = item;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            sampleItems.map((item) {
                          return PopupMenuItem<TimesofDepart>(
                            value: item,
                            child: Text(item.timeName),
                          );
                        }).toList(),
                      ),
                      // child: TextFormField(
                      //   controller: _selectedTimeController,
                      //   decoration: InputDecoration(
                      //     labelStyle:
                      //         TextStyle(fontSize: 12, color: Colors.black54),
                      //     hintStyle:
                      //         TextStyle(fontSize: 12, color: Colors.black54),
                      //     border: InputBorder.none,
                      //     contentPadding: EdgeInsets.symmetric(
                      //         horizontal: 21, vertical: 10),
                      //     hintText: 'Pilih Jam Keberangkatan',
                      //     suffixIcon: Padding(
                      //       padding: const EdgeInsets.only(right: 21),
                      //       child: Icon(Icons.schedule),
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     _showTimePicker(context);
                      //   },
                      // ),
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
              onPressed: () async {
                // String timeCategory = _getTimeCategory(_selectedTime);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selectedDate', "2023-05-20");
                prefs.setString('selectedTime',
                    selectedMenu?.id.toString() ?? ""); // Use the selectedMenu
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
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedDateController.text =
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
        _selectedDateValues =
            "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
      });
      print(_selectedDateController.text);
      print(_selectedDate);
      print(_selectedDateValues);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedTimeController.text =
            "${_selectedTime.hour}:${_selectedTime.minute}";
      });
      print(_selectedTimeController.text);
      print(_selectedTime);
    }
  }
}
