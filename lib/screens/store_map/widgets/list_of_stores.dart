import 'package:flutter/material.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/shared_prefs.dart';
import 'package:litheroute_maps/screens/store_map/widgets/status_buttons.dart';
import 'package:litheroute_maps/screens/store_table/store_lists.dart';

class ListOfStores extends StatelessWidget {
  const ListOfStores({
    super.key,
    required MySharedPref sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  final MySharedPref _sharedPrefs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: stores.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            final storeData = stores[index];
            Navigator.pushNamed(context, '/store-details',
                arguments: storeData);
          },
          child: Card(
            key: ValueKey(stores[index]['id']),
            elevation: 1,
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
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stores[index]['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(stores[index]['items']),
                        Expanded(
                          child: Row(
                            children: [
                              CardButtons(
                                context: context,
                                iconData: Icons.location_on,
                                label: 'Location',
                                storeData: stores[index],
                              ),
                              const Spacer(),
                              // Text(
                              //   '${(_sharedPrefs.getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)} km',
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
