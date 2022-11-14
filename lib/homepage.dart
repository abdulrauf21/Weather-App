import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_api/network/network_call.dart';
import 'package:weather_api/provider/weather_provider.dart';
import 'package:weather_api/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  convertKelvinToCelcius(double temp) {
    final result = temp - 273;
    int? y = int.tryParse(result.toString().split('.')[0]);
    return y.toString();
  }

  NetworkCall networkCall = NetworkCall();
  Utils utils = Utils();
  Position? position;
  // Map<String, dynamic> data = {};
  @override
  void initState() {
    Provider.of<WeatherProvider>(context, listen: false).getCurrentWeather();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Api")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Enter City name"),
              ),
              Provider.of<WeatherProvider>(context).isLoading || Provider.of<WeatherProvider>(context).currentWeather.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Image.asset("images/containerbg.png"),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  convertKelvinToCelcius(Provider.of<WeatherProvider>(context).currentWeather["main"]["temp"]) +
                                      "°C",
                                  style: TextStyle(
                                      fontSize: 60, color: Colors.white),
                                ),
                                Text(
                                  Provider.of<WeatherProvider>(context, listen: false).currentWeather["weather"][0]["main"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        Provider.of<WeatherProvider>(context, listen: false).currentWeather["name"],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        convertKelvinToCelcius(
                                                Provider.of<WeatherProvider>(context, listen: false).currentWeather["main"]["temp_min"]) +
                                            "°~" +
                                            convertKelvinToCelcius(
                                                Provider.of<WeatherProvider>(context, listen: false).currentWeather["main"]["temp_max"]) +
                                            "°",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
