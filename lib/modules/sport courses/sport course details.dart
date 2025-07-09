// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20courses/show%20questions.dart';
import 'package:ifmis/modules/sport%20courses/sport%20courses.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/sports courses/Sports courses.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../providers/sport courses provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class SportCourseDetails extends StatefulWidget {
  String categoryID;
  SportsCoursesModel sportsCoursesModel;

  SportCourseDetails(this.sportsCoursesModel, this.categoryID, {Key? key}) : super(key: key);

  @override
  State<SportCourseDetails> createState() => _SportCourseDetailsState();
}

class _SportCourseDetailsState extends State<SportCourseDetails> {
  late ChatProvider chatProvider;
  late SportCoursesProvider sportCoursesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.sportsCoursesModel.videoLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    sportCoursesProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    String name = CacheHelper.getData(key: 'name') ?? '';
    return Scaffold(
      backgroundColor: white,
      appBar: widget.sportsCoursesModel.videoLink.contains('youtu') &&
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
                  navigateAndFinish(context, SportCourses(widget.categoryID));
                },
                icon: Icon(Icons.arrow_back, color: white),
              ),
            ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (!chatProvider.youtubePlayerController.value.isFullScreen)
                  Container(
                    width: sizeFromWidth(context, 1),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: language ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        textWidget(
                          '${otherProvider.getTexts('course name')}: ${language ? widget.sportsCoursesModel.name.en : widget.sportsCoursesModel.name.ar}',
                          TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 25),
                          FontWeight.bold,
                        ),
                        textWidget(
                          '${otherProvider.getTexts('your user name')}: $name',
                          language ? TextDirection.ltr : TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 25),
                          FontWeight.bold,
                        ),
                        textWidget(
                          '${otherProvider.getTexts('day date')}: ${intl.DateFormat.yMMMMd().format(DateTime.now())}',
                          TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 25),
                          FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                if (widget.sportsCoursesModel.videoLink.contains('youtu'))
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
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: textWidget(
                            '${otherProvider.getTexts('the success rate')}: ${widget.sportsCoursesModel.successRate} %',
                            language ? TextDirection.ltr : TextDirection.rtl,
                            null,
                            white,
                            language ? sizeFromWidth(context, 25) : sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var link = Uri.parse(widget.sportsCoursesModel.fileOfCourse);
                          await launchUrl(link, mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: textWidget(
                            otherProvider.getTexts('course file').toString(),
                            language ? TextDirection.ltr : TextDirection.rtl,
                            null,
                            white,
                            language ? sizeFromWidth(context, 25) : sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen)
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateAndFinish(context, ShowQuestions(widget.sportsCoursesModel, widget.categoryID));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: textWidget(
                              otherProvider.getTexts('start questions').toString(),
                              TextDirection.rtl,
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
              ],
            ),
          ),
         if (!chatProvider.youtubePlayerController.value.isFullScreen)
            bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
