import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:litheroute_maps/MyColors.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/directions_handler.dart';
import 'package:litheroute_maps/helpers/shared_prefs.dart';
import 'package:litheroute_maps/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DistanceAndDurationTrackerWidget extends StatefulWidget {
  const DistanceAndDurationTrackerWidget({
    super.key,
  });

  @override
  State<DistanceAndDurationTrackerWidget> createState() =>
      _DistanceAndDurationTrackerWidgetState();
}

class _DistanceAndDurationTrackerWidgetState
    extends State<DistanceAndDurationTrackerWidget> {
  MySharedPref sharedPrefs = MySharedPref();
  bool isLoading = true;
  Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  getDurationAndDistance(context) async {
    LocationData locationData = await location.getLocation();
    if (!mounted) return;
    sharedPreferences.setDouble('longitude', locationData.longitude!);
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    final start = Position(locationData.longitude!, locationData.latitude!);

    getOptimizedRouteAPIResponse(start, storePositions).then((jsonResponse) {
      saveOptimizedAPIResponse(json.encode(jsonResponse));
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      isLoading = false;
      sharedPrefs.getOptimizedDurationFromSharedPrefs;
      sharedPrefs.getOptimizedDistanceFromSharedPrefs;
    });
  }

  getDurationAndDistanceFromSharedPrefs(context) async {
    LocationData locationData = await location.getLocation();
    if (!mounted) return;
    setState(() {
      isLoading = false;
      sharedPrefs.getOptimizedDurationFromSharedPrefs;
      sharedPrefs.getOptimizedDistanceFromSharedPrefs;
    });
  }

  @override
  void initState() {
    super.initState();
    locationSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
      getDurationAndDistance(locationData);
    });
    getDurationAndDistance(context);
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durationInMinutes =
        sharedPrefs.getOptimizedDurationFromSharedPrefs() / 60;
    final durationInHours = durationInMinutes / 60;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   width: 230,
        //   height: 50,
        //   decoration: const BoxDecoration(
        //     color: MyColors.primaryContainerColor,
        //     borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(10),
        //       topLeft: Radius.circular(10),
        //     ),
        //   ),
        //   child: const Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(
        //         Icons.location_on,
        //         color: MyColors.onPrimaryContainerColor,
        //       ),
        //       Text(
        //         "Store Locations",
        //         style: TextStyle(
        //           color: MyColors.onPrimaryContainerColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          width: 360,
          height: 53,
          child: isLoading
              ? Center(
                  child: JumpingDots(
                  color: MyColors.onPrimaryContainerColor,
                  radius: 5,
                  verticalOffset: -3,
                  animationDuration: const Duration(milliseconds: 200),
                ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      height: 50,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${stores.length}',
                            style: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                          const Text(
                            'Deliveries',
                            style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(
                        color: MyColors.primaryColor,
                        fontSize: 23,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      height: 50,
                      width: 112,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            durationInMinutes < 60
                                ? durationInMinutes.toStringAsFixed(2)
                                : durationInHours.toStringAsFixed(
                                    durationInHours.truncateToDouble() ==
                                            durationInHours
                                        ? 0
                                        : 1),
                            style: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            durationInMinutes >= 60 ? ' Hours' : ' Minutes',
                            style: const TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(
                        color: MyColors.primaryColor,
                        fontSize: 23,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      height: 50,
                      width: 112,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            (sharedPrefs.getOptimizedDistanceFromSharedPrefs() /
                                    1000)
                                .toStringAsFixed(2),
                            style: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                          const Text(
                            'Kilometers',
                            style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        )
      ],
    );
  }
}
