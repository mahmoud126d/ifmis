// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'category chat.dart';
import 'chat.dart';
import 'create chat.dart';
import 'edit chat.dart';

class ChatsRoom extends StatefulWidget {
  int categoryChatNumber;

  ChatsRoom(this.categoryChatNumber, {Key? key}) : super(key: key);

  @override
  State<ChatsRoom> createState() => _ChatsRoomState();
}

class _ChatsRoomState extends State<ChatsRoom> {
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .getChats(widget.categoryChatNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = CacheHelper.getData(key: 'name');
    var id = CacheHelper.getData(key: 'id');
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
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
            navigateAndFinish(context, const CategoryChat());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              navigateAndFinish(context, CreateChat(widget.categoryChatNumber));
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Container(
              width: sizeFromWidth(context, 1),
              height: sizeFromHeight(context, 11, hasAppBar: true),
              color: primaryColor,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: textFormField(
                  controller: chatProvider.search,
                  type: TextInputType.text,
                  validate: (value) {
                    return null;
                  },
                  onChange: (value) {
                    if (chatProvider.search.text == '') {
                      chatProvider.getChats(widget.categoryChatNumber);
                    }
                    chatProvider.searchAboutChat();
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
                itemCount: chatProvider.chats.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () async {
                      chatProvider.checkIsUserBlocked(
                          chatProvider.chats[index].id.toString(), id.toString());
                      if (chatProvider.chats[index].users ==
                          chatProvider.chats[index].usersInChat) {
                        showToast(
                            text: language ? 'This room is full of users' : 'هذه الغرفة ممتلئة بالمستخدمين',
                            state: ToastStates.ERROR);
                      } else if (chatProvider.userBlocked) {
                        showToast(
                            text: language ? 'You are banned from this conversation' : 'أنت محظور فى هذه المحادثة',
                            state: ToastStates.ERROR);
                        chatProvider.userBlocked = false;
                      } else {
                        chatProvider.userEnterChat(chatProvider.chats[index].id);
                        chatProvider.sendMessage(
                            chatProvider.chats[index].id.toString(),
                            '$name\n${language ? 'entered chat' : 'دخل الدردشة'}',
                            'message');
                        navigateAndFinish(
                          context,
                          Chat(
                            language ? chatProvider.chats[index].name.en : chatProvider.chats[index].name.ar,
                            'chat',
                            chatProvider.chats[index].id,
                            widget.categoryChatNumber,
                          ),
                        );
                      }
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
                          if (chatProvider.chats[index].chatAdmin ==
                              id.toString())
                            IconButton(
                              onPressed: () {
                                navigateAndFinish(context, EditChat(widget.categoryChatNumber, chatProvider.chats[index]));
                              },
                              icon: Icon(Icons.edit, color: white),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  language ? chatProvider.chats[index].name.en : chatProvider.chats[index].name.ar,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                                Text(
                                  '${otherProvider.getTexts('chat users')}: ${chatProvider.chats[index].users}',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                                Text(
                                  '${otherProvider.getTexts('chat users current')}: ${chatProvider.chats[index].usersInChat}',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: sizeFromWidth(context, 6),
                            height: sizeFromWidth(context, 6),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image:
                                NetworkImage(chatProvider.chats[index].image),
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
