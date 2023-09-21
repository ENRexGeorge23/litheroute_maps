import 'package:flutter/material.dart';
import 'package:litheroute_maps/MyColors.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/shared_prefs.dart';
import 'package:litheroute_maps/screens/store_map/widgets/duration_distance_tracker.dart';
import 'package:litheroute_maps/screens/store_map/widgets/list_of_stores.dart';
import 'package:litheroute_maps/screens/store_table/store_lists.dart';

class MapBottomSheet extends StatefulWidget {
  final Function(bool) updateMapSize;
  final ValueNotifier<bool> isExpandedNotifier;
  const MapBottomSheet({
    super.key,
    required this.updateMapSize,
    required this.isExpandedNotifier,
  });

  @override
  MapBottomSheetState createState() => MapBottomSheetState();
}

class MapBottomSheetState extends State<MapBottomSheet> {
  final bool _isExpanded = false;
  final MySharedPref _sharedPrefs = MySharedPref();
  ValueNotifier<bool> isExpandedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (DraggableScrollableNotification
              draggableScrollableNotification) {
            if (draggableScrollableNotification.extent >= 0.485 &&
                draggableScrollableNotification.extent <= 0.92) {
              setState(() {
                widget.updateMapSize(_isExpanded);
                widget.isExpandedNotifier.value = true;
              });
            } else if (draggableScrollableNotification.extent == 0.1155 ||
                draggableScrollableNotification.extent <= 0.48) {
              setState(() {
                widget.updateMapSize(_isExpanded);
                widget.isExpandedNotifier.value = false;
              });
            }

            return true;
          },
          child: DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              initialChildSize: 0.50,
              minChildSize: 0.1155,
              maxChildSize: 0.94,
              expand: _isExpanded,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Container(
                            height: 3,
                            width: 30,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const DistanceAndDurationTrackerWidget(),
                          const SizedBox(height: 5),
                          const Divider(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListOfStores(sharedPrefs: _sharedPrefs),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
