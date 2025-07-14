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
    super.initState();
    print('=== SPLASH: Starting initialization ===');
    _initializeProviders();
    _startTimer();
  }

  void _initializeProviders() {
    try {
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
      print('=== SPLASH: Providers initialized ===');
    } catch (e) {
      print('=== SPLASH: Provider initialization error: $e ===');
    }
  }

  void _startTimer() {
    Timer(
      const Duration(seconds: 4),
          () async {
        print('=== SPLASH: Timer completed, starting navigation logic ===');
        await _handleNavigation();
      },
    );
  }

  Future<void> _handleNavigation() async {
    try {
      print('=== SPLASH: Checking Firebase availability ===');

      // Add timeout to Firestore call
      var available = await FirebaseFirestore.instance
          .collection('admin')
          .doc('Qa1ZsddOKeCm0R3mDPNp')
          .get()
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('=== SPLASH: Firebase timeout, proceeding with offline mode ===');
          throw TimeoutException('Firebase timeout', const Duration(seconds: 10));
        },
      );

      print('=== SPLASH: Firebase check completed ===');

      if (available['app']) {
        print('=== SPLASH: App disabled, navigating to waiting screen ===');
        navigateAndFinish(context, const WaitingScreen());
      } else {
        await _proceedWithNormalFlow();
      }
    } catch (e) {
      print('=== SPLASH: Firebase error: $e ===');
      print('=== SPLASH: Proceeding with offline mode ===');
      await _proceedWithNormalFlow();
    }
  }

  Future<void> _proceedWithNormalFlow() async {
    try {
      if (!showPolicies) {
        print('=== SPLASH: Navigating to language selection ===');
        navigateAndFinish(context, const SelectLanguage());
      } else if (token != '') {
        print('=== SPLASH: Token found, getting user data ===');
        try {
          await Provider.of<UserProvider>(context, listen: false)
              .getDataUser(context, token);
          if (userModel.toMap().containsValue('')) {
            print('=== SPLASH: User data incomplete, navigating to profile ===');
            navigateAndFinish(
                context, Profile(token, 'home', false, false, '', true));
          } else {
            print('=== SPLASH: User data complete, navigating to home ===');
            navigateAndFinish(context, const Home());
          }
        } catch (e) {
          print('=== SPLASH: User data error: $e ===');
          showToast(text: e.toString(), state: ToastStates.ERROR);
          navigateAndFinish(context, const LogIn());
        }
      } else {
        print('=== SPLASH: No token, navigating to login ===');
        navigateAndFinish(context, const LogIn());
      }
    } catch (e) {
      print('=== SPLASH: Navigation error: $e ===');
      // Fallback navigation
      navigateAndFinish(context, const LogIn());
    }
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