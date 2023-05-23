import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'trx/jadwal.dart';

class DriverHomeContent extends StatefulWidget {
  const DriverHomeContent({super.key});

  @override
  State<DriverHomeContent> createState() => _DriverHomeContentState();
}

class _DriverHomeContentState extends State<DriverHomeContent> {
  int saldo = 900000;
  List<String> _seats = ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C'];
  Set<String> _selectedSeats = <String>{}; // Keep track of selected seats
  bool _isButtonPressed = false;
  bool _isBerangkat = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("driverContent"),
      // ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/driverHero.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // height: double.infinity,
                  ),
                  Positioned(
                    // height: double.infinity,
                    top: 50,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isButtonPressed = !_isButtonPressed;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: _isButtonPressed
                              ? Colors.amberAccent
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: _isButtonPressed ? 20 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.power_settings_new,
                                color: _isButtonPressed
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _isButtonPressed ? 'Aktif' : "Tidak Aktif",
                                style: TextStyle(
                                  color: _isButtonPressed
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    top: 120,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JadwalScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.deepPurple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Atur Rute dan Jadwal',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    bottom: 15,
                    left: 70,
                    right: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Pesan Sekarang',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: double.infinity,
                    bottom: 15,
                    left: 25,
                    right: 25,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Saldo:",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    "Rp $saldo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement top up functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  backgroundColor: Colors.deepPurple.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.control_point,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Top Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Cek Jumlah dan kursi penumpangmu hari ini ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    // constraints: BoxConstraints.expand(),
                    width: 280,
                    height: 200,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(29),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/otoWhite.png'), // Replace with your desired background image
                        // fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the border radius as needed
                    ),
                    child: RotatedBox(
                      quarterTurns: 1,
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
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
                                      ? Colors.amberAccent
                                      : Colors.transparent,
                                  // color: Colors.yellow, // Set the background color when the seat is selected
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.amberAccent
                                        : Colors.white, // Set the border color
                                    width: 2,
                                  ),
                                ),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Center(
                                    child: Text(
                                      _seats[index],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.deepPurple.shade700
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pesanan Dibatalkan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {
                            // to do
                          },
                          child: Text(
                            "Lihat",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isBerangkat ? Colors.amberAccent : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Add your logic here
                        setState(() {
                          _isBerangkat = !_isBerangkat;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: _isBerangkat ? Colors.black : Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Berangkat",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _isBerangkat ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
