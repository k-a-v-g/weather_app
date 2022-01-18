import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    home: HomePage()
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String latitude='';
  late String longitude='';

  var temp;
  var description;

  Future getData() async {
    String appId = 'aa67b32def20354807341ee27ff707e8';

    var url = Uri.parse('api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$appId');

    http.Response response = await http.get(url);
    var results = json.decode(response.body);

    setState(() {
      this.temp = results["main"]["temp"];
      this.description = results['weather'][0]['description'];
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


    setState(() {
      latitude = '${geoposition.latitude}';
      longitude = '${geoposition.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Weather'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Temperature: '),
              Text(
                temp != null ? temp.toString() + "\u00B0" : "Loading...",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Details: '),
              Text(
                description != null ? description.toString() : "Loading...",
              ),
            ],
          )
        ],
      )
    );
  }
}


