import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum Status { failed, pending, delivered }

class StatusButtons extends StatefulWidget {
  const StatusButtons({
    super.key,
  });

  @override
  State<StatusButtons> createState() => _StatusButtonsState();
}

class _StatusButtonsState extends State<StatusButtons> {
  Status status = Status.pending;
  DateTime? deliveredTimestamp;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMMM dd, yyyy, hh:mm a');
    return Column(
      children: [
        SegmentedButton<Status>(
          segments: <ButtonSegment<Status>>[
            ButtonSegment<Status>(
              label: const Text('Failed'),
              value: Status.failed,
              icon: Icon(MdiIcons.packageVariantClosed),
            ),
            ButtonSegment<Status>(
              label: const Text('Delivered'),
              value: Status.delivered,
              icon: Icon(MdiIcons.packageVariant),
            ),
          ],
          selected: <Status>{status},
          onSelectionChanged: (newSelection) {
            setState(
              () {
                // By default there is only a single segment that can be
                // selected at one time, so its value is always the first
                // item in the selected set.
                status = newSelection.first;

                if (status == Status.delivered) {
                  // Collect the timestamp when Delivered is tapped

                  deliveredTimestamp = DateTime.now();
                  debugPrint('Delivered at $deliveredTimestamp');
                }
              },
            );
          },
        ),
        status == Status.delivered
            ? Text('Delivered on: ${formatter.format(deliveredTimestamp!)}')
            : const SizedBox.shrink(),
      ],
    );
  }
}
