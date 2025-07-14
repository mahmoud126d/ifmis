import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ifmis/modules/talent%20exploration/talent%20add%20comment.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/talents/specific talent.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../providers/talent provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../profile/profile.dart';
import '../show image/show image.dart';

class TalentDetails extends StatefulWidget {
  SpecificTalentModel specificTalentModel;

  TalentDetails(this.specificTalentModel, {Key? key}) : super(key: key);

  @override
  State<TalentDetails> createState() => _TalentDetailsState();
}

class _TalentDetailsState extends State<TalentDetails> {
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  late TalentProvider talentProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.specificTalentModel.video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    talentProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: widget.specificTalentModel.video.contains('youtu') &&
              chatProvider.youtubePlayerController.value.isFullScreen
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: white),
              backgroundColor: primaryColor,
              elevation: 0,
              title: appBarWidget(context),
              centerTitle: true,
            ),
      body: ConditionalBuilder(
        condition: !talentProvider.isLoading,
        builder: (context) {
          return Directionality(
              textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: sizeFromHeight(context, 90)),
                        if (!chatProvider
                            .youtubePlayerController.value.isFullScreen)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                textWidget(
                                  '${otherProvider.getTexts('talent name')}: ${language ? widget.specificTalentModel.playerName.en : widget.specificTalentModel.playerName.ar}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  '${otherProvider.getTexts('talent position')}: ${widget.specificTalentModel.position}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  '${otherProvider.getTexts('talent age')}: ${widget.specificTalentModel.age}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  '${otherProvider.getTexts('talent height')}: ${widget.specificTalentModel.height}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  '${otherProvider.getTexts('talent school')}: ${widget.specificTalentModel.school}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  '${otherProvider.getTexts('talent class')}: ${widget.specificTalentModel.classRoom}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (widget
                                            .specificTalentModel.countryImage !=
                                        '')
                                      Container(
                                        width: sizeFromWidth(context, 9),
                                        height: sizeFromWidth(context, 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border:
                                              Border.all(color: primaryColor),
                                          color: lightGrey,
                                          image: DecorationImage(
                                            image: NetworkImage(widget
                                                .specificTalentModel
                                                .countryImage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 2),
                                    if (widget
                                            .specificTalentModel.countryName !=
                                        '')
                                      textWidget(
                                        widget.specificTalentModel.countryName,
                                        TextDirection.rtl,
                                        null,
                                        white,
                                        sizeFromWidth(context, 25),
                                        FontWeight.bold,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (widget.specificTalentModel.video.contains('youtu'))
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
                        SizedBox(height: sizeFromHeight(context, 90)),
                        if (!chatProvider
                            .youtubePlayerController.value.isFullScreen)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .getDataOtherUser(
                                            context,
                                            widget.specificTalentModel.userID
                                                .toString())
                                        .then(
                                      (value) {
                                        navigateTo(
                                            context,
                                            Profile(
                                                widget
                                                    .specificTalentModel.userID
                                                    .toString(),
                                                'chat',
                                                false,
                                                false,
                                                '',
                                                false));
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.person_outline_rounded,
                                      color: white),
                                ),
                                Expanded(
                                  child: textWidget(
                                    language
                                        ? widget
                                            .specificTalentModel.playerName.en
                                        : widget
                                            .specificTalentModel.playerName.ar,
                                    language
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!chatProvider
                            .youtubePlayerController.value.isFullScreen)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1 / 1,
                              physics: const NeverScrollableScrollPhysics(),
                              children:
                                  widget.specificTalentModel.images.map((e) {
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
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  const message = 'شارك معنا في منافسة استكشاف وتطوير المواهب في مختلف الألعاب الرياضية';
                                  const iosLink = 'https://apps.apple.com/app/%D8%A7%D9%84%D8%A7%D8%AA%D8%AD%D8%A7%D8%AF-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A-ifmis/id1670802361';
                                  const androidLink = 'https://play.google.com/store/apps/details?id=dev.ifmis.news';

                                  final fullText = '$message\n${Platform.isIOS ? iosLink : androidLink}';

                                  Share.share(
                                    fullText,
                                    subject: 'مشاركة',
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                    otherProvider.getTexts('share').toString(),
                                    TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigateTo(
                                      context,
                                      TalentAddComment(
                                          widget.specificTalentModel));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                    otherProvider
                                        .getTexts('comment')
                                        .toString(),
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
                        InkWell(
                          onTap: () async {
                            var url = Uri.parse(
                                'whatsapp://send?phone=${settingModel.whatsNumber}');
                            await launchUrl(url,
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: textWidget(
                              otherProvider
                                  .getTexts('talent support')
                                  .toString(),
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
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: textWidget(
                                  widget.specificTalentModel.points.toString(),
                                  TextDirection.rtl,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 20),
                                  FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Icon(Icons.star, color: white, size: sizeFromWidth(context, 10),),
                              ),
                              InkWell(
                                onTap: () {
                                  talentProvider.addTalentRate(
                                      widget.specificTalentModel);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                    otherProvider
                                        .getTexts('talent point')
                                        .toString(),
                                    TextDirection.rtl,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sizeFromHeight(context, 90)),
                      ],
                    ),
                  ),
                  if (!chatProvider
                          .youtubePlayerController.value.isFullScreen &&
                      widget.specificTalentModel.video.contains('youtu'))
                    bottomScaffoldWidget(context),
                ],
              ));
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }

  Widget _image(String asset) => Image.asset(
        asset,
        color: amber,
      );
}
