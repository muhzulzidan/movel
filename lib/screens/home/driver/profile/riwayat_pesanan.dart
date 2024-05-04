import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPesananScreen extends StatefulWidget {
  const RiwayatPesananScreen({Key? key}) : super(key: key);

  @override
  _RiwayatPesananScreenState createState() => _RiwayatPesananScreenState();
}

class _RiwayatPesananScreenState extends State<RiwayatPesananScreen> {
  late Future<List<dynamic>> futureOrders;

  Future<List<dynamic>> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found in SharedPreferences');
    }

    final response = await http.get(
      Uri.parse('https://api.movel.id/api/user/orders/driver/completed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.deepPurple.shade600),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 1, color: Colors.white24),
                          ),
                        ),
                        child: Icon(Icons.shopping_bag, color: Colors.white),
                      ),
                      title: Text(
                        'Order #${snapshot.data![index]['id']} ${snapshot.data![index]['passenger_name']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Status: ${snapshot.data![index]['status_order']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        'Rp ${snapshot.data![index]['price_order']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // TODO: navigate to order detail screen
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              ),
            );
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
