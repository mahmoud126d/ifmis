import 'package:flutter/material.dart';
import '../../shared/Components.dart';

import '../../shared/Style.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeFromWidth(context, 1),
      height: sizeFromHeight(context, 1),
      alignment: Alignment.center,
      child: textWidget(
        'Stopped',
        null,
        null,
        Colors.red,
        sizeFromWidth(context, 10),
        FontWeight.bold,
      ),
    );
  }
}
