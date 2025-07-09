import 'package:flutter/material.dart';
import 'package:ifmis/modules/matches%20statistics/statistics.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/cash_helper.dart';
import '../../providers/ifmis provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class OtherArticles extends StatefulWidget {
  const OtherArticles({Key? key}) : super(key: key);

  @override
  State<OtherArticles> createState() => _OtherArticlesState();
}

class _OtherArticlesState extends State<OtherArticles> {
  late IFMISProvider ifmisProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false).getChampionshipStats("1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Statistics());
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Directionality(
        textDirection: language ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ifmisProvider.championshipStatsModel.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () async {
                      var url = Uri.parse(
                          ifmisProvider.championshipStatsModel[index].link);
                      await launchUrl(url, mode: LaunchMode.inAppWebView);
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
                              language ? ifmisProvider.championshipStatsModel[index].title.en : ifmisProvider.championshipStatsModel[index].title.ar,
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
                            height: sizeFromHeight(context, 12, hasAppBar: true),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(ifmisProvider
                                      .championshipStatsModel[index].image),
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
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
