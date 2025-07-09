// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../shared/Style.dart';

class ShowImage extends StatefulWidget {
  String image;

  ShowImage(this.image, {Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
      ),
      body: Container(
        width: sizeFromWidth(context, 1),
        height: sizeFromHeight(context, 1, hasAppBar: true),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image),
          ),
        ),
      ),
    );
  }
}
