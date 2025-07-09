// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/sport services provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class AddNewsSport extends StatefulWidget {
  String id;

  AddNewsSport(this.id, {Key? key}) : super(key: key);

  @override
  State<AddNewsSport> createState() => _AddNewsSportState();
}

class _AddNewsSportState extends State<AddNewsSport> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController link = TextEditingController();
  final TextEditingController publisherName = TextEditingController();
  final TextEditingController publisherCountry = TextEditingController();
  late SportServicesProvider sportServicesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  Widget build(BuildContext context) {
    sportServicesProvider = Provider.of(context);
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
                    textFormField(
                      controller: link,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('enter competitor video link').toString(),
                    ),
                    textFormField(
                      controller: publisherName,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language ? 'You must enter the player\'s agent' : 'يجب إدخال اسم وكيل اللاعب';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('player agent').toString(),
                    ),
                    textFormField(
                      controller: publisherCountry,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('player country name').toString(),
                    ),
                    if (!sportServicesProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                otherProvider.getTexts('player image').toString(),
                                primaryColor,
                                white,
                                language ? sizeFromWidth(context, 22) : sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () {
                                  sportServicesProvider.pickImagesNews();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!sportServicesProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                otherProvider.getTexts('post request').toString(),
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () async {
                                  if (formKey.currentState!.validate()) {
                                    sportServicesProvider
                                        .addNews(
                                      link.text.trim(),
                                      widget.id,
                                      publisherName.text.trim(),
                                      publisherCountry.text.trim(),
                                    ).then((value) {
                                      navigatePop(context);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (sportServicesProvider.isLoading)
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
