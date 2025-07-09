// @dart=2.12
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifmis/providers/talent%20provider.dart';
import 'package:ifmis/providers/user%20provider.dart';

import 'firebase_options.dart';
import 'network/cash_helper.dart';
import 'providers/articles%20provider.dart';
import 'providers/chat%20provider.dart';
import 'providers/competition%20provider.dart';
import 'providers/games%20provider.dart';
import 'providers/ifmis%20provider.dart';
import 'providers/matches%20statistics%20provider.dart';
import 'providers/other%20provider.dart';
import 'providers/sport%20courses%20provider.dart';
import 'providers/sport%20services%20provider.dart';
import 'providers/store%20provider.dart';
import 'package:provider/provider.dart';
import 'modules/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider<CompetitionProvider>(
          create: (context) => CompetitionProvider(),
        ),
        ChangeNotifierProvider<StoreProvider>(
          create: (context) => StoreProvider(),
        ),
        ChangeNotifierProvider<MatchesStatisticsProvider>(
          create: (context) => MatchesStatisticsProvider(),
        ),
        ChangeNotifierProvider<ArticlesProvider>(
          create: (context) => ArticlesProvider(),
        ),
        ChangeNotifierProvider<IFMISProvider>(
          create: (context) => IFMISProvider(),
        ),
        ChangeNotifierProvider<OtherProvider>(
          create: (context) => OtherProvider(),
        ),
        ChangeNotifierProvider<SportServicesProvider>(
          create: (context) => SportServicesProvider(),
        ),
        ChangeNotifierProvider<GamesProvider>(
          create: (context) => GamesProvider(),
        ),
        ChangeNotifierProvider<SportCoursesProvider>(
          create: (context) => SportCoursesProvider(),
        ),
        ChangeNotifierProvider<TalentProvider>(
          create: (context) => TalentProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'الاتحاد الدولى',
        home: SplashScreen(),
      ),
    );
  }
}
