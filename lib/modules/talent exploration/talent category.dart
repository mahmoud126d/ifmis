import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/talent%20exploration/specific%20talent.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/talent provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class TalentCategory extends StatefulWidget {
  const TalentCategory({Key? key}) : super(key: key);

  @override
  State<TalentCategory> createState() => _TalentCategoryState();
}

class _TalentCategoryState extends State<TalentCategory> {
  late TalentProvider talentProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<TalentProvider>(context, listen: false).getTalentCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    talentProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
        ),
      ),
      body: ConditionalBuilder(
        condition: !talentProvider.isLoading,
        builder: (context) {
          return Directionality(
            textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: talentProvider.talentCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          navigateAndFinish(
                              context,
                              SpecificTalent(talentProvider
                                  .talentCategories[index].id
                                  .toString()));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: textWidget(
                                    language
                                        ? talentProvider
                                            .talentCategories[index].name.en
                                        : talentProvider
                                            .talentCategories[index].name.ar,
                                    language
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: sizeFromWidth(context, 7),
                                height: sizeFromWidth(context, 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      talentProvider
                                          .talentCategories[index].image,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomScaffoldWidget(context),
              ],
            ),
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }
}
