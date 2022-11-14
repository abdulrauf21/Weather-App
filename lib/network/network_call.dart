import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkCall {
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=c9f4e2c910695939b5057fbe6b9fe322");

    final http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodeResult = jsonDecode(response.body);
      return decodeResult;
    } else {
      throw "Error 404";
    }
  }

  getWeatherByCity(String cityName) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=823cc1f8c55ee2ea9ebebb5c2296c086");

    final http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodeResult = jsonDecode(response.body);
      return decodeResult;
    } else {
      return "Error";
    }
  }
}
