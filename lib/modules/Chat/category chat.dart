import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat%20provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';
import 'chats room.dart';

class CategoryChat extends StatefulWidget {
  const CategoryChat({Key? key}) : super(key: key);

  @override
  State<CategoryChat> createState() => _CategoryChatState();
}

class _CategoryChatState extends State<CategoryChat> {
  late ChatProvider chatProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).getCategoryChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
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
      body: Directionality(
        textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: chatProvider.categoryChat.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () async {
                      navigateAndFinish(context,
                          ChatsRoom(chatProvider.categoryChat[index].id));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      width: sizeFromWidth(context, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF7f0e14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              language ? chatProvider.categoryChat[index].name.en : chatProvider.categoryChat[index].name.ar,
                              textDirection: language ? TextDirection.ltr : TextDirection.rtl,
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
                            height: sizeFromWidth(context, 7),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(chatProvider.categoryChat[index].image),
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
      ),
    );
  }
}
