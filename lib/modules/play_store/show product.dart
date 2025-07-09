// ignore_for_file: must_be_immutable, iterable_contains_unrelated_type

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/store/product.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'add comment.dart';

class ShowProduct extends StatefulWidget {
  ProductModel productModel;

  ShowProduct(this.productModel, {Key? key}) : super(key: key);

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  late StoreProvider storeProvider;
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.productModel.video);
    Provider.of<StoreProvider>(context, listen: false).getProductFavourite();
    Provider.of<StoreProvider>(context, listen: false)
        .getProductComments(widget.productModel.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: widget.productModel.video.contains('youtu') &&
              chatProvider.youtubePlayerController.value.isFullScreen
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF7f0e14),
              elevation: 0,
              title: appBarWidget(context),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    storeProvider
                        .addProductToFavourite(
                            widget.productModel.id.toString())
                        .then((value) {
                      storeProvider.getProductFavourite();
                    });
                  },
                  icon: Icon(
                    storeProvider.favourites.any((element) {
                      return element.product.id == widget.productModel.id;
                    })
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      WcFlutterShare.share(
                        sharePopupTitle: 'مشاركة',
                        mimeType: 'text/plain',
                        text:
                            'https://apps.apple.com/app/%D8%A7%D9%84%D8%A7%D8%AA%D8%AD%D8%A7%D8%AF-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A-ifmis/id1670802361',
                      );
                    } else {
                      WcFlutterShare.share(
                        sharePopupTitle: 'مشاركة',
                        mimeType: 'text/plain',
                        text:
                            'https://play.google.com/store/apps/details?id=dev.ifmis.news',
                      );
                    }
                  },
                  icon: Icon(
                    Icons.share,
                    color: white,
                  ),
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  navigatePop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: white,
                ),
              ),
            ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (widget.productModel.video.contains('youtu'))
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
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  SizedBox(
                    height: sizeFromHeight(context, 2.5),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            height: sizeFromHeight(context, 2.5),
                            width: sizeFromWidth(context, 1.05),
                            margin: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: lightGrey),
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    widget.productModel.media[index].fileName),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.productModel.media.length,
                      ),
                    ),
                  ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${widget.productModel.price} ${otherProvider.getTexts('sr')}',
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.2,
                          fontSize: sizeFromWidth(context, 20),
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: sizeFromWidth(context, 1.5),
                        child: Text(
                          language
                              ? widget.productModel.name.en
                              : widget.productModel.name.ar,
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          style: TextStyle(
                            height: 1.2,
                            fontSize: sizeFromWidth(context, 25),
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (widget.productModel.sizes.any((element) {
                  if (element.name == 'بدون حجم') {
                    return false;
                  }
                  return true;
                }))
                  if (!chatProvider
                          .youtubePlayerController.value.isFullScreen &&
                      widget.productModel.video.contains('youtu'))
                    SizedBox(height: sizeFromHeight(context, 40)),
                if (widget.productModel.sizes.any((element) {
                  if (element.name == 'بدون حجم') {
                    return false;
                  }
                  return true;
                }))
                  if (!chatProvider
                          .youtubePlayerController.value.isFullScreen &&
                      widget.productModel.video.contains('youtu'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  otherProvider.getTexts('size').toString(),
                                  textDirection: TextDirection.rtl,
                                  maxLines: 2,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: sizeFromWidth(context, 20),
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: sizeFromHeight(context, 15),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          margin: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: lightGrey),
                                          ),
                                          child: Text(
                                            widget
                                                .productModel.sizes[index].name,
                                            textDirection: TextDirection.rtl,
                                            maxLines: 2,
                                            style: TextStyle(
                                              height: 1.2,
                                              fontSize:
                                                  sizeFromWidth(context, 25),
                                              color: black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount:
                                          widget.productModel.sizes.length,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  SizedBox(height: sizeFromHeight(context, 40)),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                otherProvider.getTexts('color').toString(),
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: sizeFromWidth(context, 20),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: sizeFromHeight(context, 15),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        margin: const EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: lightGrey),
                                        ),
                                        child: Text(
                                          widget
                                              .productModel.colors[index].name,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          style: TextStyle(
                                            height: 1.2,
                                            fontSize:
                                                sizeFromWidth(context, 25),
                                            color: black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        widget.productModel.colors.length,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  SizedBox(height: sizeFromHeight(context, 40)),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                otherProvider
                                    .getTexts('product Description')
                                    .toString(),
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: sizeFromWidth(context, 20),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                language
                                    ? widget.productModel.description.en
                                    : widget.productModel.description.ar,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: sizeFromWidth(context, 25),
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  SizedBox(height: sizeFromHeight(context, 90)),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            otherProvider.getTexts('comment').toString(),
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              navigateTo(context,
                                  AddProductComment(widget.productModel));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  SizedBox(height: sizeFromHeight(context, 90)),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  for (int i = 0; i < storeProvider.productComment.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
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
                                  storeProvider.productComment[i].user.name,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  storeProvider.productComment[i].comment,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RatingBar(
                                      itemSize: sizeFromHeight(context, 40),
                                      ratingWidget: RatingWidget(
                                        full: _image('assets/heart.png'),
                                        half: _image('assets/heart_half.png'),
                                        empty:
                                            _image('assets/heart_border.png'),
                                      ),
                                      onRatingUpdate: (value) =>
                                          storeProvider.changeRating(value),
                                      initialRating:
                                          storeProvider.productComment[i].rate,
                                      allowHalfRating: true,
                                    ),
                                  ],
                                ),
                              ],
                              MainAxisAlignment.start,
                              false,
                              10,
                              lightGrey,
                              () {},
                              CrossAxisAlignment.end,
                            ),
                          ),
                          const SizedBox(width: 5),
                          storyShape(
                            context,
                            lightGrey,
                            storeProvider.productComment[i].user.image != ''
                                ? NetworkImage(
                                    storeProvider.productComment[i].user.image)
                                : null,
                            30,
                            33,
                          ),
                        ],
                      ),
                    ),
                if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                    widget.productModel.video.contains('youtu'))
                  SizedBox(height: sizeFromHeight(context, 90)),
              ],
            ),
          ),
          if (!chatProvider.youtubePlayerController.value.isFullScreen &&
              widget.productModel.video.contains('youtu'))
            bottomScaffoldWidget(context),
        ],
      ),
    );
  }

  Widget _image(String asset) => Image.asset(
        asset,
        height: sizeFromHeight(context, 30),
        width: sizeFromHeight(context, 30),
        color: amber,
      );
}
