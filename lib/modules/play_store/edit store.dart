// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/play_store/play%20store.dart';
import 'package:provider/provider.dart';

import '../../models/store/store.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class EditStore extends StatefulWidget {
  StoreModel storeModel;
  String categoryID;
  String description;

  EditStore(this.storeModel, this.categoryID, this.description, {Key? key}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameAR = TextEditingController();
  final TextEditingController nameEN = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController addressAR = TextEditingController();
  final TextEditingController addressEN = TextEditingController();
  final TextEditingController ownerPhone = TextEditingController();
  final TextEditingController storePhone = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  TimeOfDay time = TimeOfDay(
      hour: DateTime.now().hour.toInt(), minute: DateTime.now().minute.toInt());
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    nameAR.text = widget.storeModel.name.ar;
    nameEN.text = widget.storeModel.name.en;
    link.text = widget.storeModel.latLangLink;
    addressAR.text = widget.storeModel.storeAddress.ar;
    addressEN.text = widget.storeModel.storeAddress.en;
    ownerPhone.text = widget.storeModel.phoneStoreOwner;
    storePhone.text = widget.storeModel.phoneStore;
    startDate.text = widget.storeModel.startWorkHours;
    endDate.text = widget.storeModel.endWorkHours;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
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
                    controller: nameAR,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store name must entered';
                        }
                        return 'يجب إدخال اسم المتجر';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('store name ar').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    controller: nameEN,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store name must entered with english';
                        }
                        return 'يجب إدخال اسم المتجر بالإنجليزى';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('store name en').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    type: TextInputType.text,
                    controller: addressAR,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store location must entered with arabic';
                        }
                        return 'يجب إدخال العنوان بالعربى: الدولة المدينة الحي';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('store location ar').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    type: TextInputType.text,
                    controller: addressEN,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store location must entered with english';
                        }
                        return 'يجب إدخال العنوان بالإنجليزى: الدولة المدينة الحي';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('store location en').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    type: TextInputType.text,
                    controller: link,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store Position link must entered';
                        }
                        return 'يجب إدخال رابط احداثيات المتجر';
                      }
                      return null;
                    },
                    hint: otherProvider
                        .getTexts('store position link')
                        .toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    type: TextInputType.number,
                    controller: ownerPhone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store seller number must entered';
                        }
                        return 'يجب إدخال رقم جوال صاحب المتجر';
                      }
                      return null;
                    },
                    hint: otherProvider
                        .getTexts('store seller number')
                        .toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    type: TextInputType.number,
                    controller: storePhone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        if (language) {
                          return 'Store number must entered';
                        }
                        return 'يجب إدخال رقم جوال المتجر';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('store number').toString(),
                    fromLTR: language,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: textFormField(
                            type: TextInputType.text,
                            controller: endDate,
                            validate: (value) {
                              if (value!.isEmpty) {
                                if (language) {
                                  return 'Store closing time must entered';
                                }
                                return 'يجب إدخال وقت غلق المتجر';
                              }
                              return null;
                            },
                            hint: otherProvider.getTexts('store close').toString(),
                            isExpanded: true,
                            onTap: () {
                              endDate.clear();
                              showTimePicker(
                                context: context,
                                initialTime: time,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                          primary: primaryColor),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                if (value == null) {
                                  FocusScope.of(context).unfocus();
                                  return;
                                } else {
                                  endDate.text =
                                      value.format(context).toString().trim();
                                }
                              });
                            }),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: textFormField(
                            type: TextInputType.text,
                            controller: startDate,
                            validate: (value) {
                              if (value!.isEmpty) {
                                if (language) {
                                  return 'Store opening time must entered';
                                }
                                return 'يجب إدخال وقت فتح المتجر';
                              }
                              return null;
                            },
                            hint: otherProvider.getTexts('store open').toString(),
                            isExpanded: true,
                            onTap: () {
                              startDate.clear();
                              showTimePicker(
                                context: context,
                                initialTime: time,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                          primary: primaryColor),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                if (value == null) {
                                  FocusScope.of(context).unfocus();
                                  return;
                                } else {
                                  startDate.text =
                                      value.format(context).toString().trim();
                                }
                              });
                            }),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            otherProvider.getTexts('store image').toString(),
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              storeProvider.pickStoreImage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 90)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            otherProvider.getTexts('store banners').toString(),
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              storeProvider.pickStoreBannersImages();
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
                              language ? 'Save Store' : 'حفظ تعديلات المتجر',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                storeProvider.updateStoreData(
                                  nameAR.text.trim(),
                                  nameEN.text.trim(),
                                  widget.storeModel.id.toString(),
                                  description.text.trim(),
                                  addressAR.text.trim(),
                                  addressEN.text.trim(),
                                  link.text.trim(),
                                  ownerPhone.text.trim(),
                                  storePhone.text.trim(),
                                  startDate.text.trim(),
                                  endDate.text.trim(),
                                  widget.categoryID,
                                  widget.storeModel.banners.length,
                                  context,
                                );
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
