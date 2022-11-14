import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_api/network/network_call.dart';
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
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() {
    utils.determinePosition().then((value) {
      setState(() {
        position = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Api")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(decoration: InputDecoration( hintText:"Enter City name"),),
              FutureBuilder(
                future:
                    networkCall.getWeather(position?.latitude ?? 0, position?.longitude  ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data is Map) {
                      return Container(
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
                                    convertKelvinToCelcius(data["main"]["temp"]) +
                                        "°C",
                                    style: TextStyle(
                                        fontSize: 60, color: Colors.white),
                                  ),
                                  Text(
                                    data["weather"][0]["main"],
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
                                          data["name"],
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          convertKelvinToCelcius(
                                                  data["main"]["temp_min"]) +
                                              "°~" +
                                              convertKelvinToCelcius(
                                                  data["main"]["temp_max"]) +
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
                      );
                    } else {
                      return Center(
                        child: Container(
                          child: Text(data.toString()),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
