import 'package:flutter/material.dart';

class RiwayatPesananScreen extends StatelessWidget {
  const RiwayatPesananScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
      ),
      body: ListView.builder(
        itemCount: 10, // replace with actual number of orders
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Order #${index + 1}'),
            subtitle: Text('Status: Delivered'),
            trailing: Text('Rp 50,000'),
            onTap: () {
              // TODO: navigate to order detail screen
            },
          );
        },
      ),
    );
  }
}
