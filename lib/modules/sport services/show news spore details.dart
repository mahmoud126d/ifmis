// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20services/sport%20services%20comments.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/sport services/sport services news.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../providers/sport services provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../Chat/chat.dart';
import '../profile/profile.dart';
import '../show image/show image.dart';
//import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:share_plus/share_plus.dart';

class ShowNewsSporeDetails extends StatefulWidget {
  SportServicesNewsModel sportServicesNewsModel;

  ShowNewsSporeDetails(this.sportServicesNewsModel, {Key? key})
      : super(key: key);

  @override
  State<ShowNewsSporeDetails> createState() => _ShowNewsSporeDetailsState();
}

class _ShowNewsSporeDetailsState extends State<ShowNewsSporeDetails> {
  late ChatProvider chatProvider;
  late SportServicesProvider sportServicesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.sportServicesNewsModel.videoLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sportServicesProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: widget.sportServicesNewsModel.videoLink.contains('youtu') &&
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
        condition: !sportServicesProvider.isLoading,
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
                                if (widget
                                        .sportServicesNewsModel.publisherName !=
                                    '')
                                  textWidget(
                                    '${otherProvider.getTexts('details player name')}: ${language ? widget.sportServicesNewsModel.title.en : widget.sportServicesNewsModel.title.ar}',
                                    TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                  ),
                                if (widget.sportServicesNewsModel
                                        .tellAboutYourself !=
                                    '')
                                  textWidget(
                                    '${otherProvider.getTexts('player academy')}: ${widget.sportServicesNewsModel.publisherName}',
                                    TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                  ),
                                textWidget(
                                  '${otherProvider.getTexts('details date')}: ${widget.sportServicesNewsModel.date}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (widget.sportServicesNewsModel
                                            .publisherCountryImage !=
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
                                                .sportServicesNewsModel
                                                .publisherCountryImage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 2),
                                    if (widget.sportServicesNewsModel
                                            .publisherCountry !=
                                        '')
                                      textWidget(
                                        widget.sportServicesNewsModel
                                            .publisherCountry,
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
                        if (widget.sportServicesNewsModel.videoLink
                            .contains('youtu'))
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
                                if (widget.sportServicesNewsModel.user != null)
                                  IconButton(
                                    onPressed: () {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .getDataOtherUser(
                                              context,
                                              widget.sportServicesNewsModel
                                                  .user!.id
                                                  .toString())
                                          .then((value) {
                                        navigateTo(
                                            context,
                                            Profile(
                                                widget.sportServicesNewsModel
                                                    .user!.id
                                                    .toString(),
                                                'chat',
                                                false,
                                                false,
                                                '',
                                                false));
                                      });
                                    },
                                    icon: Icon(Icons.person_outline_rounded,
                                        color: white),
                                  ),
                                Expanded(
                                  child: textWidget(
                                    language
                                        ? widget.sportServicesNewsModel.title.en
                                        : widget
                                            .sportServicesNewsModel.title.ar,
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
                                .youtubePlayerController.value.isFullScreen &&
                            widget.sportServicesNewsModel.description.en != '')
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: textWidget(
                              language
                                  ? widget.sportServicesNewsModel.description.en
                                  : widget
                                      .sportServicesNewsModel.description.ar,
                              language ? TextDirection.ltr : TextDirection.rtl,
                              null,
                              black,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
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
                                  widget.sportServicesNewsModel.images.map((e) {
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
                        SizedBox(height: sizeFromHeight(context, 90)),
                        if (!chatProvider
                                .youtubePlayerController.value.isFullScreen &&
                            widget.sportServicesNewsModel.user != null &&
                            widget.sportServicesNewsModel.user!.chat != null)
                          InkWell(
                            onTap: () {
                              navigateTo(
                                context,
                                Chat(
                                    language
                                        ? widget.sportServicesNewsModel.user!
                                            .chat!.name.en
                                        : widget.sportServicesNewsModel.user!
                                            .chat!.name.ar,
                                    'sport services',
                                    widget
                                        .sportServicesNewsModel.user!.chat!.id,
                                    int.parse(widget.sportServicesNewsModel
                                        .user!.chat!.categoryID)),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  textWidget(
                                    otherProvider
                                        .getTexts('details policy 1')
                                        .toString(),
                                    null,
                                    null,
                                    white,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                  textWidget(
                                    otherProvider
                                        .getTexts('details policy 2')
                                        .toString(),
                                    null,
                                    null,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  final iosLink = 'https://apps.apple.com/app/%D8%A7%D9%84%D8%A7%D8%AA%D8%AD%D8%A7%D8%AF-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A-ifmis/id1670802361';
                                  final androidLink = 'https://play.google.com/store/apps/details?id=dev.ifmis.news';

                                  Share.share(
                                    Platform.isIOS ? iosLink : androidLink,
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
                                      SportServicesComments(
                                          widget.sportServicesNewsModel.id));
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
                        SizedBox(height: sizeFromHeight(context, 90)),
                      ],
                    ),
                  ),
                  if (!chatProvider
                          .youtubePlayerController.value.isFullScreen &&
                      widget.sportServicesNewsModel.videoLink.contains('youtu'))
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
}
