import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'AvailableDriversScreen.dart';

class ChooseDepartureDateScreen extends StatefulWidget {
  @override
  _ChooseDepartureDateScreenState createState() =>
      _ChooseDepartureDateScreenState();
}

class _ChooseDepartureDateScreenState extends State<ChooseDepartureDateScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  TextEditingController _selectedDateController = TextEditingController();
  TextEditingController _selectedTimeController = TextEditingController();

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
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
