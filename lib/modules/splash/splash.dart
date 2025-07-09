// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/splash/select%20language.dart';
import 'package:ifmis/modules/splash/waiting.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../network/cash_helper.dart';
import '../../providers/articles provider.dart';
import '../../providers/matches statistics provider.dart';
import '../../providers/other provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../Authentication/log in.dart';
import '../home/home.dart';
import '../profile/profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = CacheHelper.getData(key: 'token') ?? '';
  bool showPolicies = CacheHelper.getData(key: 'selectPolicies') ?? false;

  @override
  void initState() {
    Provider.of<OtherProvider>(context, listen: false).getHomeScreens();
    Provider.of<OtherProvider>(context, listen: false).getSideMenu();
    Provider.of<OtherProvider>(context, listen: false).addVisitor();
    Provider.of<OtherProvider>(context, listen: false).getBanners();
    Provider.of<OtherProvider>(context, listen: false).getSettings();
    Provider.of<OtherProvider>(context, listen: false).getProgrammers();
    Provider.of<ArticlesProvider>(context, listen: false).getPlayers();
    Provider.of<ArticlesProvider>(context, listen: false).getOtherPlayers(true);
    Provider.of<ArticlesProvider>(context, listen: false).getArticles();
    Provider.of<ArticlesProvider>(context, listen: false).getOtherArticles(true);
    Provider.of<MatchesStatisticsProvider>(context, listen: false).getScores();
    Provider.of<MatchesStatisticsProvider>(context, listen: false).getTeams();
    Timer(
      const Duration(seconds: 4),
      () async {
        var available = await FirebaseFirestore.instance
            .collection('admin')
            .doc('Qa1ZsddOKeCm0R3mDPNp')
            .get();
        if (available['app']) {
          navigateAndFinish(context, const WaitingScreen());
        } else if (!showPolicies) {
          navigateAndFinish(context, const SelectLanguage());
        } else if (token != '') {
          try {
            await Provider.of<UserProvider>(context, listen: false)
                .getDataUser(context, token);
            if (userModel.toMap().containsValue('')) {
              navigateAndFinish(
                  context, Profile(token, 'home', false, false, '', true));
            } else {
              navigateAndFinish(context, const Home());
            }
          } catch (e) {
            showToast(text: e.toString(), state: ToastStates.ERROR);
          }
        } else {
          navigateAndFinish(context, const LogIn());
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeFromWidth(context, 1),
      height: sizeFromHeight(context, 1),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
