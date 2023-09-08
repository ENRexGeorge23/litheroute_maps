import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/directions_handler.dart';
import 'package:litheroute_maps/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../screens/home/home_management.dart';

class Splash extends StatefulWidget {
  static const String routeName = "/splash";
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave(context);
  }

  void initializeLocationAndSave(context) async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    // Get capture the current user location
    LocationData locationData = await location.getLocation();
    // LatLng currentLatLng =
    // LatLng(_locationData.latitude!, _locationData.longitude!);

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('longitude', locationData.longitude!);
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    debugPrint(
        '-----------> CURRENT LOCATION LNG = ${locationData.longitude}, LAT =${locationData.latitude}');

    // Get and store the directions API response in sharedPreferences
    for (int i = 0; i < stores.length; i++) {
      Map modifiedResponse = await getDirectionsAPIResponse(
          Position(locationData.longitude!, locationData.latitude!), i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeManagement()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(child: Image.asset('assets/icon/logo.png')),
    );
  }
}
