// ignore_for_file: unused_local_variable

part of 'stores_map.dart';

class _AnnotationClickListener extends OnPointAnnotationClickListener {
  _StoresMapScreenState mapState;
  Animation<double>? _animation;
  AnimationController? _controller;
  _AnnotationClickListener(this.mapState);
  MySharedPref sharedPrefs = MySharedPref();

  @override
  void onPointAnnotationClick(PointAnnotation annotation) async {
    print("onAnnotationClick, id: ${annotation.id}");

    List<Map> optimizedWaypoints =
        sharedPrefs.getOptimizedWaypointsFromSharedPrefs();

    for (int i = 1; i < optimizedWaypoints.length; i++) {
      final waypoint = optimizedWaypoints[i];

      final int waypointIndex = waypoint['waypoint_index'];

      String waypointIndexString = waypointIndex.toString();

      final ByteData bytes = await rootBundle
          .load('assets/image/optimize_marker_${waypointIndex - 1}.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      PointAnnotation updatedAnnotation = PointAnnotation(
        id: waypointIndexString,
        iconSize: 1.5,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
        image: imageData,
      );

      var newPoint = Point(
          coordinates: Position(
        double.parse(waypoint['location'][0].toString()),
        double.parse(waypoint['location'][1].toString()),
      ));
      mapState._pointAnnotationManager?.setIconAllowOverlap(true);

      updatedAnnotation.geometry = newPoint.toJson();
      mapState._pointAnnotationManager?.update(updatedAnnotation);
    }

    if (await mapState.mapboxMap!.style.styleSourceExists("source")) {
      await mapState.mapboxMap?.style.removeStyleLayer("layer");
      await mapState.mapboxMap?.style.removeStyleSource("source");
    }

    LocationData locationData = await mapState.location.getLocation();

    final start = Position(locationData.longitude!, locationData.latitude!);
    final waypoints = storePositions;

    try {
      final coordinates = await fetchOptimizedRoute(
        start,
        waypoints,
        dotenv.env['MAPBOX_ACCESS_TOKEN'].toString(),
      );
      // _drawRouteLowLevel([coordinates]);
    } catch (error) {
      print('Error fetching or drawing route: $error');
    }
  }

  void _drawRouteLowLevel(List<List<Position>> routes) async {
    for (int i = 0; i < routes.length; i++) {
      final polyline = routes[i];
      final line = LineString(coordinates: polyline);

      // Create a unique source ID and layer ID for each route.
      final sourceId = 'source_$i';
      final layerId = 'layer_$i';

      final exists =
          await mapState.mapboxMap?.style.styleSourceExists(sourceId);
      if (exists!) {
        // If source exists, just update it
        final source = await mapState.mapboxMap?.style.getSource(sourceId);
        (source as GeoJsonSource).updateGeoJSON(json.encode(line));
      } else {
        await mapState.mapboxMap?.style.addSource(GeoJsonSource(
          id: sourceId,
          data: json.encode(line),
          lineMetrics: true,
        ));

        await mapState.mapboxMap?.style.addLayer(LineLayer(
          id: layerId,
          sourceId: sourceId,
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
          lineBlur: 1.0,
          lineColor: MyColors.primaryColor.value,
          lineWidth: 5.0,
        ));
      }

      // Query the line layer
      final lineLayer =
          await mapState.mapboxMap?.style.getLayer(layerId) as LineLayer;

      // Animate the layer to reveal it from start to end
      _controller?.stop();
      _controller = AnimationController(
          duration: const Duration(seconds: 5), vsync: mapState);
      _animation = Tween<double>(begin: 0, end: 1.0).animate(_controller!)
        ..addListener(() async {
          lineLayer.lineTrimOffset = [_animation?.value, 1.0];
          mapState.mapboxMap?.style.updateLayer(lineLayer);
        });
      _controller?.forward();
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _animation = null;
    _controller = null;
  }

  void _clearRoute() async {
    for (int i = 0; i < 1; i++) {
      final sourceId = 'source_$i';
      final layerId = 'layer_$i';

      if (await mapState.mapboxMap!.style.styleSourceExists(sourceId)) {
        await mapState.mapboxMap?.style.removeStyleLayer(layerId);
        await mapState.mapboxMap?.style.removeStyleSource(sourceId);
      }
    }
  }
}
