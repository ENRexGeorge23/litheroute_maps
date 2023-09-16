// ignore_for_file: constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:turf/polyline.dart';

Point createRandomPoint() {
  return Point(coordinates: createRandomPosition());
}

Position createRandomPosition() {
  var random = Random();
  return Position(random.nextDouble() * -360.0 + 180.0,
      random.nextDouble() * -180.0 + 90.0);
}

List<Position> createRandomPositionList() {
  var random = Random();
  final positions = <Position>[];
  for (int i = 0; i < random.nextInt(6) + 4; i++) {
    positions.add(createRandomPosition());
  }

  return positions;
}

List<List<Position>> createRandomPositionsList() {
  var random = Random();
  final first = createRandomPosition();
  final positions = <Position>[];
  positions.add(first);
  for (int i = 0; i < random.nextInt(6) + 4; i++) {
    positions.add(createRandomPosition());
  }
  positions.add(first);

  return [positions];
}

int createRandomColor() {
  var random = Random();
  return Color.fromARGB(
          255, random.nextInt(255), random.nextInt(255), random.nextInt(255))
      .value;
}

final annotationStyles = [
  MapboxStyles.MAPBOX_STREETS,
  MapboxStyles.OUTDOORS,
  MapboxStyles.LIGHT,
  MapboxStyles.DARK,
  MapboxStyles.SATELLITE_STREETS
];

const MAPBOX_DIRECTIONS_ENDPOINT =
    "https://api.mapbox.com/directions/v5/mapbox/driving/";

const MAPBOX_OPTIMIZATION_ENDPOINT =
    "https://api.mapbox.com/optimized-trips/v1/mapbox/driving-traffic/";

Position createRandomPositionAround(Position myPosition) {
  var random = Random();
  return Position(myPosition.lng + random.nextDouble() / 10,
      myPosition.lat + random.nextDouble() / 10);
}

extension AnnotationCreation on PointAnnotationManager {
  addAnnotation(Uint8List imageData, Point position, {String textField = ""}) {
    return create(PointAnnotationOptions(
        geometry: position.toJson(),
        textField: textField,
        textOffset: [0.0, -3.0],
        textColor: Colors.red.value,
        iconSize: 1.3,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
        image: imageData));
  }
}

extension PuckPosition on StyleManager {
  Future<Position> getPuckPosition() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await getLayer("puck");
    }
    final location = (layer as LocationIndicatorLayer).location;
    return Future.value(Position(location![1]!, location[0]!));
  }
}

extension PolylineCreation on PolylineAnnotationManager {
  addAnnotation(List<Position> coordinates) {
    return PolylineAnnotationOptions(
        geometry: LineString(coordinates: coordinates).toJson(),
        lineColor: Colors.red.value,
        lineWidth: 2);
  }
}

Future<List<Position>> fetchOptimizedRoute(
    Position start, List<Position> waypoints, String accessToken) async {
  final coordinates =
      waypoints.map((waypoint) => "${waypoint.lng},${waypoint.lat}").join(';');

  final uri = Uri.parse(
      "$MAPBOX_OPTIMIZATION_ENDPOINT${start.lng},${start.lat};$coordinates?source=first&destination=last&roundtrip=false&overview=full&steps=true&access_token=$accessToken");

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final geometry = jsonResponse['trips'][0]['geometry'];

      return Polyline.decode(geometry)
          .map((point) => Position(
                point.lng,
                point.lat,
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch route');
    }
  } catch (error) {
    throw Exception('Failed to fetch route: $error');
  }
}

Future<http.Response> fetchDirectionRoute(
    Position start, Position end, String accessToken) async {
  final uri = Uri.parse(
      "$MAPBOX_DIRECTIONS_ENDPOINT${start.lng},${start.lat};${end.lng},${end.lat}?overview=full&access_token=$accessToken");
  return http.get(uri);
}

Future<List<Position>> fetchRouteCoordinates(
    Position start, Position end, String accessToken) async {
  final response = await fetchDirectionRoute(start, end, accessToken);
  Map<String, dynamic> route = jsonDecode(response.body);
  return Polyline.decode(route['routes'][0]['geometry']);
}
