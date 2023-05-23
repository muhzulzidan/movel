import 'package:flutter/material.dart';

class OrderProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Progres Pesanan Anda"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 16),
                buildProgressTile(
                    title: "Pesanan Diterima",
                    subtitle: "21 Oktober 2023, 14:23"),
                buildProgressTile(
                    title: "Sopir Menuju ke Lokasi Anda",
                    subtitle: "21 Oktober 2023, 14:30"),
                buildProgressTile(
                    title: "Sopir Telah Tiba di Lokasi Anda",
                    subtitle: "21 Oktober 2023, 14:42"),
                buildProgressTile(
                    title: "Anda Telah Tiba di Tujuan",
                    subtitle: "21 Oktober 2023, 15:10"),
                SizedBox(height: 16),
                buildDriverProfile(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement chat functionality
                  },
                  child: Text("Chat dengan Sopir"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement cancel order functionality
                  },
                  child: Text("Batalkan Pesanan"),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgressTile({required String title, required String subtitle}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.check_circle_outline),
    );
  }

  Widget buildDriverProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/driver.png"),
        ),
        SizedBox(height: 16),
        Text(
          "John Doe",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
