// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:litheroute_maps/helpers/utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class StoreLocationMapScreen extends StatefulWidget {
  static const String routeName = "/store-location-map";

  const StoreLocationMapScreen({super.key});

  @override
  State<StoreLocationMapScreen> createState() => _StoreLocationMapScreenState();
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class _StoreLocationMapScreenState extends State<StoreLocationMapScreen> {
  String accessToken = const String.fromEnvironment("PUBLIC_ACCESS_TOKEN");
  late MapboxMap mapboxMap;
  late PointAnnotationManager _pointAnnotationManager;

  _onMapCreated(MapboxMap mapboxMap) async {
    final storeData =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    final latitude =
        double.parse(storeData['coordinates']['latitude'] as String);
    final longitude =
        double.parse(storeData['coordinates']['longitude'] as String);

    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      _pointAnnotationManager = value;
      final ByteData bytes = await rootBundle.load('assets/red_marker.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      /// Extracts the store coordinates from the arguments passed through the context
      final storeData =
          ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
      final latitude =
          double.parse(storeData['coordinates']['latitude'] as String);
      final longitude =
          double.parse(storeData['coordinates']['longitude'] as String);

      /// Returns a [Point] object with the store coordinates.
      final coordinates = Point(coordinates: Position(longitude, latitude));

      String name = storeData['name'];
      _pointAnnotationManager.addAnnotation(
        imageData,
        coordinates,
        textField: name,
      );
      _pointAnnotationManager
          .addOnPointAnnotationClickListener(AnnotationClickListener());
    });

    mapboxMap.setCamera(CameraOptions(
        center: Point(coordinates: Position(longitude, latitude)).toJson(),
        zoom: 15.0));

    mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeData =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(storeData['name']),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.0,
              child: MapWidget(
                resourceOptions: ResourceOptions(
                  accessToken: accessToken,
                  baseURL: 'https://api.mapbox.com',
                ),
                onMapCreated: _onMapCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
