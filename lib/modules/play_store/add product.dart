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

class AddProduct extends StatefulWidget {
  StoreModel storeModel;
  int numberOfCategories;
  String categoryID;
  String description;

  AddProduct(this.storeModel, this.numberOfCategories, this.categoryID,
      this.description,
      {Key? key})
      : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController discount = TextEditingController();
  final TextEditingController video = TextEditingController();
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  List sizesAR = [
    'بدون حجم',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
  ];
  List sizesEN = [
    'without size',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
  ];

  List colorsAR = [
    'أبيض',
    'أسود',
    'أحمر',
    'أخضر',
    'أزرق',
    'أصفر',
    'بنفسجى',
    'وردى',
    'برتقالى',
    'كحلى',
    'رمادى',
    'بيج',
    'بنّي',
    'كستنائي',
    'ذهبي',
    'فضى',
  ];
  List colorsEN = [
    'white',
    'black',
    'red',
    'green',
    'blue',
    'yellow',
    'purple',
    'rosy',
    'orange',
    'navy blue',
    'ashen',
    'beige',
    'brown',
    'maroon',
    'golden',
    'silver',
  ];

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
            storeProvider.productColors = [];
            storeProvider.productSize = [];
            storeProvider.productImage = [];
            storeProvider.selectedCategoryID = 0;
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
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: sizeFromHeight(context, 90)),
                  textFormField(
                    controller: name,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return language ? 'Product name is required' : 'يجب إدخال اسم المنتج';
                      }
                      return null;
                    },
                    fromLTR: language,
                    hint:
                        otherProvider.getTexts('enter product name').toString(),
                  ),
                  textFormField(
                    controller: description,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return language ? 'Product description is required' : 'يجب إدخال وصف المنتج';
                      }
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider
                        .getTexts('enter product description')
                        .toString(),
                  ),
                  textFormField(
                    controller: price,
                    type: TextInputType.number,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return language ? 'Product price is required' : 'يجب إدخال سعر المنتج';
                      }
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider
                        .getTexts('enter product price')
                        .toString(),
                  ),
                  textFormField(
                    controller: video,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider
                        .getTexts('enter product video')
                        .toString(),
                  ),
                  textFormField(
                    controller: discount,
                    type: TextInputType.number,
                    validate: (value) {
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider
                        .getTexts('enter product discount')
                        .toString(),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                      textDirection:
                          language ? TextDirection.ltr : TextDirection.rtl,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: Text(
                          storeProvider.productSize.isEmpty
                              ? otherProvider
                                  .getTexts('enter product size')
                                  .toString()
                              : storeProvider.productSize.toString(),
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (val) {
                          storeProvider.editProductSize(val.toString());
                        },
                        items: language ? sizesEN.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: storeProvider.productSize.contains(e)
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: storeProvider.productSize
                                                .contains(e)
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList() : sizesAR.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: storeProvider.productSize.contains(e)
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: storeProvider.productSize
                                            .contains(e)
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                      textDirection:
                          language ? TextDirection.ltr : TextDirection.rtl,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: Text(
                          storeProvider.productColors.isEmpty
                              ? otherProvider
                                  .getTexts('enter product color')
                                  .toString()
                              : storeProvider.productColors.toString(),
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (val) {
                          storeProvider.editProductColors(val.toString());
                        },
                        items: language ?
                        colorsEN.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: storeProvider.productColors.contains(e)
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: storeProvider.productColors
                                                .contains(e)
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList() : colorsAR.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: storeProvider.productColors.contains(e)
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: storeProvider.productColors
                                            .contains(e)
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                      textDirection:
                          language ? TextDirection.ltr : TextDirection.rtl,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: Text(
                          storeProvider.selectedCategoryID == 0
                              ? otherProvider
                                  .getTexts('enter product category')
                                  .toString()
                              : storeProvider.getCategoryID(),
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (value) {
                          storeProvider.setCategoryID(value.toString());
                        },
                        items: storeProvider.categories.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e.name,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: e.id == storeProvider.selectedCategoryID
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    language ? e.name.en : e.name.ar,
                                    style: TextStyle(
                                        color: e.id ==
                                                storeProvider.selectedCategoryID
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            otherProvider
                                .getTexts('enter product image')
                                .toString(),
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              storeProvider.pickProductImages();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 90)),
                  if (!storeProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: textButton(
                              context,
                              otherProvider
                                  .getTexts('create product')
                                  .toString(),
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                if (widget.numberOfCategories == 40) {
                                  showToast(
                                      text: language
                                          ? 'More than 40 products cannot be added'
                                          : 'لا يمكن إضافة أكثر من 40 منتج',
                                      state: ToastStates.ERROR);
                                } else if (formKey.currentState!.validate()) {
                                  storeProvider
                                      .createProduct(
                                    widget.storeModel.id.toString(),
                                    name.text.trim(),
                                    description.text.trim(),
                                    price.text.trim(),
                                    discount.text.trim(),
                                    video.text.trim(),
                                    context,
                                  )
                                      .then((value) {
                                    storeProvider.productColors = [];
                                    storeProvider.productSize = [];
                                    storeProvider.productImage = [];
                                    storeProvider.selectedCategoryID = 0;
                                    navigateAndFinish(
                                        context,
                                        ShowStore(
                                            widget.storeModel,
                                            widget.categoryID,
                                            widget.description));
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (storeProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(
                          lightGrey, primaryColor, context),
                    ),
                  SizedBox(height: sizeFromHeight(context, 90)),
                ],
              ),
            ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
