// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/show%20store.dart';
import 'package:provider/provider.dart';

import '../../models/store/store.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class DeleteProduct extends StatefulWidget {
  StoreModel storeModel;
  String categoryID;
  String description;

  DeleteProduct(this.storeModel, this.categoryID, this.description, {Key? key}) : super(key: key);

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  late StoreProvider storeProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  late OtherProvider otherProvider;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false)
        .getStoreCategories(widget.storeModel.id.toString(), false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    otherProvider = Provider.of(context);
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
              itemCount: storeProvider.products.length,
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
                                .deleteProduct(widget.storeModel.id.toString(),
                                    storeProvider.products[index].id.toString())
                                .then((value) {
                                  setState(() {
                                    storeProvider.products.remove(storeProvider.products[index]);
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
                              language ? storeProvider.products[index].name.en : storeProvider.products[index].name.ar,
                              TextDirection.rtl,
                              null,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                            textWidget(
                              language ? storeProvider.products[index].description.en : storeProvider.products[index].description.ar,
                              TextDirection.rtl,
                              null,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                            textWidget(
                              "${storeProvider.products[index].price} ${otherProvider.getTexts('sr')}",
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
                                .products[index].media[0].fileName),
                            fit: BoxFit.contain,
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
