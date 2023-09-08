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
