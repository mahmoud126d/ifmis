// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../models/statistics/articles.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class ShowArticle extends StatefulWidget {
  ArticlesModel articlesModel;
  ShowArticle(this.articlesModel, {Key? key}) : super(key: key);

  @override
  State<ShowArticle> createState() => _ShowArticleState();
}

class _ShowArticleState extends State<ShowArticle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  width: sizeFromWidth(context, 1),
                  height: sizeFromHeight(context, 3.5),
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                      NetworkImage(widget.articlesModel.poster),
                      fit: BoxFit.fill,
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
                  child: textWidget(
                    widget.articlesModel.title.trim(),
                    TextDirection.rtl,
                    null,
                    white,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: textWidget(
                    widget.articlesModel.content.trim(),
                    TextDirection.rtl,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
