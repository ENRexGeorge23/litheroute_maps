import 'dart:convert';
import 'package:litheroute_maps/main.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  static Future<Position> fetchLocationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lng = prefs.getDouble('longitude');
    double? lat = prefs.getDouble('latitude');
    if (lat != null && lng != null) {
      return Position(lng, lat);
    } else {
      return Position(0.0, 0.0);
    }
  }

  Map getDecodedResponseFromSharedPrefs(int index) {
    String key = 'stores--$index';
    Map response = json.decode(sharedPreferences.getString(key)!);
    return response;
  }

  num getDistanceFromSharedPrefs(int index) {
    num distance = getDecodedResponseFromSharedPrefs(index)['distance'];
    return distance;
  }

  num getDurationFromSharedPrefs(int index) {
    num duration = getDecodedResponseFromSharedPrefs(index)['duration'];
    return duration;
  }

  Map getGeometryFromSharedPrefs(int index) {
    Map geometry = getDecodedResponseFromSharedPrefs(index)['geometry'];
    return geometry;
  }
}
