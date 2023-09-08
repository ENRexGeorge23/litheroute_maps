import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:litheroute_maps/MyColors.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/shared_prefs.dart';
import 'package:litheroute_maps/helpers/utils.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

part 'map_routing.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({Key? key}) : super(key: key);

  @override
  State<StoresMapScreen> createState() => _StoresMapScreenState();
}

class _StoresMapScreenState extends State<StoresMapScreen>
    with TickerProviderStateMixin {
  // Mapbox related
  Location location = Location();
  final defaultEdgeInsets =
      MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);
  String accessToken = const String.fromEnvironment("PUBLIC_ACCESS_TOKEN");
  // Position _currentPosition = Position(0.0, 0.0);
  PointAnnotationManager? _pointAnnotationManager;
  Timer? timer;
  bool showAnnotations = true;
  _AnnotationClickListener? annotationClickListener;

  // late MapboxMapController controller;
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    this.mapboxMap = mapboxMap
      ..scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      ),
    );
    LocationData locationData = await location.getLocation();
    mapboxMap.setCamera(CameraOptions(
        center: Point(
                coordinates:
                    Position(locationData.longitude!, locationData.latitude!))
            .toJson(),
        zoom: 15.0));
  }

  // storeAnnotations() async {
  //   List<Point> coordinates = storePositions
  //       .map((storePosition) => Point(coordinates: storePosition))
  //       .toList();

  //   final ByteData bytes = await rootBundle.load('assets/red_marker.png');
  //   final Uint8List imageData = bytes.buffer.asUint8List();

  //   for (int i = 0; i < stores.length; i++) {
  //     Point coordinate = coordinates[i];
  //     // String name = stores[i]['name'];
  //     _pointAnnotationManager?.addAnnotation(
  //       imageData,
  //       coordinate,
  //       // textField: name,
  //     );
  //   }
  // }

  showStoreAnnotations() async {
    if (showAnnotations) {
      final locationData = await MySharedPref.fetchLocationData();
      final myCoordinates = Position(locationData.lng, locationData.lat);

      List<Point> coordinates = storePositions
          .map((storePosition) => Point(coordinates: storePosition))
          .toList();

      final ByteData bytes = await rootBundle.load('assets/red_marker.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      for (int i = 0; i < stores.length; i++) {
        Point coordinate = coordinates[i];
        // String name = stores[i]['name'];
        _pointAnnotationManager?.addAnnotation(
          imageData,
          coordinate,
          // textField: name,
        );
      }
      _pointAnnotationManager
          ?.addOnPointAnnotationClickListener(_AnnotationClickListener(this));

      /** For Camera Positioning */
      final List<Point> allCoordinates = [
        ...storePositions.map((position) => Point(coordinates: position)),
        Point(coordinates: myCoordinates)
      ];
      final camera = await mapboxMap?.cameraForCoordinates(
        allCoordinates.map((point) => point.toJson()).toList(),
        defaultEdgeInsets,
        null,
        null,
      );
      mapboxMap?.flyTo(camera!, null);
    } else {
      _pointAnnotationManager!.deleteAll();
    }
  }

  @override
  void initState() {
    super.initState();
    annotationClickListener = _AnnotationClickListener(this);
  }

  @override
  void dispose() {
    annotationClickListener?._disposeController();
    super.dispose();
  }

  // _onMapCreated(MapboxMapController controller) async {
  //   // this.controller = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Locations'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.0,
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                resourceOptions: ResourceOptions(
                  accessToken: accessToken,
                  baseURL: 'https://api.mapbox.com',
                ),
                styleUri: MapboxStyles.MAPBOX_STREETS,
                onMapCreated: _onMapCreated,
                onStyleLoadedListener: _onStyleLoadedCallback,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: MyColors.primaryColor,
            foregroundColor: MyColors.textColorOnAccent,
            onPressed: () async {
              LocationData locationData = await location.getLocation();
              mapboxMap?.flyTo(
                  CameraOptions(
                    center: Point(
                      coordinates: Position(
                          locationData.longitude!, locationData.latitude!),
                    ).toJson(),
                    zoom: 15.0,
                  ),
                  MapAnimationOptions(duration: 1000, startDelay: 0));
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
              heroTag: "btn2",
              foregroundColor: MyColors.textColorOnAccent,
              onPressed: () {
                setState(() {
                  showAnnotations = !showAnnotations;
                  annotationClickListener?._clearRoute();

                  showStoreAnnotations();
                });
              },
              backgroundColor:
                  showAnnotations ? MyColors.primaryColor : Colors.grey,
              child: const Icon(Icons.store)),
        ],
      ),
    );
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    // storeAnnotations();
    showStoreAnnotations();
  }
}
