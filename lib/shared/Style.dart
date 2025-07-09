
import 'package:flutter/material.dart';

Color petroleum = const Color(0xFF324755);
Color white = Colors.white;
Color black = Colors.black;
Color lightGrey = Colors.grey.shade300;
Color lightGrey1 = const Color(0xFFf4f4f4);
Color darkGrey = Colors.grey.shade600;
Color amber = Colors.amber;
Color primaryColor = const Color(0xFF7f0e14);
Color lightRed = const Color(0xFFf93d3e);
Color scaffoldColor = const Color(0xFF1b1b1b);
Color pink = const Color(0xFFf3c2c6);

double sizeFromHeight(BuildContext context, double fraction,
    {bool hasAppBar = false}) {
  final screenHeight = MediaQuery.of(context).size.height;
  final calculateHeight = (hasAppBar
          ? (screenHeight -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top)
          : screenHeight) /
      fraction;
  return calculateHeight;
}

double sizeFromWidth(BuildContext context, double fraction) {
  final calculateWidth = MediaQuery.of(context).size.width / fraction;
  return calculateWidth;
}
