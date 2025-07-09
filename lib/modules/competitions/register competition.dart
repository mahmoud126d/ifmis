// ignore_for_file: must_be_immutable
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/competition provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class RegisterCompetition extends StatefulWidget {
  int competitionID;

  RegisterCompetition(this.competitionID, {Key? key}) : super(key: key);

  @override
  State<RegisterCompetition> createState() => _RegisterCompetitionState();
}

class _RegisterCompetitionState extends State<RegisterCompetition> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController positionAR = TextEditingController();
  final TextEditingController positionEN = TextEditingController();
  final TextEditingController videoLink = TextEditingController();
  late CompetitionProvider competitionProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: sizeFromWidth(context, 1),
          height: sizeFromHeight(context, 1, hasAppBar: true),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                textFormField(
                  controller: positionAR,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return language ? 'The competitor Position must be entered from two words only in Arabic' : 'يجب إدخال هواية المتسابق من كلمتين فقط بالعربى';
                    }
                    return null;
                  },
                  fromLTR: language,
                  hint: otherProvider.getTexts('enter competitor center ar').toString(),
                ),
                textFormField(
                  controller: positionEN,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return language ? 'The competitor Position must be entered from two words only in english' : 'يجب إدخال هواية المتسابق من كلمتين فقط بالإنجليزى';
                    }
                    return null;
                  },
                  fromLTR: language,
                  hint: otherProvider.getTexts('enter competitor center en').toString(),
                ),
                textFormField(
                  controller: videoLink,
                  type: TextInputType.text,
                  validate: (value) {
                    return null;
                  },
                  fromLTR: language,
                  hint: otherProvider.getTexts('enter competitor video link').toString(),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          otherProvider.getTexts('enter competitor video').toString(),
                          primaryColor,
                          white,
                          language ? sizeFromWidth(context, 25) : sizeFromWidth(context, 20),
                          FontWeight.bold,
                              () {
                            competitionProvider.pickVideoCompetitor();
                              },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizeFromHeight(context, 90)),
                if (!competitionProvider.isLoading)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            otherProvider.getTexts('share competition').toString(),
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () async {
                              if (formKey.currentState!.validate()) {
                                competitionProvider.shareInCompetition(
                                  widget.competitionID.toString(),
                                  positionAR.text.trim(),
                                  positionEN.text.trim(),
                                  videoLink.text.trim(),
                                  context,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (competitionProvider.isLoading)
                  Center(
                    child: circularProgressIndicator(lightGrey, primaryColor, context),
                  ),
                const Spacer(),
                bottomScaffoldWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
