import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChooseLocationScreen extends StatefulWidget {
  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  String _selectedLocation = '';
  bool _isLoading = false;
  bool _showOptions = false;

  var login;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Pilih Lokasi Asal Anda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("#60009A"),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Container(
            decoration: BoxDecoration(color: HexColor("#60009A")),
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(children: [
              Positioned(
                left: 90,
                top: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'MO',
                      style: TextStyle(
                          color: HexColor("#FFD12E"),
                          height: .8,
                          fontSize: 100,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Vel',
                      style: TextStyle(
                          color: HexColor("#FFD12E"),
                          height: .8,
                          fontSize: 110,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Image.asset(
                  "assets/avanza-gray-(1)_optimized.png",
                  width: 170,
                  height: 300,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    height: 49,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showOptions = !_showOptions;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _showOptions ? Colors.white : Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.black),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Cari',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // TODO: Implement location search
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _showOptions ? 80 : 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showOptions ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Option $index'),
                      onTap: () {
                        setState(() {
                          _showOptions = false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Row(
                children: [
                  // Image cut in half
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ClipRect(
                      child: Image.asset(
                        "assets/buntutMobil.png",
                      ),
                    ),
                  ),

                  // Text and Buttons
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              alignment: Alignment.topRight,
                              child: RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                  text: 'Atau pilih ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: 'kota asalmu',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' di bawah ini!'),
                                  ],
                                ),
                              )
                              // Text(
                              //   textAlign: TextAlign.end,
                              //   "Atau pilih kota asalmu di bawah ini",
                              //   style: TextStyle(),
                              // )

                              ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 45,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: Colors.grey[100],
                                ),
                                child: ListTile(
                                  // leading: Icon(Icons.place),

                                  title: Text(
                                    'Makassar',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        height: .1),
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedLocation = 'Makassar';
                                    });
                                  },
                                  selected: _selectedLocation == 'Makassar',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: Colors.grey[100],
                                ),
                                child: ListTile(
                                  // leading: Icon(Icons.place),

                                  title: Text(
                                    'Sengkang',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        height: .1),
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedLocation = 'Sengkang';
                                    });
                                  },
                                  selected: _selectedLocation == 'Sengkang',
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: Colors.grey[100],
                                ),
                                child: ListTile(
                                  // leading: Icon(Icons.place),

                                  title: Text(
                                    'Sengkang',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        height: .1),
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedLocation = 'Sengkang';
                                    });
                                  },
                                  selected: _selectedLocation == 'Sengkang',
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              // ListTile(
                              //   leading: Icon(Icons.place),
                              //   title: Text('Work'),
                              //   onTap: () {
                              //     setState(() {
                              //       _selectedLocation = 'Work';
                              //     });
                              //   },
                              //   selected: _selectedLocation == 'Work',
                              // ),
                            ],
                          ),
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              color: Colors.amber,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              onPressed: _isLoading ? null : login,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Oke',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(height: 20.0),
          // ElevatedButton(
          //   child: Text('Next'),
          //   onPressed: _selectedLocation.isEmpty
          //       ? null
          //       : () {
          //           // TODO: Navigate to next screen with selected location
          //         },
          // ),
        ],
      ),
    );
  }
}
