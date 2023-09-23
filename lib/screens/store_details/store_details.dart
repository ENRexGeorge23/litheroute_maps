import 'package:flutter/material.dart';
import 'package:litheroute_maps/MyColors.dart';
import 'package:litheroute_maps/constants/store_data.dart';
import 'package:litheroute_maps/helpers/shared_prefs.dart';
import 'package:litheroute_maps/screens/store_map/widgets/duration_distance_tracker.dart';
import 'package:litheroute_maps/screens/store_map/widgets/list_of_stores.dart';
import 'package:litheroute_maps/screens/store_map/widgets/status_buttons.dart';
import 'package:litheroute_maps/screens/store_table/store_lists.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IndividualStoreDetails extends StatefulWidget {
  static const String routeName = "/store-details";

  // final Function(bool) updateMapSize;
  // final ValueNotifier<bool> isExpandedNotifier;
  const IndividualStoreDetails({
    super.key,
    // required this.updateMapSize,
    // required this.isExpandedNotifier,
  });

  @override
  IndividualStoreDetailsState createState() => IndividualStoreDetailsState();
}

class IndividualStoreDetailsState extends State<IndividualStoreDetails> {
  final bool _isExpanded = false;
  final MySharedPref _sharedPrefs = MySharedPref();
  TextEditingController notesController = TextEditingController();
  String savedNotes = '';

  @override
  Widget build(BuildContext context) {
    final storeData =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: MyColors.primaryColor),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: DraggableScrollableActuator(
          child: DraggableScrollableSheet(
            initialChildSize: 0.50,
            minChildSize: 0.1155,
            maxChildSize: 0.94,
            expand: _isExpanded,
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: [
                  const Divider(
                    height: 3,
                  ),
                  Text(
                    storeData['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const StatusButtons(),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: savedNotes.isNotEmpty
                              ? Text(savedNotes)
                              : const Text(
                                  'Add Notes',
                                  style: TextStyle(color: Colors.grey),
                                ),
                          leading: const Icon(Icons.description),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showAddNotesDialog();
                          },
                        ),
                      ],
                    ),
                  )

                  // TODO: implement Add Notes
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to show the Add Notes dialog
  void _showAddNotesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Notes'),
          content: TextField(
            controller: notesController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Enter your notes here',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: const Text('Save'),
              onPressed: () {
                // Handle saving the notes here
                setState(() {
                  savedNotes = notesController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
