import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../matches%20statistics/champions%20scores.dart';
import '../matches%20statistics/league.dart';
import '../matches%20statistics/matches%20statistics.dart';
import '../matches%20statistics/matches%20summary.dart';
import '../matches%20statistics/players.dart';
import '../../providers/matches statistics provider.dart';
import '../../shared/const.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../articles/articles.dart';
import '../home/home.dart';
import 'package:provider/provider.dart';

import 'other articles.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late MatchesStatisticsProvider matchesStatisticsProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<MatchesStatisticsProvider>(context, listen: false).getScreens();
    super.initState();
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
          icon: const Icon(Icons.home),
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
        ),
      ),
      body: Directionality(
        textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            if (matchesStatisticsProvider.screens.isNotEmpty)
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const Articles());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[0].name.en : matchesStatisticsProvider.screens[0].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[0].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const OtherArticles());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[6].name.en : matchesStatisticsProvider.screens[6].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[5].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const PlayersTransaction());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[1].name.en : matchesStatisticsProvider.screens[1].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[1].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const MatchesStatistics());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[2].name.en : matchesStatisticsProvider.screens[2].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[2].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const ChampionsScores());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[3].name.en : matchesStatisticsProvider.screens[3].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[3].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const League());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[4].name.en : matchesStatisticsProvider.screens[4].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[4].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (settingModel.value == 'open') {
                          navigateAndFinish(context, const MatchesSummary());
                        } else {
                          showToast(
                              text: 'جاري العمل عليها',
                              state: ToastStates.SUCCESS);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 10, hasAppBar: true),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7f0e14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                language ? matchesStatisticsProvider.screens[5].name.en : matchesStatisticsProvider.screens[5].name.ar,
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(matchesStatisticsProvider
                                        .screens[5].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (matchesStatisticsProvider.screens.isEmpty)
              Expanded(
                child: Center(
                  child:
                  circularProgressIndicator(lightGrey, primaryColor, context),
                ),
              ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
