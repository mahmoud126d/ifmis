import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../sport%20courses/sport%20courses.dart';
import 'package:provider/provider.dart';

import '../../providers/sport courses provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class CourseCategories extends StatefulWidget {
  const CourseCategories({Key? key}) : super(key: key);

  @override
  State<CourseCategories> createState() => _CourseCategoriesState();
}

class _CourseCategoriesState extends State<CourseCategories> {
  late SportCoursesProvider sportCoursesProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<SportCoursesProvider>(context, listen: false)
        .getCoursesCategory();
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
            navigateAndFinish(context, const Home());
          },
          icon: Icon(Icons.home, color: white),
        ),
      ),
      body: Directionality(
        textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
        child:  Column(
          children: [
            if (sportCoursesProvider.categories.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: sportCoursesProvider.categories.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        navigateAndFinish(
                            context,
                            SportCourses(sportCoursesProvider.categories[index].id
                                .toString()));
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
                                Expanded(
                                  child: Text(
                                    language ? sportCoursesProvider.categories[index].name.en : sportCoursesProvider.categories[index].name.ar,
                                    textDirection: language ? TextDirection.ltr :TextDirection.rtl,
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
                                        image: NetworkImage(sportCoursesProvider.categories[index].image),
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
              ),
            if (sportCoursesProvider.categories.isEmpty)
              Expanded(
                child: Center(
                  child:
                  circularProgressIndicator(lightGrey, primaryColor, context),
                ),
              ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
