
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../network/notification_helper.dart';
import '../../providers/other provider.dart';
import '../Championship%20stats/Championship%20stats.dart';
import '../Chat/category%20chat.dart';
import '../games/all%20games.dart';
import '../ifmis/ifmis.dart';
import '../matches%20statistics/statistics.dart';
import '../notifications/notifications.dart';
import '../play_store/store%20caegory.dart';
import '../profile/profile.dart';
import '../sport%20services/sport%20services.dart';
import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../providers/user provider.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../competitions/Competitions.dart';
import '../sport courses/sport categories.dart';
import '../talent exploration/talent category.dart';
import 'drawer.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserProvider userProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  String newMessageId = '';

  @override
  void initState() {
    CacheHelper.getData(key: 'token') ?? '';
    Provider.of<OtherProvider>(context, listen: false).getNotifications();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    language = CacheHelper.getData(key: 'language') ?? false;
    NotificationHelper.init(context);
    FirebaseMessaging.onMessage.listen(
      (event) {
        if (event.messageId != newMessageId) {
          newMessageId = event.messageId ?? '';
          NotificationHelper.showNotification(event);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) => NotificationHelper.handleNotificationClick(
        context,
        event.data,
      ),
    );
    FirebaseMessaging.instance.getInitialMessage().then(
      (event) {
        if (event != null) {
          NotificationHelper.handleNotificationClick(
            context,
            event.data,
          );
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Directionality(
      textDirection: language ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerSide(),
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
          actions: [
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.notifications),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      notifications.isNotEmpty
                          ? notifications.length.toString()
                          : '0',
                      maxLines: 1,
                      style: TextStyle(
                        color: white,
                        fontSize: sizeFromHeight(context, 90),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                navigateAndFinish(context, const Notifications());
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                String token = CacheHelper.getData(key: 'token') ?? '';
                Provider.of<UserProvider>(context, listen: false)
                    .getDataUser(context, token);
                navigateAndFinish(
                    context, Profile(token, 'home', false, false, '', false));
              },
            ),
          ],
        ),
        body: UpgradeAlert(
          upgrader: Upgrader(
            canDismissDialog: true,
            durationUntilAlertAgain: const Duration(days: 1),
            dialogStyle: Platform.isAndroid
                ? UpgradeDialogStyle.material
                : UpgradeDialogStyle.cupertino,
          ),
          child: Column(
            children: [
              Container(
                height: sizeFromHeight(context, 20, hasAppBar: false),
                width: sizeFromWidth(context, 1),
                color: white,
                child: Card(
                  elevation: 10,
                  color: white,
                  child: Marquee(
                    text: language
                        ? settingModel.newsTicker.en
                        : settingModel.newsTicker.ar,
                    style: TextStyle(fontWeight: FontWeight.bold, color: black),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 50,
                    accelerationDuration: const Duration(microseconds: 30),
                  ),
                ),
              ),
              Container(
                height: sizeFromHeight(context, 10),
                width: sizeFromWidth(context, 1),
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: CarouselSlider(
                    items: upBanners.map((e) {
                      return InkWell(
                        onTap: () async {
                          var url = Uri.parse(e.link);
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: lightGrey,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(e.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 250,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[9].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[9].nameEN : screens[9].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const StoreCategory());
                          },
                        ),
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[3].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[3].nameEN : screens[3].nameAR,
                              null,
                              TextAlign.center,
                              black,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const TalentCategory());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[7].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[7].nameEN : screens[7].nameAR,
                              null,
                              TextAlign.center,
                              black,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(
                                context, const CourseCategories());
                          },
                        ),
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[6].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[6].nameEN : screens[6].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const Competitions());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[5].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[5].nameEN : screens[5].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const CategoryChat());
                          },
                        ),
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[4].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[4].nameEN : screens[4].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const SportServices());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[8].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[8].nameEN : screens[8].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const Statistics());
                          },
                        ),
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[2].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[2].nameEN : screens[2].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const IFMIS());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[1].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[1].nameEN : screens[1].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(context, const AllGames());
                          },
                        ),
                        materialWidget(
                          context,
                          sizeFromWidth(context, 2),
                          sizeFromWidth(context, 2.2),
                          10,
                          screens[0].image,
                          BoxFit.cover,
                          [
                            textWidget(
                              language ? screens[0].nameEN : screens[0].nameAR,
                              null,
                              TextAlign.center,
                              white,
                              sizeFromWidth(context, 30),
                              FontWeight.w500,
                            ),
                          ],
                          MainAxisAlignment.start,
                          false,
                          10,
                          scaffoldColor,
                          () {
                            navigateAndFinish(
                                context, const ChampionshipStats());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        if (Platform.isIOS) {
                          var url = Uri.parse(
                              'https://apps.apple.com/app/%D8%A7%D9%84%D8%A7%D8%AA%D8%AD%D8%A7%D8%AF-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A-ifmis/id1670802361');
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          var url = Uri.parse(
                              'https://play.google.com/store/apps/details?id=dev.ifmis.news');
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(
                            horizontal: sizeFromWidth(context, 2.5)),
                        child: textWidget(
                            otherProvider.getTexts('rate us').toString(),
                            null,
                            TextAlign.center,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            null,
                            1.3),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              bottomScaffoldWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}
