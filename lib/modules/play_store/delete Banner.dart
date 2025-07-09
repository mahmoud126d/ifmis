// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/show%20store.dart';
import 'package:provider/provider.dart';

import '../../models/store/store.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class DeleteBanner extends StatefulWidget {
  StoreModel storeModel;
  String categoryID;
  String description;

  DeleteBanner(this.storeModel, this.categoryID, this.description, {Key? key}) : super(key: key);

  @override
  State<DeleteBanner> createState() => _DeleteBannerState();
}

class _DeleteBannerState extends State<DeleteBanner> {
  late StoreProvider storeProvider;

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: lightGrey1,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, ShowStore(widget.storeModel, widget.categoryID, widget.description));
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
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.storeModel.banners.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: sizeFromWidth(context, 1),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            storeProvider
                                .deleteBanners(
                                    widget.storeModel.id.toString(),
                                    widget.storeModel.banners[index].id
                                        .toString())
                                .then((value) {
                              setState(() {
                                widget.storeModel.banners
                                    .remove(widget.storeModel.banners[index]);
                              });
                            });
                          },
                          icon: Icon(Icons.delete, color: white)),
                      Expanded(
                        child: Container(
                          height: sizeFromHeight(context, 5),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  widget.storeModel.banners[index].fileName),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
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
