import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/matches statistics provider.dart';
import '../matches%20statistics/statistics.dart';
import '../matches%20statistics/teams.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';

class League extends StatefulWidget {
  const League({Key? key}) : super(key: key);

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  DateTime now = DateTime.now();

  late MatchesStatisticsProvider matchesStatisticsProvider;

  @override
  void initState() {
    Provider.of<MatchesStatisticsProvider>(context, listen: false)
        .filterTeams();
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
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                for (int i = 0;
                    i < matchesStatisticsProvider.teamsFiltered.length;
                    i++)
                  itemCard(matchesStatisticsProvider.teamsFiltered[i]),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }

  Widget itemCard(String title) {
    return InkWell(
      onTap: () {
        navigateAndFinish(context, Teams(title));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            textWidget(
              title,
              null,
              null,
              white,
              sizeFromWidth(context, 20),
              FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
