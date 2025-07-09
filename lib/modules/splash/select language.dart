import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../Authentication/log in.dart';
import '../policies/policies.dart';

class SelectLanguage extends StatefulWidget {

  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  bool language = CacheHelper.getData(key: 'language') ?? false;
  late OtherProvider otherProvider;
  int selectedNumber = 0;
  bool showPolicies = CacheHelper.getData(key: 'selectPolicies') ?? false;

  @override
  Widget build(BuildContext context) {
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: sizeFromHeight(context, 15, hasAppBar: true),
              width: sizeFromWidth(context, 6),
              decoration: const BoxDecoration(
                color: Color(0xFFbdbdbd),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo2.jpeg'),
                ),
              ),
            ),
            Text(
              'IFMIS',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: sizeFromWidth(context, 23),
                color: white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: white,
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SizedBox(height: sizeFromHeight(context, 4)),
                  Container(
                    alignment: Alignment.center,
                    width: sizeFromWidth(context, 1),
                    height: language ? sizeFromHeight(context, 5) : sizeFromHeight(context, 4.2),
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            textWidget(
                              textsArabic['arabic'].toString(),
                              null,
                              null,
                              white,
                              sizeFromWidth(context, 23),
                              FontWeight.w400,
                            ),
                            Switch(
                              value: CacheHelper.getData(key: 'language') ?? false,
                              onChanged: (value) {
                                otherProvider.changeLanguage(value);
                              },
                              activeColor: white,
                              inactiveTrackColor: lightGrey1,
                            ),
                            textWidget(
                              textsEnglish['english'].toString(),
                              null,
                              null,
                              white,
                              sizeFromWidth(context, 23),
                              FontWeight.w400,
                            ),
                          ],
                        ),
                        textWidget(
                          otherProvider.getTexts('agreement').toString(),
                          null,
                          TextAlign.center,
                          white,
                          sizeFromWidth(context, 30),
                          FontWeight.bold,
                        ),
                        textWidget(
                          otherProvider.getTexts('can see policy').toString(),
                          null,
                          null,
                          white,
                          sizeFromWidth(context, 35),
                          FontWeight.bold,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  CacheHelper.saveData(key: 'selectPolicies', value: true);
                                  setState(() {
                                    showPolicies = true;
                                    selectedNumber = 1;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedNumber == 1 ? amber.withOpacity(0.8) : white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: textWidget(
                                    otherProvider.getTexts('ok').toString(),
                                    null,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  CacheHelper.saveData(key: 'selectPolicies', value: true);
                                  setState(() {
                                    showPolicies = true;
                                    selectedNumber = 2;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedNumber == 2 ? amber.withOpacity(0.8) : white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: textWidget(
                                    otherProvider.getTexts('refused').toString(),
                                    null,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigateTo(context, const Policies());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: textWidget(
                                    otherProvider.getTexts('overview').toString(),
                                    null,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (selectedNumber == 0) {
                        showToast(
                            text: language
                                ? 'You must agree or not agree about policies'
                                : 'يجب أن توافق أو لا توافق على السياسات',
                            state: ToastStates.ERROR);
                      } else {
                        CacheHelper.saveData(
                            key: 'selectPolicies', value: true);
                        navigateAndFinish(context, const LogIn());
                      }
                    },
                    child: Container(
                      width: sizeFromWidth(context, 1),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        otherProvider
                            .getTexts("welcome to ifmis start")
                            .toString(),
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
