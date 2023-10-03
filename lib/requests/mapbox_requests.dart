import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../helpers/dio_exceptions.dart';

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String navType = 'driving';
Dio _dio = Dio();

getDrivingRouteUsingMapbox(Position source, Position destination) async {
  String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'].toString();
  String url =
      '$baseUrl/$navType/${source.lng}%2C${source.lat}%3B${destination.lng}%2C${destination.lat}?alternatives=true&annotations=distance%2Cduration&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';

  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return (responseData.data);
  } catch (e) {
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
  }
}

// This function calculates the optimized route using Mapbox Directions API.
// It takes a starting position and a list of waypoints (intermediate positions) to create the route.
Future<dynamic> getOptimizedRouteUsingMapbox(Position start, List<Position> waypoints) async {
  // Convert the waypoints' coordinates into a semicolon-separated string for the API request.
  final coordinates =
      waypoints.map((waypoint) => "${waypoint.lng},${waypoint.lat}").join(';');
  
  // Retrieve the Mapbox Access Token from environment variables.
  String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'].toString();
  
  // Construct the API request URL with the provided parameters.
  String url =
      "https://api.mapbox.com/optimized-trips/v1/mapbox/driving-traffic/${start.lng},${start.lat};$coordinates?source=first&destination=last&roundtrip=false&overview=full&steps=true&access_token=$accessToken";

  try {
    // Set the content type for the HTTP request.
    _dio.options.contentType = Headers.jsonContentType;
    
    // Make an HTTP GET request to the Mapbox Directions API.
    final responseData = await _dio.get(url);
    
    // Return the data obtained from the API (the optimized route).
    return responseData.data;
  } catch (e) {
    // Handle any exceptions that may occur during the API request.
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
  }
}



