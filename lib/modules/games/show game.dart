// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/games provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../show image/show image.dart';
import 'all games.dart';

class ShowGames extends StatefulWidget {
  String gameID;

  ShowGames(this.gameID, {Key? key}) : super(key: key);

  @override
  State<ShowGames> createState() => _ShowGamesState();
}

class _ShowGamesState extends State<ShowGames> {
  late GamesProvider gamesProvider;
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false)
        .getGameDetails(widget.gameID)
        .then((value) {
      Provider.of<ChatProvider>(context, listen: false).initializeYoutubePlayer(
          Provider.of<GamesProvider>(context, listen: false)
              .gameDetailsModel!
              .video);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gamesProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: gamesProvider.gameDetailsModel!.video.contains('youtu') &&
              chatProvider.youtubePlayerController.value.isFullScreen
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: white),
              backgroundColor: primaryColor,
              elevation: 0,
              title: appBarWidget(context),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  navigateAndFinish(context, const AllGames());
                },
                icon: Icon(Icons.arrow_back, color: white),
              ),
            ),
      body: ConditionalBuilder(
        condition: gamesProvider.isLoading == false &&
            gamesProvider.gameDetailsModel!.images.isNotEmpty,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (gamesProvider.gameDetailsModel!.video.contains('youtu'))
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: YoutubePlayer(
                          controller: chatProvider.youtubePlayerController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: primaryColor,
                          progressColors: ProgressBarColors(
                            playedColor: primaryColor,
                            handleColor: lightGrey,
                          ),
                        ),
                      ),
                    if (gamesProvider.gameDetailsModel!.video.contains('youtu'))
                      SizedBox(height: sizeFromHeight(context, 40)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        language ? gamesProvider.gameDetailsModel!.name.en : gamesProvider.gameDetailsModel!.name.ar,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (Platform.isAndroid) {
                          var url =
                              Uri.parse(gamesProvider.gameDetailsModel.google);
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                        if (Platform.isIOS) {
                          var url =
                              Uri.parse(gamesProvider.gameDetailsModel.apple);
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: textWidget(
                          otherProvider.getTexts('download game').toString(),
                          null,
                          null,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        language ? gamesProvider.gameDetailsModel!.description.en : gamesProvider.gameDetailsModel!.description.ar,
                        TextDirection.rtl,
                        null,
                        black,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1 / 1,
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                            gamesProvider.gameDetailsModel!.images.map((e) {
                          return InkWell(
                            onTap: () {
                              navigateTo(context, ShowImage(e.image));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF151515),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(e.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                  gamesProvider.gameDetailsModel!.video.contains('youtu'))
                bottomScaffoldWidget(context),
            ],
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }
}
