import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';
import 'package:image_picker/image_picker.dart';
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

  const IndividualStoreDetails({
    super.key,
  });

  @override
  IndividualStoreDetailsState createState() => IndividualStoreDetailsState();
}

class IndividualStoreDetailsState extends State<IndividualStoreDetails> {
  TextEditingController notesController = TextEditingController();
  String savedNotes = '';
  HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  @override
  Widget build(BuildContext context) {
    final storeData =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Proof of Delivery',
          style: TextStyle(color: MyColors.primaryColor),
        ),
        iconTheme: const IconThemeData(color: MyColors.primaryColor),
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
        child: Column(
          children: [
            const Divider(
              height: 3,
            ),
            Text(
              storeData['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: const Text('Customer Signature'),
                    leading: Icon(MdiIcons.pen),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showCustomerSignatureDialog();
                    },
                  ),
                  ListTile(
                    title: const Text('Capture Picture'),
                    leading: Icon(MdiIcons.camera),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
            )

            // TODO: implement Add Notes
          ],
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
            maxLines: 3,
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

  void _showCustomerSignatureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Column(
            children: [
              SizedBox(
                height: 720,
                width: 720,
                child: HandSignature(
                  control: control,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        control.clear();
                      });
                    },
                    child: const Text("Reset Signature"),
                  ),
                  FilledButton(
                      onPressed: () {}, child: const Text("Confirm Signature"))
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
