import 'package:flutter/material.dart';
import '../../providers/other provider.dart';
import '../Evacuation%20Responsibilaty/EvacuationResponsibilaty.dart';
import '../IntellectualProperty/IntellectualProperty.dart';
import '../membership/membership.dart';
import '../notifications/notifications.dart';
import '../policies/policies.dart';
import '../programmer/select%20programer.dart';
import '../../providers/user%20provider.dart';
import '../../shared/const.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../Authentication/sign up.dart';
import '../Vision, mission and goals/Vision, mission and goals.dart';
import '../members/members.dart';
import '../profile/profile.dart';

class DrawerSide extends StatefulWidget {
  const DrawerSide({Key? key}) : super(key: key);

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  late UserProvider userProvider;
  late OtherProvider otherProvider;
  var url = Uri.parse('whatsapp://send?phone=${settingModel.whatsNumber}');
  bool language = CacheHelper.getData(key: 'language') ?? false;
  String email = CacheHelper.getData(key: 'email') ?? '';

  @override
  void didChangeDependencies() {
    language = CacheHelper.getData(key: 'language') ?? false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return SizedBox(
      height: sizeFromHeight(context, 1),
      width: sizeFromWidth(context, 1.7),
      child: Drawer(
        child: Container(
          color: primaryColor,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: white,
                      radius: sizeFromWidth(context, 10),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFd1ad17),
                        radius: sizeFromWidth(context, 11),
                        backgroundImage:
                            const AssetImage("assets/images/logo2.jpeg"),
                      ),
                    ),
                    const Spacer(),
                    textWidget(
                      'IFMIS',
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 20),
                      FontWeight.bold,
                    ),
                  ],
                ),
              ),
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
                      otherProvider.changeLanguage(value).then((_) async {
                        await otherProvider.updateAppLanguage(value);
                      });
                    },
                    activeColor: lightGrey,
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
              buildListTile(
                context,
                language ? sideMenu[0].nameEN : sideMenu[0].nameAR,
                Icons.person_outline,
                () {
                  String token = CacheHelper.getData(key: 'token') ?? '';
                  if (token == '') {
                    navigateAndFinish(context, const SignUP());
                  } else {
                    Provider.of<UserProvider>(context, listen: false)
                        .getDataUser(context, token);
                    navigateAndFinish(context,
                        Profile(token, 'home', false, false, '', false));
                  }
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[1].nameEN : sideMenu[1].nameAR,
                Icons.remember_me_outlined,
                () {
                  navigateAndFinish(context, const Members());
                },
              ),
              Directionality(
                textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                child: ListTile(
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: white,
                    ),
                    child: Text(
                      notifications.isNotEmpty
                          ? notifications.length.toString()
                          : '0',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: sizeFromWidth(context, 25),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    otherProvider.getTexts("notifications").toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: sizeFromWidth(context, 25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    navigateAndFinish(context, const Notifications());
                  },
                ),
              ),
              buildListTile(
                context,
                language ? sideMenu[2].nameEN : sideMenu[2].nameAR,
                Icons.lightbulb_outlined,
                () {
                  navigateAndFinish(context, const VisionMissionAndGoals());
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[3].nameEN : sideMenu[3].nameAR,
                Icons.rule_folder_outlined,
                () {
                  navigateAndFinish(context, const Membership());
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[4].nameEN : sideMenu[4].nameAR,
                Icons.privacy_tip_outlined,
                () {
                  navigateTo(context, const Policies());
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[5].nameEN : sideMenu[5].nameAR,
                Icons.person_search_outlined,
                () {
                  navigateAndFinish(context, const IntellectualProperty());
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[6].nameEN : sideMenu[6].nameAR,
                Icons.person_search_outlined,
                () {
                  navigateAndFinish(context, const EvacuationResponsibilaty());
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[7].nameEN : sideMenu[7].nameAR,
                Icons.groups,
                () async {
                  navigateAndFinish(context, const SelectProgrammer());
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[8].nameEN : sideMenu[8].nameAR,
                Icons.call,
                () async {
                  await launchUrl(url,
                      mode: LaunchMode.externalNonBrowserApplication);
                },
              ),
              buildListTile(
                context,
                language ? sideMenu[9].nameEN : sideMenu[9].nameAR,
                Icons.logout,
                () {
                  String token = CacheHelper.getData(key: 'token') ?? '';
                  if (token == '') {
                    showToast(
                        text: 'لا يوجد حساب مسجل', state: ToastStates.WARNING);
                  } else {
                    userProvider.userLogout(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
