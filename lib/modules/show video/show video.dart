// ignore_for_file: must_be_immutable

import 'package:auto_orientation/auto_orientation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../providers/chat provider.dart';
import '../../shared/const.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class ShowVideo extends StatefulWidget {
  String videoLink;

  ShowVideo(this.videoLink, {Key? key}) : super(key: key);

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late ChatProvider chatProvider;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initVideoPlayer(widget.videoLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    return ConditionalBuilder(
      condition: chatProvider.videoPlayerController.value.isInitialized,
      builder: (context) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            bool isPortrait = orientation == Orientation.portrait;
            return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop(true);
                chatProvider.videoPlayerController.pause();
                chatProvider.isVideoPlay = false;
                return isPortrait;
              },
              child: Scaffold(
                backgroundColor: white,
                appBar: chatProvider.isPortrait
                    ? AppBar(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        title: appBarWidget(context),
                        centerTitle: true,
                        leading: IconButton(
                          onPressed: () {
                            chatProvider.killVideo();
                            navigatePop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: white),
                        ),
                      )
                    : null,
                body: isPortrait
                    ? videoPortrait(context, widget.videoLink, isPortrait)
                    : videoLandscape(context, widget.videoLink, isPortrait),
              ),
            );
          },
        );
      },
      fallback: (context) {
        return Center(
          child: circularProgressIndicator(white, primaryColor, context),
        );
      },
    );
  }

  Widget videoPortrait(
      BuildContext context, String videoLink, bool isPortrait) {
    return SizedBox(
      width: sizeFromWidth(context, 1),
      height: sizeFromHeight(context, 1, hasAppBar: true),
      child: Column(
        children: [
          SizedBox(
            width: sizeFromWidth(context, 1),
            height: sizeFromHeight(context, 1.8, hasAppBar: true),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (chatProvider.videoPlayerController.value.isInitialized)
                  AspectRatio(
                    aspectRatio:
                        chatProvider.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(chatProvider.videoPlayerController),
                  ),
                if (!chatProvider.videoPlayerController.value.isInitialized)
                  circularProgressIndicator(white, primaryColor, context),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider.adaptive(
                  activeColor: primaryColor,
                  inactiveColor: lightGrey,
                  value: chatProvider.position.inSeconds.toDouble(),
                  min: 0.0,
                  max: chatProvider
                      .videoPlayerController.value.duration.inSeconds
                      .toDouble(),
                  onChanged: (value) {
                    chatProvider.updateSliderPosition();
                    chatProvider.getVideoSeek(value);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${chatProvider.position.inMinutes.remainder(60)}:${(chatProvider.position.inSeconds.remainder(60))} ',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: sizeFromWidth(context, 20)),
                ),
                Text(
                  '${chatProvider.videoPlayerController.value.duration.inMinutes.remainder(60)}:${(chatProvider.videoPlayerController.value.duration.inSeconds.remainder(60))} ',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: sizeFromWidth(context, 20)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              materialButtonIcon(
                context,
                Icons.fast_rewind_rounded,
                sizeFromWidth(context, 10),
                primaryColor,
                white,
                () {
                  chatProvider.increaseOrDecrease(false);
                },
              ),
              materialButtonIcon(
                context,
                chatProvider.isVideoPlay ? Icons.pause : Icons.play_arrow,
                sizeFromWidth(context, 10),
                primaryColor,
                white,
                () {
                  chatProvider.pauseAndPlayVideo();
                },
              ),
              materialButtonIcon(
                context,
                Icons.fast_forward_rounded,
                sizeFromWidth(context, 10),
                primaryColor,
                white,
                () {
                  chatProvider.increaseOrDecrease(true);
                },
              ),
              const Spacer(),
              materialButtonIcon(
                context,
                Icons.fullscreen,
                sizeFromWidth(context, 10),
                primaryColor,
                white,
                () {
                  if (isPortrait) {
                    AutoOrientation.landscapeRightMode();
                  } else {
                    AutoOrientation.portraitUpMode();
                  }
                  chatProvider.changePortraitToLandscape(false);
                },
              ),
            ],
          ),
          const Spacer(),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }

  Widget videoLandscape(
      BuildContext context, String videoLink, bool isPortrait) {
    return InkWell(
      onTap: () {
        chatProvider.showControlVideo();
      },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                if (chatProvider.videoPlayerController.value.isInitialized)
                  AspectRatio(
                    aspectRatio:
                        chatProvider.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(chatProvider.videoPlayerController),
                  ),
                if (!chatProvider.videoPlayerController.value.isInitialized)
                  circularProgressIndicator(white, primaryColor, context),
                if (chatProvider.showControl)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      materialButtonIcon(
                        context,
                        Icons.fast_rewind_rounded,
                        sizeFromWidth(context, 10),
                        white,
                        white,
                        () {
                          chatProvider.increaseOrDecrease(false);
                        },
                      ),
                      materialButtonIcon(
                        context,
                        chatProvider.isVideoPlay
                            ? Icons.pause
                            : Icons.play_arrow,
                        sizeFromWidth(context, 10),
                        white,
                        white,
                        () {
                          chatProvider.pauseAndPlayVideo();
                        },
                      ),
                      materialButtonIcon(
                        context,
                        Icons.fast_forward_rounded,
                        sizeFromWidth(context, 10),
                        white,
                        white,
                        () {
                          chatProvider.increaseOrDecrease(true);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (chatProvider.showControl)
            Row(
              children: [
                Expanded(
                  child: Slider.adaptive(
                    activeColor: primaryColor,
                    inactiveColor: lightGrey,
                    value: chatProvider.position.inSeconds.toDouble(),
                    min: 0.0,
                    max: chatProvider
                        .videoPlayerController.value.duration.inSeconds
                        .toDouble(),
                    onChanged: (value) {
                      chatProvider.updateSliderPosition();
                      chatProvider.getVideoSeek(value);
                    },
                  ),
                ),
                Text(
                  '${chatProvider.position.inMinutes.remainder(60)}:${(chatProvider.position.inSeconds.remainder(60))} ',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: sizeFromWidth(context, 30)),
                ),
                Text(
                  '/ ${chatProvider.videoPlayerController.value.duration.inMinutes.remainder(60)}:${(chatProvider.videoPlayerController.value.duration.inSeconds.remainder(60))} ',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: sizeFromWidth(context, 30)),
                ),
                materialButtonIcon(
                  context,
                  Icons.fullscreen,
                  sizeFromWidth(context, 20),
                  primaryColor,
                  white,
                  () {
                    if (isPortrait) {
                      AutoOrientation.landscapeRightMode();
                    } else {
                      AutoOrientation.portraitUpMode();
                    }
                    chatProvider.changePortraitToLandscape(true);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
