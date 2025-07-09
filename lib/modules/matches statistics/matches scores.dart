// ignore_for_file: must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/matches statistics provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'champions scores.dart';

class MatchesScores extends StatefulWidget {
  String champion;

  MatchesScores(this.champion, {Key? key}) : super(key: key);

  @override
  State<MatchesScores> createState() => _MatchesScoresState();
}

class _MatchesScoresState extends State<MatchesScores> {
  late MatchesStatisticsProvider matchesStatisticsProvider;
  List arabic = [
    'ظ',
    'ز',
    'و',
    'ة',
    'آ',
    'ى',
    'لآ',
    'لا',
    'ر',
    'ؤ',
    'ء',
    'ئ',
    'لأ',
    'لإ',
    'إ',
    'أ',
    'ط',
    'ك',
    'م',
    'ن',
    'ت',
    'ا',
    'ل',
    'ب',
    'ي',
    'س',
    'ش',
    'ض',
    'ص',
    'ث',
    'ق',
    'ف',
    'غ',
    'ع',
    'ه',
    'خ',
    'ح',
    'ج',
    'د',
    'ذ',
  ];

  String removeArabic(String text) {
    String textAfterEdit = '';
    for (int i = 0; i < text.length; i++) {
      if (!arabic.contains(text[i])) {
        textAfterEdit += text[i];
      }
    }
    return textAfterEdit.trim();
  }

  @override
  Widget build(BuildContext context) {
    matchesStatisticsProvider = Provider.of(context);
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
            navigateAndFinish(context, const ChampionsScores());
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'الأهداف',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'الدولة/الفريق',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'اللاعب',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 27),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'ت',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ConditionalBuilder(
            condition: scores.isNotEmpty,
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = scores;
                    if (data[index].champName == widget.champion) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: textWidget(
                                  data[index].goals.toString(),
                                  null,
                                  null,
                                  white,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                )),
                            Container(
                              width: sizeFromWidth(context, 10),
                              height: sizeFromWidth(context, 15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: data[index].logo != ''
                                    ? DecorationImage(
                                        image: NetworkImage(data[index].logo),
                                      )
                                    : null,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                textWidget(
                                    removeArabic(data[index].name.toString()),
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                    null,
                                    1),
                                textWidget(
                                  data[index].aldawla.toString(),
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                ),
                              ],
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding:
                                  EdgeInsets.all(sizeFromWidth(context, 20)),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                image: data[index].img != ''
                                    ? DecorationImage(
                                        image: NetworkImage(data[index].img),
                                      )
                                    : null,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: textWidget(
                                data[index].rank.toString(),
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  itemCount: scores.length,
                ),
              );
            },
            fallback: (context) {
              return Expanded(
                  child: Center(
                      child: circularProgressIndicator(
                          lightGrey, primaryColor, context)));
            },
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
