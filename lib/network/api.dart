import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://192.168.1.2/lara_passport/public/api/v1';
  // 192.168.1.2 is my IP, change with your IP address
  
  var token;

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map json = jsonDecode(prefs.getString('userData'));
    var user = UserModel.fromJson(json);
    token = jsonDecode(prefs.getString('token'))['token'];
  }

  auth(data, apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiURL) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
