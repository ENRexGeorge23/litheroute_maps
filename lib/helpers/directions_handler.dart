// ignore_for_file: avoid_print

import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/main.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../requests/mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(Position sourcePosition, int index) async {
  double destinationLatitude =
      double.parse(stores[index]['coordinates']['latitude']);
  double destinationLongitude =
      double.parse(stores[index]['coordinates']['longitude']);

  Position destinationPosition =
      Position(destinationLongitude, destinationLatitude);

  final response =
      await getDrivingRouteUsingMapbox(sourcePosition, destinationPosition);

  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  Map geometry = response['routes'][0]['geometry'];

  print('-------------------${stores[index]['name']}-------------------');
  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };

  return modifiedResponse;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('stores--$index', response);
}
