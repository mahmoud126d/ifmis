// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/play%20store.dart';
import 'package:ifmis/modules/play_store/show%20product.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/store/store.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'add category.dart';
import 'add product.dart';
import 'delete Banner.dart';
import 'delete product.dart';

class ShowStore extends StatefulWidget {
  StoreModel storeModel;
  String categoryID;
  String description;

  ShowStore(this.storeModel, this.categoryID, this.description, {Key? key})
      : super(key: key);

  @override
  State<ShowStore> createState() => _ShowStoreState();
}

class _ShowStoreState extends State<ShowStore> {
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;


  sheet() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: language ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: sizeFromWidth(context, 1),
                    padding: EdgeInsets.only(top: sizeFromHeight(context, 20)),
                    color: white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  navigatePop(context);
                                },
                                icon: Icon(Icons.keyboard_return_rounded,
                                    color: primaryColor)),
                            Expanded(
                              child: Text(
                                language ? widget.storeModel.name.en : widget.storeModel.name.ar,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 20),
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            Container(
                              width: sizeFromWidth(context, 5),
                              height:
                              sizeFromHeight(context, 10, hasAppBar: true),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                  NetworkImage(widget.storeModel.storeImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 5),
                        divider(1, 1, lightGrey),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Text(
                                otherProvider.getTexts('work hours store').toString(),
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                language ? '     ${otherProvider.getTexts('from').toString()} ${widget.storeModel.startWorkHours}' : '${otherProvider.getTexts('from').toString()} ${widget.storeModel.startWorkHours}',
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                '${otherProvider.getTexts('to').toString()} ${widget.storeModel.endWorkHours}',
                                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  var url = Uri.parse(
                                      'whatsapp://send?phone=${widget.storeModel.phoneStore}');
                                  await launchUrl(url);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: textWidget(
                                    otherProvider.getTexts('click here to connect').toString(),
                                    null,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: textWidget(
                                  '${otherProvider.getTexts('store contact number').toString()} ${widget.storeModel.phoneStore}',
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 28),
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: textWidget(
                                  '${otherProvider.getTexts('store address').toString()} ${language ? widget.storeModel.storeAddress.en : widget.storeModel.storeAddress.ar}',
                                  language ? TextDirection.ltr : TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 28),
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.storeModel.latLangLink != '')
                          InkWell(
                            onTap: () async {
                              var url = Uri.parse(widget.storeModel.latLangLink);
                              try {
                                await launchUrl(url);
                              } catch (e) {
                                showToast(
                                    text: 'يوجد خطأ بالرابط',
                                    state: ToastStates.ERROR);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: textWidget(
                                      otherProvider.getTexts('click to get the store address via coordinates').toString(),
                                      TextDirection.rtl,
                                      null,
                                      white,
                                      sizeFromWidth(context, 28),
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: sizeFromHeight(context, 90)),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false)
        .getStoreCategories(widget.storeModel.id.toString(), true);
    Provider.of<StoreProvider>(context, listen: false)
        .getProducts(widget.storeModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    var id = CacheHelper.getData(key: 'id');
    return Scaffold(
      backgroundColor: lightGrey1,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              sheet();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: textWidget(
                otherProvider.getTexts('contact the store').toString(),
                null,
                null,
                primaryColor,
                sizeFromWidth(context, 30),
                FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            storeProvider.selectedCategoryID = 0;
            navigateAndFinish(
                context, PlayStore(widget.categoryID, widget.description));
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
                if (id.toString() == widget.storeModel.userId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateAndFinish(
                                context,
                                AddCategory(widget.storeModel,
                                    widget.categoryID, widget.description));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: textWidget(
                              otherProvider.getTexts('add cats').toString(),
                              null,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (storeProvider.categories.length == 1) {
                              showToast(
                                  text: language ? 'You must add a category before adding a product' : 'يجب إضافة تصنيف قبل إضافة منتج',
                                  state: ToastStates.ERROR);
                            } else {
                              navigateAndFinish(
                                  context,
                                  AddProduct(
                                      widget.storeModel,
                                      storeProvider.products.length,
                                      widget.categoryID,
                                      widget.description));
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: textWidget(
                              otherProvider.getTexts('add product').toString(),
                              null,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (id.toString() == widget.storeModel.userId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateAndFinish(
                                context,
                                DeleteProduct(widget.storeModel,
                                    widget.categoryID, widget.description));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: textWidget(
                              otherProvider.getTexts('delete product').toString(),
                              null,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateAndFinish(
                                context,
                                DeleteBanner(widget.storeModel,
                                    widget.categoryID, widget.description));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: textWidget(
                              otherProvider.getTexts('delete an ad image').toString(),
                              null,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (id.toString() != widget.storeModel.userId)
                  SizedBox(height: sizeFromHeight(context, 70)),
                if (widget.storeModel.banners.isNotEmpty)
                  SizedBox(
                    height: sizeFromHeight(context, 5),
                    width: sizeFromWidth(context, 1),
                    child: Card(
                      elevation: 5,
                      color: white,
                      child: Marquee(
                        direction: Axis.horizontal,
                        textDirection: TextDirection.rtl,
                        animationDuration: const Duration(seconds: 1),
                        backDuration: const Duration(milliseconds: 1000),
                        pauseDuration: const Duration(milliseconds: 1000),
                        directionMarguee: DirectionMarguee.TwoDirection,
                        child: Row(
                          children: widget.storeModel.banners.map((data) {
                            return Container(
                              margin: const EdgeInsets.all(5),
                              width: sizeFromWidth(context, 3.3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(data.fileName),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                            storeProvider.categories.length,
                            (index) => InkWell(
                                  onTap: () {
                                    if (storeProvider.categories[index].name.ar ==
                                        'الكل') {
                                      setState(() {
                                        storeProvider.selectedCategoryID = 0;
                                      });
                                    } else {
                                      storeProvider.getProductsByCategoryID(
                                          storeProvider.categories[index].id);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: storeProvider.selectedCategoryID ==
                                              storeProvider.categories[index].id
                                          ? primaryColor
                                          : lightGrey1,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      language ? storeProvider.categories[index].name.en: storeProvider.categories[index].name.ar,
                                      textDirection: TextDirection.rtl,
                                      maxLines: 2,
                                      style: TextStyle(
                                        height: 1.2,
                                        fontSize: sizeFromWidth(context, 27),
                                        color:
                                            storeProvider.selectedCategoryID ==
                                                    storeProvider
                                                        .categories[index].id
                                                ? white
                                                : primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ))),
                  ),
                ),
                const SizedBox(height: 10),
                // SizedBox(
                //   height: sizeFromHeight(context, 20),
                //   child: Directionality(
                //     textDirection: TextDirection.rtl,
                //     child: ListView.builder(
                //       physics: const BouncingScrollPhysics(),
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (context, index) {
                //         return InkWell(
                //           onTap: () {
                //             if (storeProvider.categories[index].name == 'الكل') {
                //               setState(() {
                //                 storeProvider.selectedCategoryID = 0;
                //               });
                //             } else {
                //               storeProvider.getProductsByCategoryID(
                //                   storeProvider.categories[index].id);
                //             }
                //           },
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 5, horizontal: 15),
                //             margin: const EdgeInsets.all(5),
                //             decoration: BoxDecoration(
                //               color: storeProvider.selectedCategoryID ==
                //                       storeProvider.categories[index].id
                //                   ? primaryColor
                //                   : lightGrey1,
                //               border: Border.all(color: Colors.grey),
                //               borderRadius: BorderRadius.circular(20),
                //             ),
                //             child: Text(
                //               storeProvider.categories[index].name,
                //               textDirection: TextDirection.rtl,
                //               maxLines: 2,
                //               style: TextStyle(
                //                 height: 1.2,
                //                 fontSize: sizeFromWidth(context, 27),
                //                 color: storeProvider.selectedCategoryID ==
                //                         storeProvider.categories[index].id
                //                     ? white
                //                     : primaryColor,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             ),
                //           ),
                //         );

                //       },
                //       itemCount: storeProvider.categories.length,
                //     ),
                //   ),
                // ),
                //SizedBox(height: sizeFromHeight(context, 40)),
                if (storeProvider.selectedCategoryID == 0)
                  Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  clipBehavior: Clip.none,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            ShowProduct(
                                                storeProvider.products[index]));
                                      },
                                      child: Container(
                                        height: sizeFromHeight(context, 3.5,
                                            hasAppBar: true),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(storeProvider
                                                .products[index]
                                                .media[0]
                                                .fileName),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (storeProvider
                                            .products[index].discount !=
                                        '' && storeProvider
                                        .products[index].discount !=
                                        '0')
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                        child: textWidget(
                                          '${otherProvider.getTexts('discount').toString()} ${storeProvider.products[index].discount} %',
                                          TextDirection.rtl,
                                          null,
                                          white,
                                          sizeFromWidth(context, 30),
                                          FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  margin: const EdgeInsets.only(right: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${storeProvider.products[index].price} ${ otherProvider.getTexts('sr').toString()}',
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: sizeFromWidth(context, 30),
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          language ? storeProvider.products[index].name.en : storeProvider.products[index].name.ar,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          style: TextStyle(
                                            height: 1.2,
                                            fontSize:
                                                sizeFromWidth(context, 30),
                                            color: black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: storeProvider.products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1 / 1.4,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: sizeFromHeight(context, 50, hasAppBar: true))
                    ],
                  ),
                if (storeProvider.selectedCategoryID != 0)
                  Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                navigateTo(
                                    context,
                                    ShowProduct(storeProvider
                                        .categoriesProducts[index]));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomLeft,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: sizeFromHeight(context, 3.5,
                                            hasAppBar: true),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(storeProvider
                                                .categoriesProducts[index]
                                                .media[0]
                                                .fileName),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      if (storeProvider
                                          .products[index].discount !=
                                          '' && storeProvider
                                          .products[index].discount !=
                                          '0')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(10)),
                                          ),
                                          child: textWidget(
                                            '${otherProvider.getTexts('discount').toString()} ${storeProvider.products[index].discount} %',
                                            TextDirection.rtl,
                                            null,
                                            white,
                                            sizeFromWidth(context, 30),
                                            FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${storeProvider.categoriesProducts[index].price} ${ otherProvider.getTexts('sr').toString()}',
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          style: TextStyle(
                                            height: 1.2,
                                            fontSize:
                                                sizeFromWidth(context, 30),
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            language ? storeProvider.products[index].name.en : storeProvider.products[index].name.ar,
                                            textDirection: TextDirection.rtl,
                                            maxLines: 2,
                                            style: TextStyle(
                                              height: 1.2,
                                              fontSize:
                                                  sizeFromWidth(context, 30),
                                              color: black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: storeProvider.categoriesProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1 / 1.4,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: sizeFromHeight(context, 50, hasAppBar: true))
                    ],
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
