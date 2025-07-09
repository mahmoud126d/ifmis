import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../sport%20services/show%20news%20sport.dart';
import '../../providers/sport%20services%20provider.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';

class SportServices extends StatefulWidget {
  const SportServices({Key? key}) : super(key: key);

  @override
  State<SportServices> createState() => _SportServicesState();
}

class _SportServicesState extends State<SportServices> {
  late SportServicesProvider servicesProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<SportServicesProvider>(context, listen: false)
        .getSportServicesCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    servicesProvider = Provider.of(context);
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
        condition: !servicesProvider.isLoading,
        builder: (context) {
          return Directionality(
            textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        servicesProvider.sportServicesCategoriesModel.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          navigateAndFinish(
                              context,
                              ShowsNewsSport(servicesProvider
                                  .sportServicesCategoriesModel[index].id
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
                                        ? servicesProvider
                                            .sportServicesCategoriesModel[index]
                                            .name
                                            .en
                                        : servicesProvider
                                            .sportServicesCategoriesModel[index]
                                            .name
                                            .ar,
                                    language ? TextDirection.ltr : TextDirection.rtl,
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
                                      servicesProvider
                                          .sportServicesCategoriesModel[index]
                                          .image,
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
