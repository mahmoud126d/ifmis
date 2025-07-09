// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class Report extends StatefulWidget {
  String id;

  Report(this.id, {Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController reason = TextEditingController();
  late UserProvider userProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  late OtherProvider otherProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
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
        child: Column(
          children: [
            textFormField(
              controller: reason,
              type: TextInputType.text,
              validate: (value) {
                if (value!.isEmpty) {
                  if (language) {
                    return 'Report reason is required';
                  }
                  return 'يجب كتابة سبب البلاغ';
                }
                return null;
              },
              fromLTR: language,
              hint: otherProvider.getTexts('report text').toString(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: textButton(
                      context,
                      language ? 'Attach a photo with report' : 'إرفاق صورة مع البلاغ',
                      primaryColor,
                      white,
                      sizeFromWidth(context, 20),
                      FontWeight.bold,
                      () async {
                        userProvider.selectReportImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sizeFromHeight(context, 50)),
            if (!userProvider.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: textButton(
                        context,
                        language ? 'Send Report' : 'أرسل البلاغ',
                        primaryColor,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                        () async {
                          if (reason.text.isEmpty) {
                            showToast(
                                text: language ? 'Enter Report' : 'اكتب سبب البلاغ',
                                state: ToastStates.ERROR);
                          } else {
                            userProvider
                                .sendReport(widget.id, reason.text.trim())
                                .then((value) {
                              reason.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (userProvider.isLoading)
              circularProgressIndicator(lightGrey, primaryColor, context),
            const Spacer(),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
