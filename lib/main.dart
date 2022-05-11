import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking/models/DataModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title='Tracker';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double lat=0.0;
  double lan=0.0;
  List<DataModel> locationData=[];
  var positionNo=0;

  late Timer timer;


  @override
  void initState() {
    startLocation();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // reverse: true,
          itemCount: locationData.length,
          itemBuilder: (context, index) => ListTile(
            title: Text("Position No-${index+1}"),
            subtitle: Text("Latitude:${locationData[index].latitude} Longitude:${locationData[index].longitude}"),
          ),

      )
    );
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void startLocation() async{
    timer=Timer.periodic(const Duration(seconds: 30), (timer) {
      submitTracking();
    });
  }

  void submitTracking(){
    Dio _dio=Dio();
    _determinePosition().then((value)async{

      // print(value.latitude);
      // print(value.longitude);
      // var a=0;
      // a++;
      // locationData.add(LocationData(latitude: 1.1, longitude: 1.1, positionCount: 1));
      // setState(() {
      //
      //   var a=0;
      //
      //   locationData.add(LocationData(latitude:value.longitude, longitude: value.longitude, positionCount: a));
      // });

      var response=await _dio.get("https://mp.mobilestorebd.com/api_submit_location.php?userId=105&latitude=${value.latitude}&longitude=${value.longitude}");

      if(response.statusCode==200){
        print('submit: ${response.statusCode}');
        var d=response.data['EBOOK_APP'][0]['msg'];
        print('msg: $d');
        getTracking();
      }else{

      }



    });
  }

  void getTracking()async{
    Dio _dio=Dio();
    var response=await _dio.get("https://mp.mobilestorebd.com/api.php?location_by_userId=105");

    if(response.statusCode==200){
      var list=response.data['tracingById'] as List;
      List<DataModel> dataList=list.map((e) => DataModel.fromJson(e)).toList();
      locationData.clear();
      locationData.addAll(dataList);
      print(locationData.length);


    }else{

    }
  }


  ///Stop Get tracking api https://mp.mobilestorebd.com/api.php?location_by_userId=105

  void stopTracking(){
    timer.cancel();
  }


}

