
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../matches%20statistics/statistics.dart';
import '../matches%20statistics/match%20details.dart';
import '../../providers/matches%20statistics%20provider.dart';
import 'package:provider/provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class MatchesStatistics extends StatefulWidget {
  const MatchesStatistics({Key? key}) : super(key: key);

  @override
  State<MatchesStatistics> createState() => _MatchesStatisticsState();
}

class _MatchesStatisticsState extends State<MatchesStatistics> {
  late MatchesStatisticsProvider matchesStatisticsProvider;

  @override
  void initState() {
    Provider.of<MatchesStatisticsProvider>(context, listen: false)
        .getDateOfDay();
    Provider.of<MatchesStatisticsProvider>(context, listen: false).getMatches(
        Provider.of<MatchesStatisticsProvider>(context, listen: false).date);
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const Statistics());
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                  ),
                  height: sizeFromHeight(context, 15),
                  alignment: Alignment.center,
                  child: textWidget(
                    matchesStatisticsProvider.getNameOfDay == ''
                        ? 'مباريات اليوم'
                        : 'مباريات ${matchesStatisticsProvider.getNameOfDay}',
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    matchesStatisticsProvider.selectDatePerDay(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    height: sizeFromHeight(context, 15),
                    alignment: Alignment.center,
                    child: textWidget(
                      matchesStatisticsProvider.date,
                      null,
                      null,
                      primaryColor,
                      sizeFromWidth(context, 20),
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ConditionalBuilder(
            condition: matchesStatisticsProvider.matches.isNotEmpty,
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = matchesStatisticsProvider.matches;
                    return InkWell(
                      onTap: () {
                        navigateAndFinish(context, MatchDetails(data[index]));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: sizeFromHeight(context, 18),
                                  width: sizeFromHeight(context, 18),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          data[index].firstClub.image),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: sizeFromHeight(context, 10),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                      data[index].firstClub.name,
                                      null,
                                      TextAlign.center,
                                      white,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                      null,
                                      1),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                if (data[index].middle == 'انتهت')
                                  textWidget(
                                    '${data[index].secondClub.score} : ${data[index].firstClub.score}',
                                    TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                  ),
                                if (data[index].middle != 'انتهت')
                                  textWidget(
                                    data[index].matchTime,
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
                                    data[index].middle,
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
                              children: [
                                Container(
                                  height: sizeFromHeight(context, 18),
                                  width: sizeFromHeight(context, 18),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            data[index].secondClub.image)),
                                  ),
                                ),
                                Container(
                                  width: sizeFromHeight(context, 10),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                      data[index].secondClub.name,
                                      null,
                                      TextAlign.center,
                                      white,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                      null,
                                      1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: matchesStatisticsProvider.matches.length,
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
