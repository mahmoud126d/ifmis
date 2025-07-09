// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/ifmis/visit model.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/ifmis provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../show image/show image.dart';
import 'ifmis.dart';

class ShowVisit extends StatefulWidget {
  VisitModel visitModel;

  ShowVisit(this.visitModel, {Key? key}) : super(key: key);

  @override
  State<ShowVisit> createState() => _ShowVisitState();
}

class _ShowVisitState extends State<ShowVisit> {
  late IFMISProvider ifmisProvider;
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false)
        .getVisitDetails(widget.visitModel.id.toString())
        .then((value) {
      Provider.of<ChatProvider>(context, listen: false).initializeYoutubePlayer(
          Provider.of<IFMISProvider>(context, listen: false)
              .visitDetailsModel!
              .video);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: ifmisProvider.visitDetailsModel!.video.contains('youtu') &&
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
                  navigateAndFinish(context, const IFMIS());
                },
                icon: Icon(Icons.arrow_back, color: white),
              ),
            ),
      body: ConditionalBuilder(
        condition: ifmisProvider.isLoading == false &&
            ifmisProvider.visitDetailsModel!.images.isNotEmpty,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (ifmisProvider.visitDetailsModel!.video
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
                    if (ifmisProvider.visitDetailsModel!.video
                        .contains('youtu'))
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
                        language ? ifmisProvider.visitDetailsModel!.title.en : ifmisProvider.visitDetailsModel!.title.ar,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        language ? ifmisProvider.visitDetailsModel!.description.en : ifmisProvider.visitDetailsModel!.description.ar,
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
                            ifmisProvider.visitDetailsModel!.images.map((e) {
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
                  ifmisProvider.visitDetailsModel!.video.contains('youtu'))
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
