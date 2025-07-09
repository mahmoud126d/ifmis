// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/show%20store.dart';
import 'package:provider/provider.dart';

import '../../models/store/store.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class AddCategory extends StatefulWidget {
  StoreModel storeModel;
  String categoryID;
  String description;

  AddCategory(this.storeModel, this.categoryID, this.description, {Key? key})
      : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController nameAR = TextEditingController();
  final TextEditingController nameEN = TextEditingController();
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

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
            navigateAndFinish(
                context,
                ShowStore(
                    widget.storeModel, widget.categoryID, widget.description));
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          textFormField(
            controller: nameAR,
            type: TextInputType.text,
            validate: (value) {
              if (value!.isEmpty) {
                return 'يجب إدخال اسم التصنيف بالعربى';
              }
              return null;
            },
            fromLTR: language,
            hint: otherProvider.getTexts('add cat ar').toString(),
          ),
          textFormField(
            controller: nameEN,
            type: TextInputType.text,
            validate: (value) {
              if (value!.isEmpty) {
                return 'يجب إدخال اسم التصنيف بالإنجليزى';
              }
              return null;
            },
            fromLTR: language,
            hint: otherProvider.getTexts('add cat en').toString(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: textButton(
                    context,
                    otherProvider.getTexts('add cat').toString(),
                    primaryColor,
                    white,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    () {
                      if (nameAR.text.isEmpty || nameEN.text.isEmpty) {
                        showToast(
                            text: language ? 'Enter Category' : 'أدخل التصنيف', state: ToastStates.ERROR);
                      } else {
                        storeProvider
                            .addCategoriesInStore(
                          nameAR.text.trim(),
                          nameEN.text.trim(),
                          widget.storeModel.id.toString(),
                        )
                            .then((value) {
                          storeProvider.getStoreCategories(
                              widget.storeModel.id.toString(), false);
                        });
                        nameAR.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: storeProvider.categories.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: sizeFromWidth(context, 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            storeProvider
                                .deleteCategory(storeProvider
                                    .categories[index].id
                                    .toString())
                                .then((value) {
                              storeProvider.getStoreCategories(
                                  widget.storeModel.id.toString(), false);
                            });
                          },
                          icon: Icon(Icons.delete, color: white)),
                      Expanded(child: textWidget(
                        language
                            ? storeProvider.categories[index].name.en
                            : storeProvider.categories[index].name.ar,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),),
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
