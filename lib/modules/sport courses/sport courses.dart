// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20courses/sport%20categories.dart';
import 'package:ifmis/modules/sport%20courses/sport%20course%20details.dart';
import 'package:ifmis/modules/sport%20courses/success%20in%20course.dart';
import 'package:provider/provider.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/sport courses provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'create course.dart';

class SportCourses extends StatefulWidget {
  String categoryID;

  SportCourses(this.categoryID, {Key? key}) : super(key: key);

  @override
  State<SportCourses> createState() => _SportCoursesState();
}

class _SportCoursesState extends State<SportCourses> {
  late SportCoursesProvider sportCoursesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<SportCoursesProvider>(context, listen: false)
        .getCourses(widget.categoryID);
    super.initState();
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
            navigateAndFinish(context, const CourseCategories());
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
        actions: [
          InkWell(
            onTap: () {
              navigateTo(context, CreateCourse(widget.categoryID));
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
                otherProvider.getTexts('create course').toString(),
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: textWidget(
              language ? settingModel.courseText.en : settingModel.courseText.ar,
              language ? TextDirection.ltr : TextDirection.rtl,
              null,
              white,
              sizeFromWidth(context, 30),
              FontWeight.bold,
            ),
          ),
          if (sportCoursesProvider.courses.isNotEmpty)
            Directionality(textDirection: language ? TextDirection.rtl : TextDirection.ltr, child: Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: sportCoursesProvider.courses.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () async {
                      DateTime startDate = DateTime.parse(sportCoursesProvider.courses[index].open);
                      DateTime endDate = DateTime.parse(sportCoursesProvider.courses[index].close);
                      DateTime now = DateTime.now();
                      if (startDate.isBefore(now) && endDate.isAfter(now)) {
                        navigateAndFinish(
                            context,
                            SportCourseDetails(
                                sportCoursesProvider.courses[index],
                                widget.categoryID));
                      } else {
                        showToast(
                            text: language ? 'The course will open on: ${startDate.toString()} \nThe course will close on: ${endDate.toString()}' : 'سيتم فتح الدورة بتاريخ: ${startDate.toString()} \nسيتم غلق الدورة بتاريخ: ${endDate.toString()}',
                            state: ToastStates.WARNING);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      width: sizeFromWidth(context, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF7f0e14),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  navigateAndFinish(
                                      context,
                                      SuccessInCourse(
                                          sportCoursesProvider.courses[index].id
                                              .toString(),
                                          widget.categoryID));
                                },
                                icon: Icon(Icons.people, color: white),
                              ),
                              IconButton(
                                onPressed: () async {
                                  WcFlutterShare.share(
                                    sharePopupTitle: 'مشاركة',
                                    mimeType: 'text/plain',
                                    text:
                                    'دورة ${sportCoursesProvider.courses[index].name} \n for iphone: https://apps.apple.com/app/%D8%A7%D9%84%D8%A7%D8%AA%D8%AD%D8%A7%D8%AF-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A-ifmis/id1670802361 \n for android: https://play.google.com/store/apps/details?id=dev.ifmis.news',
                                  ).then((value) {
                                    sportCoursesProvider.registerShared(
                                        sportCoursesProvider.courses[index].id);
                                  });
                                },
                                icon: Icon(Icons.share, color: white),
                              ),
                              Expanded(
                                child: Text(
                                  language
                                      ? sportCoursesProvider
                                      .courses[index].name.en
                                      : sportCoursesProvider
                                      .courses[index].name.ar,
                                  textDirection: !language
                                      ? TextDirection.rtl : TextDirection.ltr,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: sizeFromWidth(context, 7),
                                height: sizeFromHeight(context, 12,
                                    hasAppBar: true),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(sportCoursesProvider
                                          .courses[index].image),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),),
          if (sportCoursesProvider.courses.isEmpty)
            Expanded(
              child: Center(
                child: textWidget(
                  otherProvider.getTexts('no courses').toString(),
                  null,
                  null,
                  primaryColor,
                  sizeFromWidth(context, 20),
                  FontWeight.bold,
                ),
              ),
            ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
