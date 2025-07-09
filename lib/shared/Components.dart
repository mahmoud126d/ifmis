// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../network/cash_helper.dart';
import 'Style.dart';
import 'const.dart';

Widget appBarWidget(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'IFMIS',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: sizeFromWidth(context, 23),
          color: white,
        ),
      ),
      Container(
        height: sizeFromHeight(context, 15, hasAppBar: true),
        width: sizeFromWidth(context, 6),
        decoration: const BoxDecoration(
          color: Color(0xFFbdbdbd),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/logo2.jpeg'),
          ),
        ),
      ),
    ],
  );
}

Widget bottomScaffoldWidget(BuildContext context) {
  return Container(
    color: primaryColor,
    height: sizeFromHeight(context, 10),
    width: sizeFromWidth(context, 1),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: CarouselSlider(
        items: downBanners.map((e) {
          return InkWell(
            onTap: () async {
              var url = Uri.parse(e.link);
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(e.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: sizeFromHeight(context, 5),
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ),
      ),
    ),
  );
}

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void navigatePop(BuildContext context) {
  Navigator.pop(context);
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) {
      return false;
    },
  );
}

Widget divider(double start, double end, Color color) {
  return Padding(
    padding: EdgeInsetsDirectional.only(
      start: start,
      end: end,
    ),
    child: Container(
      width: double.infinity,
      height: 1.0,
      color: color,
    ),
  );
}

StatefulWidget circularProgressIndicator(
  Color backgroundColor,
  Color colorWidget,
  BuildContext context,
) {
  if (Platform.isAndroid) {
    return CircularProgressIndicator(
      backgroundColor: backgroundColor,
      color: colorWidget,
      strokeWidth: 5,
    );
  } else {
    return CupertinoActivityIndicator(
      color: primaryColor,
      radius: sizeFromWidth(context, 15),
    );
  }
}

Text textWidget(String text, TextDirection? textDirection, TextAlign? textAlign,
    Color textColor, double? fontSize, FontWeight? fontWeight,
    [int? line, double? heightLine]) {
  return Text(
    text,
    textDirection: textDirection,
    textAlign: textAlign,
    maxLines: line,
    style: TextStyle(
        height: heightLine,
        decoration: TextDecoration.none,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Text textWidgetChat(
    String text,
    TextDirection? textDirection,
    TextAlign? textAlign,
    Color textColor,
    double? fontSize,
    FontWeight? fontWeight,
    int line) {
  return Text(
    text,
    textDirection: textDirection,
    textAlign: textAlign,
    maxLines: line,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

void showToast({
  required String text,
  required ToastStates state,
  ToastGravity? gravity,
  int? time,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: time ?? 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

TextButton textButton(
    BuildContext context,
    String text,
    Color overlayColor,
    Color textColor,
    double fontSize,
    FontWeight fontWeight,
    VoidCallback onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(overlayColor),
      backgroundColor: MaterialStateProperty.all(overlayColor),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}

FloatingActionButton floatTextButton(
    String hero,
    Widget? icon,
    Color colorButton,
    Color textColor,
    double fontSize,
    FontWeight fontWeight,
    String text,
    VoidCallback onTab) {
  return FloatingActionButton.extended(
    elevation: 0,
    icon: icon,
    backgroundColor: colorButton,
    hoverColor: colorButton,
    focusColor: colorButton,
    foregroundColor: colorButton,
    splashColor: colorButton,
    highlightElevation: 0,
    onPressed: onTab,
    label: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
    heroTag: hero,
  );
}

MaterialButton materialButtonIcon(
  BuildContext context,
  IconData icon,
  double iconSize,
  Color iconColor,
  Color highlightColor,
  VoidCallback onPressed,
) {
  return MaterialButton(
    onPressed: onPressed,
    highlightColor: highlightColor,
    child: Icon(
      icon,
      size: iconSize,
      color: iconColor,
    ),
  );
}

Material materialWidget(
    BuildContext context,
    double? childSizeHeight,
    double? childSizeWidth,
    double radius,
    String image,
    BoxFit fit,
    List<Widget> child,
    MainAxisAlignment mainAxisAlignment,
    bool boxExist,
    double? padding,
    Color? background,
    VoidCallback onPressed,
    [CrossAxisAlignment? crossAxisAlignment]) {
  return Material(
    borderRadius: BorderRadius.circular(radius),
    child: InkWell(
      onTap: onPressed,
      child: Hero(
        tag: image,
        child: Container(
          padding: EdgeInsets.all(padding ?? 0),
          height: childSizeHeight,
          width: childSizeWidth,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            image: image != null
                ? DecorationImage(
              image: NetworkImage(image),
              fit: fit,
            )
                : null,
            boxShadow: boxExist
                ? [
              BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 2,
                  offset: const Offset(0, 1),
                  color: darkGrey),
            ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment != null
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: child,
          ),
        ),
      ),
    ),
  );
}

Widget textFormField({
  TextEditingController? controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String hint,
  bool isSecure = false,
  Function(String?)? onSave,
  Function(String?)? onChange,
  Function()? onTap,
  Widget? suffixIcon,
  Color? borderColor,
  bool isExpanded = false,
  bool fromLTR = false,
  TextAlignVertical? textAlignVertical,
  int maxLines = 1,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: isExpanded ? 0 : 20),
    child: Directionality(
      textDirection: fromLTR ? TextDirection.ltr : TextDirection.rtl,
      child: TextFormField(
        onTap: onTap,
        keyboardType: type,
        onChanged: onChange,
        onSaved: onSave,
        maxLines: maxLines,
        controller: controller,
        validator: validate,
        obscureText: isSecure,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: petroleum,
          ),
          filled: true,
          fillColor: white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? black),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? black),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}

Widget buildListTile(
    BuildContext ctx, String title, IconData icon, VoidCallback tapHandler) {
  bool language = CacheHelper.getData(key: 'language') ?? false;
  return Directionality(
    textDirection: language ? TextDirection.ltr : TextDirection.rtl,
    child: ListTile(
      trailing: Icon(
        icon,
        color: white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: white,
          fontSize: sizeFromWidth(ctx, 25),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    ),
  );
}

CircleAvatar storyShape(
  BuildContext context,
  Color background,
  ImageProvider? backgroundImage,
  double radius1,
  double radius2,
) {
  return CircleAvatar(
    radius: sizeFromHeight(context, radius1),
    backgroundColor: background,
    child: CircleAvatar(
      radius: sizeFromHeight(context, radius2),
      backgroundColor: primaryColor,
      backgroundImage: backgroundImage,
    ),
  );
}
