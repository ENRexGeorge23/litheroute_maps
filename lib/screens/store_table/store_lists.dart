import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/directions_handler.dart';
import 'package:litheroute_maps/helpers/shared_prefs.dart';
import 'package:litheroute_maps/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class StoreListsScreen extends StatefulWidget {
  static const String routeName = "/store-lists";

  const StoreListsScreen({Key? key}) : super(key: key);

  @override
  State<StoreListsScreen> createState() => _StoreListsScreenState();
}

class _StoreListsScreenState extends State<StoreListsScreen> {
  final MySharedPref _sharedPrefs = MySharedPref();

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    return setState(() {
      _sharedPrefs.getDistanceFromSharedPrefs;
    });
  }

  initializeLocationAndSave(context) async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    sharedPreferences.setDouble('longitude', locationData.longitude!);
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    // Get and store the directions API response in sharedPreferences
    for (int i = 0; i < stores.length; i++) {
      Map modifiedResponse = await getDirectionsAPIResponse(
          Position(locationData.longitude!, locationData.latitude!), i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }
  }

  @override
  void initState() {
    super.initState();
    initializeLocationAndSave(context);
    setState(() {
      _sharedPrefs.getDistanceFromSharedPrefs;
    });
  }

  Widget cardButtons(
      IconData iconData, String label, Map<dynamic, dynamic> storeData) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/store-location-map',
              arguments: storeData);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
        ),
        child: Row(
          children: [
            Icon(iconData, size: 20),
            const SizedBox(width: 5),
            Text(label)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CachedNetworkImage(
                        //   height: 190,
                        //   width: 140,
                        //   fit: BoxFit.cover,
                        //   imageUrl: stores[index]['image'],
                        // ),
                        Expanded(
                          child: Container(
                            height: 190,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stores[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(stores[index]['items']),
                                // const Text('Waiting time: 2hrs'),
                                const Spacer(),
                                // Text(
                                //   'Closes at 10PM',
                                //   style: TextStyle(color: Colors.redAccent[100]),
                                // ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      cardButtons(Icons.location_on, 'Map',
                                          stores[index]),
                                      const Spacer(),
                                      Text(
                                        '${(_sharedPrefs.getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)} km',
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
