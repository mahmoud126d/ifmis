import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

import '../../shared/const.dart';
import '../home/home.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool language = CacheHelper.getData(key: 'language') ?? false;
  late OtherProvider otherProvider;

  @override
  Widget build(BuildContext context) {
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(
            Icons.home,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (ctx, index) => Directionality(
                textDirection:
                    !language ? TextDirection.ltr : TextDirection.rtl,
                child: Dismissible(
                  key: Key(notifications[index].id),
                  onDismissed: (direction) async {
                    otherProvider.deleteNotification(
                        notifications[index].id, notifications[index]);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.delete),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    width: sizeFromWidth(context, 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                language ? notifications[index].data.titleEN : notifications[index].data.titleAR,
                                textDirection: language
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                              Text(
                                language ? notifications[index].data.bodyEN : notifications[index].data.bodyAR,
                                textDirection: language
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                              Text(
                                "30 / 11 / 2023",
                                textDirection: language
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_back, size: sizeFromHeight(context, 90), color: white),
                                  Text(
                                    otherProvider
                                        .getTexts("scroll delete")
                                        .toString(),
                                    textDirection: language
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: sizeFromWidth(context, 40),
                                      fontWeight: FontWeight.w500,
                                      color: white,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward, size: sizeFromHeight(context, 90), color: white),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: sizeFromHeight(context, 15),
                          width: sizeFromHeight(context, 15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            image: const DecorationImage(
                              image: AssetImage("assets/images/logo2.jpeg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
