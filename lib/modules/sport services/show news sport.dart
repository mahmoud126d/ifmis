// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/sport%20services/show%20news%20spore%20details.dart';
import 'package:ifmis/modules/sport%20services/sport%20services.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/sport services provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'add news sport.dart';

class ShowsNewsSport extends StatefulWidget {
  String id;

  ShowsNewsSport(this.id, {Key? key}) : super(key: key);

  @override
  State<ShowsNewsSport> createState() => _ShowsNewsSportState();
}

class _ShowsNewsSportState extends State<ShowsNewsSport> {
  late SportServicesProvider servicesProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  TextEditingController confirmDelete = TextEditingController();

  showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = textButton(
      context,
      language ? 'Back' : 'رجوع',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
          () {
        navigatePop(context);
      },
    );
    Widget continueButton = textButton(
      context,
      language ? 'Delete' : 'حذف',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
          () {
        if (confirmDelete.text.trim() == CacheHelper.getData(key: 'password')) {
          servicesProvider
              .deleteNews(servicesProvider
              .sportServicesNewsModel[index].id
              .toString())
              .then((value) {
            servicesProvider
                .getSportServicesNews(widget.id);
          });
          confirmDelete.clear();
          navigatePop(context);
        } else {
          showToast(
              text: language ? 'Wrong Password' : 'خطأ فى كلمة سر',
              state: ToastStates.ERROR);
          confirmDelete.clear();
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        language
            ? 'Are you sure you want to delete your post ?'
            : 'هل أنت متأكد من حذف مشاركتك ؟',
        null,
        TextAlign.end,
        black,
        sizeFromWidth(context, 25),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textFormField(
            controller: confirmDelete,
            type: TextInputType.text,
            validate: (value) {
              return null;
            },
            fromLTR: language,
            isExpanded: true,
            hint: language ? 'Enter your password' : 'أدخل كلمة السر الخاصة بك',
          ),
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
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

  @override
  void initState() {
    Provider.of<SportServicesProvider>(context, listen: false)
        .getSportServicesNews(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    servicesProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    var id = CacheHelper.getData(key: 'id');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const SportServices());
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              navigateTo(context, AddNewsSport(widget.id));
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
                otherProvider.getTexts('add contribution').toString(),
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
      body: ConditionalBuilder(
        condition: servicesProvider.sportServicesNewsModel.isNotEmpty &&
            !servicesProvider.isLoading,
        builder: (context) {
          return Directionality(textDirection: !language ? TextDirection.ltr : TextDirection.rtl, child: Column(
            children: [
              Container(
                width: sizeFromWidth(context, 1),
                height: sizeFromHeight(context, 11, hasAppBar: true),
                color: primaryColor,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: textFormField(
                    controller: servicesProvider.search,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    onChange: (value) {
                      if (servicesProvider.search.text == '') {
                        servicesProvider.getSportServicesNews(widget.id);
                      }
                      servicesProvider.searchAboutNews();
                    },
                    hint: otherProvider.getTexts('search').toString(),
                    isExpanded: true,
                    fromLTR: language,
                    textAlignVertical: TextAlignVertical.bottom,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: servicesProvider.sportServicesNewsModel.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        navigateTo(
                            context,
                            ShowNewsSporeDetails(servicesProvider
                                .sportServicesNewsModel[index]));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (servicesProvider
                                .sportServicesNewsModel[index].user !=
                                null &&
                                id ==
                                    servicesProvider
                                        .sportServicesNewsModel[index].user!.id)
                              IconButton(
                                  onPressed: () {
                                    showAlertDialog(context, index);
                                  },
                                  icon: Icon(Icons.delete, color: white)),
                            //const Spacer(),
                            Expanded(child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    textWidget(
                                      language ? servicesProvider
                                          .sportServicesNewsModel[index].title.en : servicesProvider
                                          .sportServicesNewsModel[index].title.ar,
                                      TextDirection.rtl,
                                      null,
                                      white,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                    ),
                                  ],
                                )),),
                            Container(
                              width: sizeFromWidth(context, 6.5),
                              height: sizeFromWidth(context, 6.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    servicesProvider
                                        .sportServicesNewsModel[index]
                                        .images[0]
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
          ),);
        },
        fallback: (context) {
          return Center(
            child: textWidget(
              language ? 'There are no requests services' : 'لا يوجد خدمات طلبات',
              null,
              null,
              primaryColor,
              sizeFromWidth(context, 20),
              FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
