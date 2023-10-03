import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hand_signature/signature.dart';

class CustomerSignature extends StatefulWidget {
  const CustomerSignature({super.key});

  @override
  State<CustomerSignature> createState() => _CustomerSignatureState();
}

class _CustomerSignatureState extends State<CustomerSignature> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Container(
        child: HandSignature(
          control: HandSignatureControl(
            threshold: 0.01,
            smoothRatio: 0.65,
            velocityRange: 2.0,
          ),
          color: Colors.black,
        ),
      ),
    );
  }
}
