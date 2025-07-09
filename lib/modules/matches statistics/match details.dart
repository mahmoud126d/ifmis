// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/statistics/matches statistics.dart';
import '../../shared/Components.dart';
import '../../shared/const.dart';
import '../../shared/Style.dart';
import 'matches statistics.dart';

class MatchDetails extends StatefulWidget {
  MatchesStatisticsModel matchesStatisticsModel;

  MatchDetails(this.matchesStatisticsModel, {Key? key}) : super(key: key);

  @override
  State<MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const MatchesStatistics());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: sizeFromHeight(context, 4),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: sizeFromHeight(context, 8),
                            width: sizeFromHeight(context, 8),
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.matchesStatisticsModel.firstClub.image),
                              ),
                            ),
                          ),
                          textWidget(
                            widget.matchesStatisticsModel.firstClub.name,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.matchesStatisticsModel.middle == 'انتهت')
                            textWidget(
                              '${widget.matchesStatisticsModel.secondClub.score} : ${widget.matchesStatisticsModel.firstClub.score}',
                              TextDirection.rtl,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          if (widget.matchesStatisticsModel.middle != 'انتهت')
                            textWidget(
                              widget.matchesStatisticsModel.matchTime,
                              TextDirection.rtl,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: textWidget(
                              widget.matchesStatisticsModel.middle,
                              TextDirection.rtl,
                              null,
                              primaryColor,
                              sizeFromWidth(context, 30),
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: sizeFromHeight(context, 8),
                            width: sizeFromHeight(context, 8),
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      widget.matchesStatisticsModel.secondClub.image)),
                            ),
                          ),
                          textWidget(
                            widget.matchesStatisticsModel.secondClub.name,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.center,
                  child: textWidget(
                    'معلومات اللقاء',
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                  ),
                ),
                itemsMatch(FontAwesomeIcons.award, 'البطولة', widget.matchesStatisticsModel.champName, context),
                //itemsMatch(FontAwesomeIcons.microphone, 'المعلق', widget.matchesStatisticsModel.muealaq, context),
                itemsMatch(FontAwesomeIcons.tv, 'القناة الناقلة ', widget.matchesStatisticsModel.liveChannel, context),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}

Widget itemsMatch(
  IconData? icon,
  String secondText,
  String firstText,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      color: lightGrey,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: primaryColor),
    ),
    margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: textWidget(
            firstText,
            null,
            TextAlign.center,
            primaryColor,
            sizeFromWidth(context, 20),
            FontWeight.bold,
          ),
        ),
        textWidget(
          secondText,
          null,
          null,
          darkGrey,
          sizeFromWidth(context, 25),
          FontWeight.bold,
        ),
        Icon(icon, color: primaryColor),
      ],
    ),
  );
}
