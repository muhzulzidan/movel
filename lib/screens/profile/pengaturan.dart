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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                  value: notifikasiChecked,
                  onChanged: (value) {
                    setState(() {
                      notifikasiChecked = value ?? false;
                    });
                  },
                ),
                Text('Terima notifikasi'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: promosiChecked,
                  onChanged: (value) {
                    setState(() {
                      promosiChecked = value ?? false;
                    });
                  },
                ),
                Text('Terima promosi'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Play Store page for rating the app.
              },
              child: Text('Beri peringkat'),
            ),
          ],
        ),
      ),
    );
  }
}
