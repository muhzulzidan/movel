import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({Key? key}) : super(key: key);

  @override
  _PengaturanScreenState createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  bool notifikasiChecked = false;
  bool promosiChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/pengaturan/atas.png', // Replace with your top image asset path
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/pengaturan/bawah.png', // Replace with your bottom image asset path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notifikasi'),
                            CupertinoSwitch(
                              value: notifikasiChecked,
                              onChanged: (value) {
                                setState(() {
                                  notifikasiChecked = value;
                                });
                              },
                              activeColor: Colors.deepPurple,
                              // overrides the default green color of the track
                              // color of the round icon, which moves from right to left
                              thumbColor: Colors.white,
                              // when the switch is off
                              trackColor: Colors.black12,
                              // boolean variable value
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Promosi'),
                            CupertinoSwitch(
                              value: promosiChecked,
                              onChanged: (value) {
                                setState(() {
                                  promosiChecked = value;
                                });
                              },
                              activeColor: Colors.deepPurple,
                              // overrides the default green color of the track
                              // color of the round icon, which moves from right to left
                              thumbColor: Colors.white,
                              // when the switch is off
                              trackColor: Colors.black12,
                              // boolean variable value
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.only(right: 0),
                                  foregroundColor: Colors.black54),
                              onPressed: () {
                                // TODO: Navigate to Play Store page for rating the app.
                              },
                              child: Text('Beri peringkat'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
