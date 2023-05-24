import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'KonfirmasiPesananScreen.dart';

class ChooseSeatScreen extends StatefulWidget {
  const ChooseSeatScreen({Key? key}) : super(key: key);

  @override
  _ChooseSeatScreenState createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  List<String> _seats = ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C'];
  Set<String> _selectedSeats = <String>{}; // Keep track of selected seats

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#60009A"),
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
            color: HexColor("#60009A"),
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
                shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(20),
                    // side: BorderSide(
                    //   color: Colors.purple,
                    //   width: 2.0,
                    // ),
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
                      color:
                          isSelected ? HexColor("#60009A") : Colors.transparent,
                      // color: Colors.yellow, // Set the background color when the seat is selected
                      border: Border.all(
                        color: HexColor("#60009A"), // Set the border color
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
