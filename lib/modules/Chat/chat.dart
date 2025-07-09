// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'Messages.dart';
import 'chats room.dart';
import 'newMessage.dart';

class Chat extends StatefulWidget {
  String chatName;
  String pageName;
  int chatId;
  int categoryChatNumber;

  Chat(this.chatName, this.pageName,this.chatId, this.categoryChatNumber, {Key? key})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  void endChat(String endFrom) async {
    String name = CacheHelper.getData(key: 'name');
    Provider.of<ChatProvider>(context, listen: false)
        .userLeaveChat(widget.chatId);
    Provider.of<ChatProvider>(context, listen: false)
        .sendMessage(widget.chatId.toString(), '$name\n${language ? 'left chat' : 'غادر الدردشة'}', 'message');
    if (endFrom == 'inApp' && widget.pageName == 'chat') {
      navigateAndFinish(context, ChatsRoom(widget.categoryChatNumber));
    }
    if (endFrom == 'inApp' && widget.pageName != 'chat') {
      navigatePop(context);
    }
  }

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).getMessages(widget.chatId.toString());
    Provider.of<ChatProvider>(context, listen: false).setStream(widget.chatId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        endChat('outApp');
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: textWidget(
            widget.chatName,
            null,
            null,
            white,
            sizeFromWidth(context, 25),
            FontWeight.w500,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              chatProvider.getUserChat(widget.chatId.toString());
              scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.people_alt, color: white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                endChat('inApp');
              },
              icon: Icon(Icons.arrow_forward, color: white),
            ),
          ],
        ),
        drawer: SizedBox(
          width: sizeFromWidth(context, 5),
          child: Drawer(
            backgroundColor: primaryColor,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (Provider.of<ChatProvider>(context, listen: false)
                    .userChat
                    .isEmpty) {
                  return const Center();
                }
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundColor: scaffoldColor,
                    radius: sizeFromWidth(context, 13),
                    backgroundImage: chatProvider.userChat[index].image != ''
                        ? NetworkImage(chatProvider.userChat[index].image)
                        : null,
                  ),
                );
              },
              itemCount: Provider.of<ChatProvider>(context).userChat.length,
            ),
          ),
        ),
        body: Container(
          height: sizeFromHeight(context, 1, hasAppBar: true),
          width: sizeFromWidth(context, 1),
          color: white,
          child: Column(
            children: [
              Expanded(child: Messages(widget.chatId.toString())),
              NewMessages(widget.chatId.toString()),
              bottomScaffoldWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}
