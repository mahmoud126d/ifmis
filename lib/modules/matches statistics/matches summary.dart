
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../matches%20statistics/statistics.dart';
import '../show%20video/youtube%20video.dart';
import 'package:provider/provider.dart';
import '../../providers/matches statistics provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../show video/show video.dart';

class MatchesSummary extends StatefulWidget {
  const MatchesSummary({Key? key}) : super(key: key);

  @override
  State<MatchesSummary> createState() => _MatchesSummaryState();
}

class _MatchesSummaryState extends State<MatchesSummary> {
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<MatchesStatisticsProvider>(context, listen: false)
        .getMatchesSummary();
    super.initState();
  }

  late MatchesStatisticsProvider matchesStatisticsProvider;

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
            navigateAndFinish(context, const Statistics());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ConditionalBuilder(
              condition: matchesStatisticsProvider.matchesSummary.isNotEmpty,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 15, right: 15),
                        decoration: const BoxDecoration(
                          color: Color(0xFF151515),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: sizeFromWidth(context, 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF39373a),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        matchesStatisticsProvider
                                            .matchesSummary[index].image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      if (matchesStatisticsProvider
                                              .matchesSummary[index].url
                                              .toString()
                                              .contains('youtube') ||
                                          matchesStatisticsProvider
                                              .matchesSummary[index].url
                                              .toString()
                                              .contains('youtu.be')) {
                                        navigateTo(
                                            context,
                                            YoutubeVideo(
                                                matchesStatisticsProvider
                                                    .matchesSummary[index].url,
                                                'match summary',
                                                0));
                                      } else {
                                        navigateTo(
                                            context,
                                            ShowVideo(matchesStatisticsProvider
                                                .matchesSummary[index].url));
                                      }
                                    },
                                    icon:
                                        Icon(Icons.play_circle, color: white)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                language ? matchesStatisticsProvider
                                    .matchesSummary[index].title.en : matchesStatisticsProvider
                                    .matchesSummary[index].title.ar,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: sizeFromWidth(context, 30),
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: matchesStatisticsProvider.matchesSummary.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1 / 1,
                    ),
                  ),
                );
              },
              fallback: (context){
                return Center(
                  child: textWidget(
                    'لا يوجد ملخصات مبارايات',
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
