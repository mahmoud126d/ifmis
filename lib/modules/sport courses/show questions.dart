// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20courses/sport%20courses.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../models/sports courses/Sports courses.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/sport courses provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShowQuestions extends StatefulWidget {
  SportsCoursesModel sportsCoursesModel;
  String categoryID;

  ShowQuestions(this.sportsCoursesModel, this.categoryID, {Key? key})
      : super(key: key);

  @override
  State<ShowQuestions> createState() => _ShowQuestionsState();
}

class _ShowQuestionsState extends State<ShowQuestions> {
  late SportCoursesProvider sportCoursesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  final controller = ScreenshotController();

  @override
  void initState() {
    Provider.of<SportCoursesProvider>(context, listen: false)
        .setAnswersModel(widget.sportsCoursesModel.questions);
    super.initState();
  }

  String name = CacheHelper.getData(key: 'name');
  String email = CacheHelper.getData(key: 'email');

  @override
  Widget build(BuildContext context) {
    sportCoursesProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return ResponsiveSizer(
      builder: (context, orientation, screenType){
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: white),
            backgroundColor: primaryColor,
            elevation: 0,
            title: appBarWidget(context),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                sportCoursesProvider.index = 0;
                sportCoursesProvider.startExam = false;
                navigateAndFinish(context, SportCourses(widget.categoryID));
              },
              icon: Icon(Icons.arrow_back, color: white),
            ),
          ),
          body: Column(
            children: [
              if (sportCoursesProvider.startExam)
                Expanded(
                  child: Container(
                    width: sizeFromWidth(context, 1),
                    margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: lightGrey1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: sizeFromHeight(context, 20)),
                        Container(
                          width: sizeFromWidth(context, 1),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: textWidget(
                            widget.sportsCoursesModel
                                .questions[sportCoursesProvider.index].name,
                            TextDirection.rtl,
                            null,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: sizeFromHeight(context, 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                textWidget(
                                  otherProvider.getTexts('false').toString(),
                                  null,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 20),
                                  FontWeight.bold,
                                ),
                                Checkbox(
                                  value: sportCoursesProvider
                                      .answers[
                                  sportCoursesProvider.index]
                                      .answerFromUser ==
                                      '' ||
                                      sportCoursesProvider
                                          .answers[
                                      sportCoursesProvider.index]
                                          .answerFromUser ==
                                          'yes'
                                      ? false
                                      : true,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        sportCoursesProvider
                                            .answers[sportCoursesProvider.index]
                                            .answerFromUser = 'no';
                                      } else {
                                        sportCoursesProvider
                                            .answers[sportCoursesProvider.index]
                                            .answerFromUser = '';
                                      }
                                    });
                                  },
                                  activeColor: primaryColor,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                textWidget(
                                  otherProvider.getTexts('true').toString(),
                                  null,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 20),
                                  FontWeight.bold,
                                ),
                                Checkbox(
                                  value: sportCoursesProvider
                                      .answers[
                                  sportCoursesProvider.index]
                                      .answerFromUser ==
                                      '' ||
                                      sportCoursesProvider
                                          .answers[
                                      sportCoursesProvider.index]
                                          .answerFromUser ==
                                          'no'
                                      ? false
                                      : true,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        sportCoursesProvider
                                            .answers[sportCoursesProvider.index]
                                            .answerFromUser = 'yes';
                                      } else {
                                        sportCoursesProvider
                                            .answers[sportCoursesProvider.index]
                                            .answerFromUser = '';
                                      }
                                    });
                                  },
                                  activeColor: primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            if (sportCoursesProvider.index > 0)
                              InkWell(
                                onTap: () {
                                  int value = sportCoursesProvider.index - 1;
                                  sportCoursesProvider.changeQuestionIndex(value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: Icon(Icons.arrow_back, color: white),
                                ),
                              ),
                            const Spacer(),
                            if (widget.sportsCoursesModel.questions.length - 1 !=
                                sportCoursesProvider.index)
                              InkWell(
                                onTap: () {
                                  int value = sportCoursesProvider.index + 1;
                                  sportCoursesProvider.changeQuestionIndex(value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: Icon(Icons.arrow_forward, color: white),
                                ),
                              ),
                            if (widget.sportsCoursesModel.questions.length - 1 ==
                                sportCoursesProvider.index)
                              InkWell(
                                onTap: () async {
                                  await sportCoursesProvider
                                      .checkTestDuration(
                                      widget.sportsCoursesModel.id.toString())
                                      .then((value) async {
                                    if (sportCoursesProvider.isExamined) {
                                      showToast(
                                          text:
                                              'لا يمكن تصحيح إجابتك إلا بعد مرور أسبوعين من توقيت إختبارك اخر دورة',
                                          state: ToastStates.ERROR);
                                    } else {
                                      await sportCoursesProvider.finishExam();
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: primaryColor,
                                  ),
                                  child: textWidget(
                                    otherProvider.getTexts('correct exam').toString(),
                                    null,
                                    null,
                                    white,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(height: sizeFromHeight(context, 90)),
                      ],
                    ),
                  ),
                ),
              if (!sportCoursesProvider.startExam)
                Expanded(
                  child: Container(
                    width: sizeFromWidth(context, 1),
                    margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: sizeFromHeight(context, 90)),
                        Container(
                          width: sizeFromWidth(context, 1),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: textWidget(
                            'نسبة النجاح المطلوبة فى الإختبار: ${widget.sportsCoursesModel.successRate} %',
                            TextDirection.rtl,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: sizeFromHeight(context, 90)),
                        Container(
                          width: sizeFromWidth(context, 1),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: textWidget(
                            'نسبة نجاحك بالإختبار: ${sportCoursesProvider.degree} %',
                            TextDirection.rtl,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: sizeFromHeight(context, 90)),
                        if (sportCoursesProvider.degree >=
                            double.parse(widget.sportsCoursesModel.successRate))
                          Screenshot(
                            controller: controller,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                    color: white,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/${widget.sportsCoursesModel.type}.jpg"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                Positioned(
                                  top: widget.sportsCoursesModel.type == "football_course" ? 12.2.h : 16.8.h,
                                  right: widget.sportsCoursesModel.type == "football_course" ? 25.5.w : 31.w,
                                  child: textWidget(
                                    language ? widget.sportsCoursesModel.name.en : widget.sportsCoursesModel.name.ar,
                                    language ? TextDirection.rtl : TextDirection.ltr,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 70),
                                    FontWeight.bold,
                                  ),
                                ),
                                Positioned(
                                  top: widget.sportsCoursesModel.type == "football_course" ? 16.h : 20.h,
                                  right: widget.sportsCoursesModel.type == "football_course" ? 18.3.w : 30.w,
                                  child: textWidget(
                                    name,
                                    TextDirection.rtl,
                                    null,
                                    primaryColor,
                                    sizeFromWidth(context, 60),
                                    FontWeight.bold,
                                  ),
                                ),
                                Positioned(
                                  bottom: widget.sportsCoursesModel.type == "football_course" ? 8.6.h : 6.h,
                                  right: widget.sportsCoursesModel.type == "football_course" ? 6.w : null,
                                  left: widget.sportsCoursesModel.type == "football_course" ? null : 32.w,
                                  child: textWidget(
                                    language ? widget.sportsCoursesModel.trainer.en : widget.sportsCoursesModel.trainer.ar,
                                    TextDirection.rtl,
                                    TextAlign.end,
                                    primaryColor,
                                    sizeFromWidth(context, 60),
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: sizeFromHeight(context, 90)),
                        if (sportCoursesProvider.degree >=
                            double.parse(widget.sportsCoursesModel.successRate))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                textWidget(
                                  'مبروك تم إجتياز الدورة بنجاح,',
                                  TextDirection.rtl,
                                  null,
                                  Colors.green,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        if (sportCoursesProvider.degree <
                            double.parse(widget.sportsCoursesModel.successRate))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                textWidget(
                                  'نأسف لعدم نجاحك بالدورة يمكنك الخروج و اختبار نفسك مره أخرى بعد مرور أسبوعين.',
                                  TextDirection.rtl,
                                  null,
                                  Colors.red,
                                  sizeFromWidth(context, 20),
                                  FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        if (sportCoursesProvider.degree >=
                            double.parse(widget.sportsCoursesModel.successRate))
                          SizedBox(height: sizeFromHeight(context, 90)),
                        if (sportCoursesProvider.degree >=
                            double.parse(widget.sportsCoursesModel.successRate))
                          InkWell(
                            onTap: () async {
                              try {
                                var image = await controller.capture();
                                await sportCoursesProvider.sendCertificateToEmail(
                                    email, image!, language ? widget.sportsCoursesModel.name.en : widget.sportsCoursesModel.name.ar);
                                await sportCoursesProvider.studentSuccess(
                                    widget.sportsCoursesModel.id.toString());
                                await sportCoursesProvider.checkTestDuration(
                                    widget.sportsCoursesModel.id.toString());
                              } catch (e) {
                                showToast(
                                    text: e.toString(), state: ToastStates.ERROR);
                              }
                            },
                            child: Container(
                              width: sizeFromWidth(context, 1),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: textWidget(
                                'إرسال الشهادة للبريد الإلكترونى',
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        SizedBox(height: sizeFromHeight(context, 90)),
                      ],
                    ),
                  ),
                ),
              bottomScaffoldWidget(context),
            ],
          ),
        );
      },
    );
  }
}
