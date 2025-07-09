import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import 'Fans_vote.dart';
import '../../providers/competition%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';
import 'package:jiffy/jiffy.dart';

class Competitions extends StatefulWidget {
  const Competitions({Key? key}) : super(key: key);

  @override
  State<Competitions> createState() => _CompetitionsState();
}

class _CompetitionsState extends State<Competitions> {
  bool language = CacheHelper.getData(key: 'language') ?? false;
  late CompetitionProvider competitionProvider;
  late OtherProvider otherProvider;


  String getState(String startTime, String endTime) {
    var pro = Provider.of<OtherProvider>(context, listen: false);
    startTime = Jiffy(startTime).yMMMd.toString();
    endTime = Jiffy(endTime).yMMMd.toString();
    if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return pro.getTexts('ready com').toString();
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0)) {
      return pro.getTexts('end com').toString();
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays ==
            0)) {
      return pro.getTexts('run com').toString();
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return pro.getTexts('run com').toString();
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays ==
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return pro.getTexts('run com').toString();
    }
    return '';
  }

  String getDate(String endTime) {
    var pro = Provider.of<OtherProvider>(context, listen: false);
    endTime = Jiffy(endTime).yMMMd.toString();
    if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays >
        0)) {
      return '${pro.getTexts('vote will close')}: ' '$endTime';
    } else if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays <
        0)) {
      return '${pro.getTexts('vote closed')}: ' '$endTime';
    } else if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays ==
        0)) {
      return '${pro.getTexts('vote close today')}: ' '$endTime';
    }
    return '';
  }

  @override
  void initState() {
    Provider.of<CompetitionProvider>(context, listen: false).getCompetitions();
    super.initState();
  }

  //'end com': 'ended',
  //   'ready com': 'not started',
  //   'run com': 'running',
  //   'number com': 'number of contestants',

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(
            Icons.home,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          Directionality(
            textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
            child: Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: competitionProvider.competitions.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      navigateAndFinish(
                        context,
                        FansVote(
                          competitionProvider.competitions[index],
                          getDate(
                              competitionProvider.competitions[index].endDate),
                          getState(
                                      competitionProvider
                                          .competitions[index].startDate,
                                      competitionProvider
                                          .competitions[index].endDate) ==
                                  otherProvider.getTexts('end com').toString()
                              ? true
                              : false,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      width: sizeFromWidth(context, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF7f0e14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            getState(
                                competitionProvider
                                    .competitions[index].startDate,
                                competitionProvider
                                    .competitions[index].endDate),
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: sizeFromWidth(context, 30),
                              fontWeight: FontWeight.bold,
                              color: getState(
                                          competitionProvider
                                              .competitions[index].startDate,
                                          competitionProvider
                                              .competitions[index].endDate) ==
                                  otherProvider.getTexts('end com').toString()
                                  ? Colors.blue
                                  : getState(
                                              competitionProvider
                                                  .competitions[index]
                                                  .startDate,
                                              competitionProvider
                                                  .competitions[index]
                                                  .endDate) ==
                                  otherProvider.getTexts('ready com').toString()
                                      ? Colors.amber
                                      : Colors.green,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${language ? competitionProvider.competitions[index].name.en : competitionProvider.competitions[index].name.ar}\n${otherProvider.getTexts('number com').toString()}: ${competitionProvider.competitions[index].subscribers}',
                              textDirection: !language
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
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
                                  image: NetworkImage(competitionProvider
                                      .competitions[index].image),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
