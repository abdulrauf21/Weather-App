import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_api/network/network_call.dart';
import 'package:weather_api/utils/utils.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  NetworkCall networkCall = NetworkCall();
  Utils utils = Utils();
  Map<String, dynamic> currentWeather = {};

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      isLoading = true;
      notifyListeners();
      Position position = await utils.determinePosition();
      log(position.toString());
      currentWeather = await networkCall.getWeather(position.latitude, position.longitude);
      isLoading = false;
      notifyListeners();
      return currentWeather;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
      );
      throw e;
    }
  }

  Future<void> getWeatherOfCity(String city) async{
    //api call to get weather according to city
    // after getting data from api set that data to [currentWeather] variable
  }
}
