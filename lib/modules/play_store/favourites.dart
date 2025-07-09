// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/play%20store.dart';
import 'package:ifmis/modules/play_store/show%20product.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class Favourites extends StatefulWidget {
  String categoryID;
  String description;
  Favourites(this.categoryID, this.description, {Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late StoreProvider storeProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false).getProductFavourite();
    super.initState();
  }

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
            navigateAndFinish(context, PlayStore(widget.categoryID, widget.description));
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          if (storeProvider.favourites.isNotEmpty)
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: storeProvider.favourites.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    navigateTo(context,
                        ShowProduct(storeProvider.favourites[index].product));
                  },
                  child: Container(
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
                                  .deleteProductFromFavourite(storeProvider
                                      .favourites[index].product.id
                                      .toString())
                                  .then((value) {
                                setState(() {
                                  storeProvider.favourites.remove(storeProvider
                                      .favourites[index]);
                                });
                              });
                            },
                            icon: Icon(Icons.delete, color: white)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textWidget(
                                language ? storeProvider.favourites[index].product.name.en : storeProvider.favourites[index].product.name.ar,
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 25),
                                FontWeight.bold,
                              ),
                              textWidget(
                                language ? storeProvider
                                    .favourites[index].product.description.en : storeProvider
                                    .favourites[index].product.description.ar,
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                              textWidget(
                                "${storeProvider.favourites[index].product.price} ر.س",
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: sizeFromHeight(context, 8),
                          height: sizeFromHeight(context, 8),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(storeProvider
                                  .favourites[index].product.media[0].fileName),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (storeProvider.favourites.isEmpty)
            Expanded(
              child: Center(
                child: textWidget(
                  'لا يوجد منتجات مفضلة',
                  null,
                  null,
                  primaryColor,
                  sizeFromWidth(context, 20),
                  FontWeight.bold,
                ),
              ),
            ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
