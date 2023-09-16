// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/main.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../requests/mapbox_requests.dart';
import 'package:turf/polyline.dart';

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

Future<Map> getOptimizedRouteAPIResponse(
  Position start,
  List<Position> waypoints,
) async {
  final response = await getOptimizedRouteUsingMapbox(start, waypoints);

  num duration = response['trips'][0]['duration'];
  num distance = response['trips'][0]['distance'];
  String geometry = response['trips'][0]['geometry'];
  List<dynamic> optimizedWaypoints = response['waypoints'];

  // Extract the waypoint indices
  List<int> waypointIndices = [];

  for (int i = 0; i < optimizedWaypoints.length; i++) {
    Map<String, dynamic> waypoint =
        optimizedWaypoints[i] as Map<String, dynamic>;
    int waypointIndex = waypoint['waypoint_index'];
    waypointIndices.add(waypointIndex);
  }

  debugPrint('OVERALL DURATION OF ROUTES = $duration');
  debugPrint('OVERALL DISTANCE OF ROUTES = $distance');
  debugPrint('OVERALL GEOMETRY OF ROUTES = $geometry');
  debugPrint('WAYPOINT INDICES = $waypointIndices');

  Map jsonResponse = {
    "duration": duration,
    "distance": distance,
    'geometry': geometry,
    'waypoints': optimizedWaypoints,
    'waypoint_index': waypointIndices,
  };

  return jsonResponse;
}

// Future<Map> getOptimizedWaypointAPIResponse(
//   Position start,
//   List<Position> waypoints,
// ) async {
//   final response = await getOptimizedRouteUsingMapbox(start, waypoints);

//   List<dynamic> optimizedWaypoints = response['waypoints'];

//   // Extract the waypoint indices
//   List<int> waypointIndices = [];

//   for (int i = 0; i < optimizedWaypoints.length; i++) {
//     Map<String, dynamic> waypoint =
//         optimizedWaypoints[i] as Map<String, dynamic>;
//     int waypointIndex = waypoint['waypoint_index'];
//     waypointIndices.add(waypointIndex);
//   }

//   debugPrint('WAYPOINT INDICES = $waypointIndices');

//   Map jsonResponse = {

//     'waypoints': optimizedWaypoints,
//     'waypoint_index': waypointIndices,
//   };

//   return jsonResponse;
// }

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('stores--$index', response);
}

void saveOptimizedAPIResponse(String response) {
  sharedPreferences.setString('optimizedstores--', response);
}
