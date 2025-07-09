// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20courses/sport%20courses.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../models/sports courses/Sports courses.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/sport courses provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class CreateCourse extends StatefulWidget {
  String categoryID;

  CreateCourse(this.categoryID, {Key? key}) : super(key: key);

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  late SportCoursesProvider sportCoursesProvider;
  TextEditingController nameAR = TextEditingController();
  TextEditingController nameEN = TextEditingController();
  TextEditingController trainerAR = TextEditingController();
  TextEditingController trainerEN = TextEditingController();
  TextEditingController video = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController openDate = TextEditingController();
  TextEditingController closeDate = TextEditingController();
  TextEditingController type = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  void _showDatePicker(BuildContext context, String type) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(5000),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: white,
              onSurface: primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      _showTimePicker(context, value!, type);
    });
  }

  void _showTimePicker(BuildContext context, DateTime date, String type) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: white,
              onSurface: primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      DateTime newDateTime =
          DateTime(date.year, date.month, date.day, value!.hour, value.minute);
      String timeFormatted =
          intl.DateFormat('yyyy-MM-dd H:mm:ss').format(newDateTime);
      if (type == 'open') {
        setState(() {
          openDate.text = timeFormatted;
        });
      } else {
        setState(() {
          closeDate.text = timeFormatted;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    sportCoursesProvider = Provider.of(context);
    otherProvider = Provider.of(context);
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
            sportCoursesProvider.questions = [];
            sportCoursesProvider.setCreateExamValue(false);
            navigateAndFinish(context, SportCourses(widget.categoryID));
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
      ),
      body: Column(
        children: [
          if (!sportCoursesProvider.startCreateExam)
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    SizedBox(height: sizeFromHeight(context, 90)),
                    textFormField(
                      controller: nameAR,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'The name of the course must be entered in Arabic'
                              : 'يجب إدخال اسم الدورة بالعربى';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint:
                          otherProvider.getTexts('enter ar course').toString(),
                    ),
                    textFormField(
                      controller: nameEN,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'The name of the course must be entered in English'
                              : 'يجب إدخال اسم الدورة بالإنجليزية';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint:
                          otherProvider.getTexts('enter en course').toString(),
                    ),
                    textFormField(
                      controller: trainerAR,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'The course instructor must be entered in Arabic'
                              : 'يجب إدخال مدرب الدورة بالعربى';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('enter trainer course ar')
                          .toString(),
                    ),
                    textFormField(
                      controller: trainerEN,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'The course instructor must be entered in English'
                              : 'يجب إدخال مدرب الدورة بالإنجليزى';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('enter trainer course en')
                          .toString(),
                    ),
                    textFormField(
                      controller: video,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter the course video link'
                              : 'يجب إدخال رابط فيديو الدورة';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('enter link course')
                          .toString(),
                    ),
                    textFormField(
                      controller: rate,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'You must enter the session pass rate'
                              : 'يجب إدخال نسبة النجاح الدورة';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider
                          .getTexts('enter success course')
                          .toString(),
                    ),
                    textFormField(
                      controller: openDate,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'The course opening time must be entered'
                              : 'يجب إدخال وقت فتح الدورة';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('open course').toString(),
                      onTap: () {
                        _showDatePicker(context, "open");
                      },
                    ),
                    textFormField(
                      controller: closeDate,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'The course closing time must be entered'
                              : 'يجب إدخال وقت غلق الدورة';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('close course').toString(),
                      onTap: () {
                        _showDatePicker(context, "close");
                      },
                    ),
                    textFormField(
                      controller: type,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty ||
                            value !=
                                otherProvider
                                    .getTexts('type course football') ||
                            value !=
                                otherProvider.getTexts('type course public')) {
                          return language
                              ? 'The course type must be entered'
                              : 'يجب إدخال نوع الدورة';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('type course').toString(),
                      onTap: () {
                        AlertDialog alert = AlertDialog(
                          backgroundColor: white,
                          content: SizedBox(
                            height: sizeFromHeight(context, 7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type.text = otherProvider
                                          .getTexts('type course football')
                                          .toString();
                                    });
                                    navigatePop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: type.text ==
                                              otherProvider.getTexts(
                                                  'type course football')
                                          ? primaryColor
                                          : lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: textWidget(
                                      otherProvider
                                          .getTexts('type course football')
                                          .toString(),
                                      null,
                                      TextAlign.end,
                                      white,
                                      sizeFromWidth(context, 25),
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type.text = otherProvider
                                          .getTexts('type course public')
                                          .toString();
                                    });
                                    navigatePop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: type.text ==
                                              otherProvider.getTexts(
                                                  'type course public')
                                          ? primaryColor
                                          : lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: textWidget(
                                      otherProvider
                                          .getTexts('type course public')
                                          .toString(),
                                      null,
                                      TextAlign.end,
                                      white,
                                      sizeFromWidth(context, 25),
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              sportCoursesProvider.questions = [];
                              CreateQuestions questionCreated =
                                  CreateQuestions(name: '', answer: '');
                              sportCoursesProvider
                                  .setQuestionModel(questionCreated);
                              sportCoursesProvider.addQuestion(questionCreated);
                              sportCoursesProvider.setCreateExamValue(true);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: textWidget(
                                otherProvider.getTexts('start quiz').toString(),
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              sportCoursesProvider.pickCourseImage();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: textWidget(
                                otherProvider
                                    .getTexts('select photo course')
                                    .toString(),
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              sportCoursesProvider.pickPaperCourseFile();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: textWidget(
                                otherProvider
                                    .getTexts('select file course')
                                    .toString(),
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!sportCoursesProvider.isLoading)
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  sportCoursesProvider.createSportCourse(
                                    nameAR.text.trim(),
                                    nameEN.text.trim(),
                                    trainerAR.text.trim(),
                                    trainerEN.text.trim(),
                                    video.text.trim(),
                                    rate.text.trim(),
                                    widget.categoryID,
                                    openDate.text.trim(),
                                    closeDate.text.trim(),
                                    type.text.trim().contains('football') ||
                                            type.text.trim().contains('كرة قدم')
                                        ? "football_course"
                                        : "public_course",
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: textWidget(
                                  otherProvider
                                      .getTexts('create course')
                                      .toString(),
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 20),
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (sportCoursesProvider.isLoading)
                      Center(
                        child: circularProgressIndicator(
                            lightGrey, primaryColor, context),
                      )
                  ],
                ),
              ),
            ),
          if (sportCoursesProvider.startCreateExam)
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
                    SizedBox(height: sizeFromHeight(context, 90)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            sportCoursesProvider.question.clear();
                            sportCoursesProvider.filterQuestions();
                            sportCoursesProvider.index = 0;
                            sportCoursesProvider.setCreateExamValue(false);
                            sportCoursesProvider.question.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor,
                            ),
                            child: textWidget(
                              otherProvider
                                  .getTexts('finish course')
                                  .toString(),
                              null,
                              null,
                              white,
                              language
                                  ? sizeFromWidth(context, 35)
                                  : sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                          child: textWidget(
                            '${otherProvider.getTexts('quiz num').toString()}: ${sportCoursesProvider.index}',
                            null,
                            null,
                            white,
                            language
                                ? sizeFromWidth(context, 35)
                                : sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textFormField(
                      controller: sportCoursesProvider.question,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return language
                              ? 'Question is required'
                              : 'يجب إدخال السؤال';
                        }
                        return null;
                      },
                      fromLTR: language,
                      hint: otherProvider.getTexts('enter quiz').toString(),
                    ),
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
                              value:
                                  sportCoursesProvider.questionModel.answer ==
                                              '' ||
                                          sportCoursesProvider
                                                  .questionModel.answer ==
                                              'yes'
                                      ? false
                                      : true,
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    sportCoursesProvider.questionModel.answer =
                                        'no';
                                  } else {
                                    sportCoursesProvider.questionModel.answer =
                                        '';
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
                              value:
                                  sportCoursesProvider.questionModel.answer ==
                                              '' ||
                                          sportCoursesProvider
                                                  .questionModel.answer ==
                                              'no'
                                      ? false
                                      : true,
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    sportCoursesProvider.questionModel.answer =
                                        'yes';
                                  } else {
                                    sportCoursesProvider.questionModel.answer =
                                        '';
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
                        InkWell(
                          onTap: () {
                            if (sportCoursesProvider.index > 0) {
                              int value = sportCoursesProvider.index - 1;
                              sportCoursesProvider.changeQuestionIndex(value);
                              sportCoursesProvider.changeQuestionValue(
                                  sportCoursesProvider
                                      .questions[sportCoursesProvider.index]
                                      .name);
                            } else {
                              sportCoursesProvider.question.clear();
                              sportCoursesProvider.index = 0;
                              sportCoursesProvider.setCreateExamValue(false);
                            }
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
                        InkWell(
                          onTap: () {
                            sportCoursesProvider.setQuestionModelName(
                                sportCoursesProvider.question.text.trim());
                            CreateQuestions newQuestion =
                                CreateQuestions(name: '', answer: '');
                            sportCoursesProvider.setQuestionModel(newQuestion);
                            sportCoursesProvider.addQuestion(newQuestion);
                            int value = sportCoursesProvider.index + 1;
                            sportCoursesProvider.changeQuestionIndex(value);
                            sportCoursesProvider.changeQuestionValue(
                                sportCoursesProvider
                                    .questions[sportCoursesProvider.index]
                                    .name);
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
                        const SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: sizeFromHeight(context, 90)),
                  ],
                ),
              ),
            ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
