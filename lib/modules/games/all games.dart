import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import 'show%20game.dart';
import '../../providers/games%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  late GamesProvider gamesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gamesProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(Icons.home, color: white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: gamesProvider.gameModel.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    navigateTo(
                        context, ShowGames(gamesProvider.gameModel[index].id.toString()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    width: sizeFromWidth(context, 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF7f0e14),
                    ),
                    child: Directionality(
                      textDirection: language ? TextDirection.rtl : TextDirection.ltr,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  language ? gamesProvider.gameModel[index].name.en : gamesProvider.gameModel[index].name.ar,
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
                                      image: NetworkImage(
                                          gamesProvider.gameModel[index].image),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
