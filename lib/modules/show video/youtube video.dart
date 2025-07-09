// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../providers/chat provider.dart';
import '../../providers/competition provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../Authentication/log in.dart';
import '../Authentication/sign up.dart';

class YoutubeVideo extends StatefulWidget {
  String videoLink;
  String pageName;
  int competitorId;

  YoutubeVideo(this.videoLink, this.pageName, this.competitorId, {Key? key})
      : super(key: key);

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  late ChatProvider chatProvider;
  late CompetitionProvider competitionProvider;

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      'تسجيل الدخول',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigateAndFinish(context, const LogIn());
      },
    );
    Widget continueButton = textButton(
      context,
      'إنشاء حساب',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigateAndFinish(context, const SignUP());
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        'يجب إنشاء حساب أو تسجيل الدخول',
        null,
        TextAlign.end,
        black,
        sizeFromWidth(context, 25),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.videoLink);
    if (widget.pageName == 'competition') {
      Provider.of<CompetitionProvider>(context, listen: false)
          .getComments(widget.competitorId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    competitionProvider = Provider.of(context);
    return Scaffold(
      appBar: chatProvider.youtubePlayerController.value.isFullScreen
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: white),
              backgroundColor: primaryColor,
              elevation: 0,
              title: appBarWidget(context),
              centerTitle: true,
            ),
      body: ConditionalBuilder(
        condition: !chatProvider.youtubePlayerController.value.hasError,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                          if (!chatProvider.youtubePlayerController.value.isFullScreen)
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      var url = Uri.parse(widget.videoLink);
                                      await launchUrl(url,
                                          mode: LaunchMode.inAppWebView);
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
                                        'الفيديو باليوتيوب',
                                        null,
                                        null,
                                        white,
                                        sizeFromWidth(context, 20),
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (!chatProvider.youtubePlayerController.value.isFullScreen && widget.pageName != 'match summary')
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: textWidget(
                                      'التعليقات',
                                      null,
                                      null,
                                      white,
                                      sizeFromWidth(context, 20),
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    for (int i = 0; i < competitionProvider.comments.length; i++)
                      if (widget.pageName == 'competition' && !chatProvider.youtubePlayerController.value.isFullScreen)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: materialWidget(
                                    context,
                                    null,
                                    sizeFromWidth(context, 1),
                                    15,
                                    "",
                                    BoxFit.fill,
                                    [
                                      textWidget(
                                        competitionProvider
                                            .comments[i].user.name,
                                        TextDirection.rtl,
                                        null,
                                        black,
                                        sizeFromWidth(context, 25),
                                        FontWeight.bold,
                                      ),
                                      textWidget(
                                        competitionProvider.comments[i].comment,
                                        TextDirection.rtl,
                                        null,
                                        black,
                                        sizeFromWidth(context, 30),
                                        FontWeight.bold,
                                      ),
                                    ],
                                    MainAxisAlignment.start,
                                    false,
                                    10,
                                    lightGrey,
                                    () {},
                                    CrossAxisAlignment.end),
                              ),
                              const SizedBox(width: 5),
                              storyShape(
                                context,
                                lightGrey,
                                competitionProvider.comments[i].user.image != ''
                                    ? NetworkImage(competitionProvider
                                        .comments[i].user.image)
                                    : null,
                                30,
                                33,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              if (!chatProvider.youtubePlayerController.value.isFullScreen)
                bottomScaffoldWidget(context),
            ],
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(white, primaryColor, context),
          );
        },
      ),
    );
  }
}
