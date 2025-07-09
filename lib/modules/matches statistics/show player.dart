// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../shared/const.dart';
import '../../models/statistics/player.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class ShowPlayer extends StatefulWidget {
  PlayerModel playerModel;

  ShowPlayer(this.playerModel, {Key? key}) : super(key: key);

  @override
  State<ShowPlayer> createState() => _ShowPlayerState();
}

class _ShowPlayerState extends State<ShowPlayer> {
  List numbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '/',
  ];

  String editText(String text) {
    String editing = '';
    for (int i = 0; i < text.length; i++) {
      if (numbers.contains(text[i])) {
        editing += text[i];
      }
    }
    return editing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: sizeFromWidth(context, 1),
                      height: sizeFromWidth(context, 2.5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primaryColor),
                        color: lightGrey,
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.playerModel.birthPlaceLogo.toString()),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -sizeFromHeight(context, 15),
                      child: Container(
                        width: sizeFromWidth(context, 3),
                        height: sizeFromHeight(context, 5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor),
                          color: lightGrey,
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.playerModel.profile.toString()),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizeFromHeight(context, 15)),
                Container(
                  width: sizeFromWidth(context, 4),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: textWidget(
                    widget.playerModel.name.trim(),
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                    null,
                    1,
                  ),
                ),
                Container(
                  width: sizeFromWidth(context, 4),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: textWidget(
                    widget.playerModel.position.trim(),
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                    null,
                    1,
                  ),
                ),
                itemsPlayer(
                    widget.playerModel.money.trim(),
                    ':سعر اللاعب',
                    context),
                itemsPlayer(
                    widget.playerModel.birthDate.trim().replaceAll(' ', ''),
                    ':تاريخ الميلاد',
                    context),
                itemsPlayer(
                  '',
                  ':مكان المنشأ',
                  context,
                  Container(
                    width: sizeFromWidth(context, 9),
                    height: sizeFromWidth(context, 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: primaryColor),
                      color: lightGrey,
                      image: DecorationImage(
                        image: NetworkImage(
                            widget.playerModel.birthPlaceLogo.toString()),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                itemsPlayer(widget.playerModel.age.trim(), ':العمر', context),
                itemsPlayer(
                    widget.playerModel.height.trim(), ':الطول', context),
                itemsPlayer(
                    widget.playerModel.citizen.trim(), ':المواطنة', context),
                itemsPlayer(
                    widget.playerModel.position.trim(), ':مكان اللاعب', context),
                itemsPlayer(widget.playerModel.foot.trim(), ':القدم', context),
                itemsPlayer(widget.playerModel.playerAgent.trim() == ''
                    ? 'لم يحدد بعد'
                    : widget.playerModel.playerAgent.trim(),
                    ':وكيل اللاعب', context),
                itemsPlayer(
                  '',
                  ':النادى الحالى',
                  context,
                  Row(
                    children: [
                      Container(
                        width: sizeFromWidth(context, 12),
                        height: sizeFromWidth(context, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: primaryColor),
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.playerModel.currentCubLogo.toString()),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: textWidget(
                          widget.playerModel.currentCub.trim(),
                          null,
                          null,
                          white,
                          sizeFromWidth(context, 30),
                          FontWeight.bold,
                          null,
                          1,
                        ),
                      ),
                    ],
                  ),
                ),
                itemsPlayer(
                    widget.playerModel.joinedDate.trim(), ':تاريخ الإنضمام', context),
                itemsPlayer(widget.playerModel.contractExpire.trim(),
                    ':تاريخ إنتهاء العقد', context),
                itemsPlayer(
                    widget.playerModel.outFitter.trim() == ''
                        ? 'لم يحدد بعد'
                        : widget.playerModel.outFitter.trim(),
                    ':الملابس الرسمية',
                    context),
                itemsPlayer(editText(widget.playerModel.goals.trim()),
                    ':الكأس/الأهداف', context),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }

  Widget itemsPlayer(String secondText, String firstText, BuildContext context,
      [Widget? widget]) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor),
      ),
      margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
      padding: EdgeInsets.all(widget == null ? 10 : 5),
      child: Row(
        children: [
          if (widget == null)
            Expanded(
              child: textWidget(
                secondText,
                TextDirection.ltr,
                null,
                white,
                sizeFromWidth(context, 25),
                FontWeight.bold,
              ),
            ),
          widget ?? const SizedBox(),
          if (widget != null) const Spacer(),
          textWidget(
            firstText,
            null,
            null,
            white,
            sizeFromWidth(context, 20),
            FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
