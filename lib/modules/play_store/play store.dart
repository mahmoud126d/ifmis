// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/show%20store.dart';
import 'package:provider/provider.dart';
import '../../models/language/language.dart';
import '../../models/store/store.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';
import 'add store.dart';
import 'edit store.dart';
import 'favourites.dart';

class PlayStore extends StatefulWidget {
  String categoryID;
  String description;

  PlayStore(this.categoryID, this.description, {Key? key}) : super(key: key);

  @override
  State<PlayStore> createState() => _PlayStoreState();
}

class _PlayStoreState extends State<PlayStore> {
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false).getStores(
        widget.categoryID);
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
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context,  StoreCategory(
              id: 1,
              name: LanguageModel(en: 'Football', ar: 'كرة القدم'),
              image: 'https://example.com/img.jpg',
            ),);
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              navigateTo(
                  context, AddStore(widget.categoryID, widget.description));
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
                otherProvider.getTexts('create store').toString(),
                null,
                null,
                primaryColor,
                sizeFromWidth(context, 30),
                FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: language ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            Container(
              width: sizeFromWidth(context, 1),
              height: sizeFromHeight(context, 11, hasAppBar: true),
              color: primaryColor,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: textFormField(
                  controller: storeProvider.search,
                  type: TextInputType.text,
                  validate: (value) {
                    return null;
                  },
                  onChange: (value) {
                    if (storeProvider.search.text.isEmpty) {
                      storeProvider.getStores(widget.categoryID);
                    }
                    storeProvider.searchAboutStore();
                  },
                  hint: otherProvider.getTexts('search').toString(),
                  isExpanded: true,
                  textAlignVertical: TextAlignVertical.bottom,
                  fromLTR: language,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_rounded, color: white),
                  const SizedBox(width: 5),
                  textWidget(
                    otherProvider.getTexts('sports stores').toString(),
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 28),
                    FontWeight.bold,
                  ),
                ],
              ),
            ),
            if (storeProvider.stores.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: storeProvider.stores.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () async {
                        navigateAndFinish(
                            context, ShowStore(storeProvider.stores[index],
                            widget.categoryID, widget.description));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                              color: lightGrey,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (storeProvider.stores[index].hasStar == 'yes')
                              const Icon(Icons.star, color: Colors.amber),
                            if (storeProvider.stores[index].userId ==
                                id.toString())
                              IconButton(
                                  onPressed: () {
                                    navigateTo(context,
                                        EditStore(storeProvider.stores[index],
                                            widget.categoryID,
                                            widget.description));
                                  },
                                  icon: Icon(Icons.edit, color: primaryColor)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    language ? storeProvider.stores[index].name
                                        .en : storeProvider.stores[index].name
                                        .ar,
                                    textDirection: language
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: sizeFromWidth(context, 30),
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    storeProvider.stores[index].description ??
                                        '',
                                    textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                    style: TextStyle(
                                      height: 1.2,
                                      fontSize: sizeFromWidth(context, 40),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      storeProvider.stores[index].storeImage),
                                  fit: BoxFit.cover,
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
            if (storeProvider.stores.isEmpty)
              Expanded(
                child: Center(
                  child: textWidget(
                    language ? 'There are no shops' : 'لا يوجد متاجر',
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: primaryColor,
            onPressed: () {
              navigateAndFinish(
                  context, Favourites(widget.categoryID, widget.description));
            },
            label: textWidget(
              otherProvider.getTexts('fav').toString(),
              null,
              null,
              white,
              sizeFromWidth(context, 20),
              FontWeight.bold,
            ),
            icon: Icon(
              Icons.star_border_sharp,
              color: white,
            ),
          ),
          SizedBox(height: sizeFromHeight(context, 10)),
        ],
      ),
    );
  }
}
