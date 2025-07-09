import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/talent%20exploration/talent%20category.dart';
import 'package:ifmis/modules/talent%20exploration/talent%20details.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/talent provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'add talent.dart';

class SpecificTalent extends StatefulWidget {
  String id;

  SpecificTalent(this.id, {Key? key}) : super(key: key);

  @override
  State<SpecificTalent> createState() => _SpecificTalentState();
}

class _SpecificTalentState extends State<SpecificTalent> {
  late TalentProvider talentProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  TextEditingController confirmDelete = TextEditingController();

  showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = textButton(
      context,
      language ? 'Back' : 'رجوع',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
          () {
        navigatePop(context);
      },
    );
    Widget continueButton = textButton(
      context,
      language ? 'Delete' : 'حذف',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
          () {
        if (confirmDelete.text.trim() == CacheHelper.getData(key: 'password')) {
          talentProvider
              .deleteTalent(talentProvider
              .specificTalents[index].id
              .toString())
              .then((value) {
            talentProvider.specificTalents.remove(
                talentProvider
                    .specificTalents[index]);
          });
          confirmDelete.clear();
          navigatePop(context);
        } else {
          showToast(
              text: language ? 'Wrong Password' : 'خطأ فى كلمة سر',
              state: ToastStates.ERROR);
          confirmDelete.clear();
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        language
            ? 'Are you sure you want to delete your Post ?'
            : 'هل أنت متأكد من حذف مشاركتك ؟',
        null,
        TextAlign.end,
        black,
        sizeFromWidth(context, 25),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textFormField(
            controller: confirmDelete,
            type: TextInputType.text,
            validate: (value) {
              return null;
            },
            fromLTR: language,
            isExpanded: true,
            hint: language ? 'Enter your password' : 'أدخل كلمة السر الخاصة بك',
          ),
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    Provider.of<TalentProvider>(context, listen: false)
        .getSpecificTalentCategories(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    talentProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    var id = CacheHelper.getData(key: 'id');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const TalentCategory());
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              navigateTo(context, AddTalent(widget.id));
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
                otherProvider.getTexts('add contribution').toString(),
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
        textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Container(
              width: sizeFromWidth(context, 1),
              height: sizeFromHeight(context, 11, hasAppBar: true),
              color: primaryColor,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: textFormField(
                  controller: talentProvider.search,
                  type: TextInputType.text,
                  validate: (value) {
                    return null;
                  },
                  onChange: (value) {
                    if (talentProvider.search.text == '') {
                      talentProvider.getSpecificTalentCategories(widget.id);
                    }
                    talentProvider.searchAboutTalents();
                  },
                  hint: otherProvider.getTexts('search').toString(),
                  isExpanded: true,
                  fromLTR: language,
                  textAlignVertical: TextAlignVertical.bottom,
                ),
              ),
            ),
            ConditionalBuilder(
              condition: !talentProvider.isLoading,
              builder: (context) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: talentProvider.specificTalents.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          navigateTo(
                              context,
                              TalentDetails(
                                  talentProvider.specificTalents[index]));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (id.toString() ==
                                      talentProvider
                                          .specificTalents[index].userID)
                                IconButton(
                                    onPressed: () {
                                      showAlertDialog(context, index);
                                    },
                                    icon: Icon(Icons.delete, color: white)),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: white,
                                ),
                                child: textWidget(
                                  talentProvider.specificTalents[index].points
                                      .toString(),
                                  TextDirection.rtl,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        textWidget(
                                          language
                                              ? talentProvider
                                                  .specificTalents[index]
                                                  .playerName
                                                  .en
                                              : talentProvider
                                                  .specificTalents[index]
                                                  .playerName
                                                  .ar,
                                          TextDirection.rtl,
                                          null,
                                          white,
                                          sizeFromWidth(context, 30),
                                          FontWeight.bold,
                                        ),
                                      ],
                                    )),
                              ),
                              Container(
                                width: sizeFromWidth(context, 6.5),
                                height: sizeFromWidth(context, 6.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      talentProvider.specificTalents[index]
                                          .images[0].image,
                                    ),
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
                );
              },
              fallback: (context) {
                return Expanded(
                  child: Center(
                    child: textWidget(
                      language ? 'There are no Talents' : 'لا يوجد مواهب',
                      null,
                      null,
                      primaryColor,
                      sizeFromWidth(context, 20),
                      FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
