import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PusatBantuanScreen extends StatelessWidget {
  final String userName;

  const PusatBantuanScreen({Key? key, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pusat Bantuan'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hello $userName!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Kami siap membantu. Jika Anda memerlukan bantuan, silakan hubungi admin kami melalui telepon atau email yang tertera di bawah ini:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  // onPressed: () => launch('tel:+6281234567890'),
                  // onPressed: null,
                  onPressed: () => launchUrl(
                      'https://wa.me/+6281354789375?text=Hello' as Uri),

                  icon: Icon(Icons.call),
                  label: Text('Hubungi Admin'),
                ),
                SizedBox(height: 16),
                Text(
                  'Atau',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  // onPressed: () => launch('mailto:admin@example.com'),
                  // onPressed: null,
                  onPressed: () => launchUrl(
                      'https://mail.google.com/mail/?view=cm&fs=1&to=zulzdn@gmail.com.com&su=movel&body=BODY&bcc=someone.else@example.com'
                          as Uri),
                  icon: Icon(Icons.email),
                  label: Text('Kirim Email'),
                ),
                // Positioned(
                //   bottom: -20,
                //   left: 0,
                //   right: 0,
                //   child: Image.asset(
                //     'assets/pusatBantuanBg.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
