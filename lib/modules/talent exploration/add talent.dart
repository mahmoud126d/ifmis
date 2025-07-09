import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/talent provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class AddTalent extends StatefulWidget {
  String categoryID;

  AddTalent(this.categoryID, {Key? key}) : super(key: key);

  @override
  State<AddTalent> createState() => _AddTalentState();
}

class _AddTalentState extends State<AddTalent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameEN = TextEditingController();
  final TextEditingController nameAR = TextEditingController();
  final TextEditingController school = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController classRoom = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController video = TextEditingController();
  late TalentProvider talentProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  Widget build(BuildContext context) {
    talentProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: SizedBox(
        width: sizeFromWidth(context, 1),
        height: sizeFromHeight(context, 1, hasAppBar: true),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        language ? settingModel.talentText.en : settingModel.talentText.ar,
                        language ? TextDirection.ltr : TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 30),
                        FontWeight.bold,
                      ),
                    ),
                    textFormField(
                      controller: nameEN,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter name in english'
                              : 'يجب إدخال الاسم بالإنجليزى';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('add talent name en')
                          .toString(),
                    ),
                    textFormField(
                      controller: nameAR,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter name in arabic'
                              : 'يجب إدخال الاسم بالعربى';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('add talent name ar')
                          .toString(),
                    ),
                    textFormField(
                      controller: school,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter school name'
                              : 'يجب إدخال اسم المدرسة';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('add talent school')
                          .toString(),
                    ),
                    textFormField(
                      controller: position,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter job or position'
                              : 'يجب إدخال مركز أو وظيفة الموهبه';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('add talent position')
                          .toString(),
                    ),
                    textFormField(
                      controller: height,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter height'
                              : 'يجب إدخال طول الموهبه';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('add talent height')
                          .toString(),
                    ),
                    textFormField(
                      controller: age,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter age'
                              : 'يجب إدخال عمر الموهبه';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('add talent age').toString(),
                    ),
                    textFormField(
                      controller: classRoom,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter class room'
                              : 'يجب إدخال الصف الدراسى للموهبه';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint:
                          otherProvider.getTexts('add talent class').toString(),
                    ),
                    textFormField(
                      controller: video,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter video link'
                              : 'يجب إدخال رابط فيديو يوتيوب';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint:
                          otherProvider.getTexts('add talent video').toString(),
                    ),
                    if (!talentProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                otherProvider
                                    .getTexts('add talent images')
                                    .toString(),
                                primaryColor,
                                white,
                                language
                                    ? sizeFromWidth(context, 22)
                                    : sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () {
                                  talentProvider.pickImagesNews();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!talentProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                otherProvider.getTexts('add talent').toString(),
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () async {
                                  if (formKey.currentState!.validate()) {
                                    talentProvider.addTalent(
                                      nameEN.text.trim(),
                                      nameAR.text.trim(),
                                      school.text.trim(),
                                      position.text.trim(),
                                      height.text.trim(),
                                      classRoom.text.trim(),
                                      age.text.trim(),
                                      widget.categoryID,
                                      video.text.trim(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (talentProvider.isLoading)
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
      ),
    );
  }
}
