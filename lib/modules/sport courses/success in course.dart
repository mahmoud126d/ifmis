// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20courses/sport%20courses.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/sport courses provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../profile/profile.dart';

class SuccessInCourse extends StatefulWidget {
  String courseID;
  String categoryID;

  SuccessInCourse(this.courseID, this.categoryID,{Key? key}) : super(key: key);

  @override
  State<SuccessInCourse> createState() => _SuccessInCourseState();
}

class _SuccessInCourseState extends State<SuccessInCourse> {
  late SportCoursesProvider sportCoursesProvider;

  @override
  void initState() {
    Provider.of<SportCoursesProvider>(context, listen: false)
        .getSuccessfulStudent(widget.courseID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sportCoursesProvider = Provider.of(context);
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
            navigateAndFinish(context, SportCourses(widget.categoryID));
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: sizeFromHeight(context, 90)),
          if (sportCoursesProvider.successStudents.isNotEmpty)
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 5,
                childAspectRatio: 1 / 1,
                physics: const BouncingScrollPhysics(),
                children: sportCoursesProvider.successStudents.map((e) {
                  return InkWell(
                    onTap: (){
                      showAlertDialog(context, e.student.name!, e.student.image.toString(), e.student.id.toString());
                    },
                    child: Column(
                      children: [
                        Container(
                          width: sizeFromWidth(context, 3.5),
                          height: sizeFromWidth(context, 4.5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            image: e.student.image != ''
                                ? DecorationImage(
                              image: NetworkImage(e.student.image!),
                              fit: BoxFit.cover,
                            )
                                : null,
                            border: Border.all(color: primaryColor),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        Container(
                          width: sizeFromWidth(context, 3.5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              if (double.parse(e.degreeSuccess!) ==
                                  sportCoursesProvider.firstStudent)
                                const Icon(FontAwesomeIcons.medal,
                                    color: Colors.amber),
                              Expanded(child: Column(
                                children: [
                                  textWidget(
                                    e.student.name!,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                    1,
                                    1.2,
                                  ),
                                  textWidget(
                                    '${e.degreeSuccess} %',
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                    1,
                                    1.2,
                                  ),
                                ],
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          if (sportCoursesProvider.successStudents.isEmpty)
            Expanded(
              child: Center(
                child: textWidget(
                  'لا يوجد شخص اجتاز الدورة حتى الان',
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

  showAlertDialog(
    BuildContext context,
    String name,
    String image,
    String id,
  ) {
    AlertDialog alert = AlertDialog(
      backgroundColor: primaryColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: sizeFromHeight(context, 20),
            backgroundColor: primaryColor,
            backgroundImage: image != '' ? NetworkImage(image) : null,
          ),
          textWidget(
            name,
            null,
            TextAlign.center,
            white,
            sizeFromWidth(context, 25),
            FontWeight.bold,
          ),
          textButton(
            context,
            'عرض الملف الشخصى',
            primaryColor,
            white,
            sizeFromWidth(context, 30),
            FontWeight.bold,
            () {
              Provider.of<UserProvider>(context, listen: false)
                  .getDataOtherUser(context, id)
                  .then((value) {
                navigateTo(
                    context, Profile(id, 'chat', false, false, '', false));
              });
            },
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
}
