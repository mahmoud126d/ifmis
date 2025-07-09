// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/chat/message model.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../profile/profile.dart';
import '../show image/show image.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../show video/show video.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  MessageModel messageModel;

  MessageBubble(this.messageModel, this.isMe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: Column(
        children: [
          if (messageModel.image != '')
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(
                          context,
                          messageModel.user.name,
                          messageModel.user.image,
                          messageModel.user.country,
                          messageModel.user.id.toString(),
                          messageModel.chatID,
                          messageModel.chatMessage.messageAdmin);
                    },
                    child: storyShape(
                      context,
                      white,
                      messageModel.user.image == ''
                          ? null
                          : NetworkImage(messageModel.user.image),
                      40,
                      35,
                    ),
                  ),
                if (isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Provider.of<ChatProvider>(context, listen: false)
                              .deleteMessage(messageModel.messageID.toString(),
                                  messageModel.chatID);
                        },
                        child: Icon(Icons.delete, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          var url = Uri.parse(messageModel.image);
                          var response = await http.get(url);
                          var bytes = response.bodyBytes;
                          var temp = await getTemporaryDirectory();
                          var path = '${temp.path}/image.jpg';
                          File(path).writeAsBytesSync(bytes);
                          await Share.shareXFiles([XFile(path)], text: messageModel.image);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        // onTap: () async {
                        //   await GallerySaver.saveImage(messageModel.image,
                        //           albumName: 'صور الإتحاد الدولى')
                        //       .then((value) {
                        //     if (value!) {
                        //       showToast(
                        //           text: 'تم حفظ الصورة بنجاح',
                        //           state: ToastStates.SUCCESS);
                        //     }
                        //   });
                        // },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                InkWell(
                  onTap: () {
                    navigateTo(context, ShowImage(messageModel.image));
                  },
                  child: Container(
                    width: sizeFromWidth(context, 2.8),
                    height: sizeFromWidth(context, 2.8),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: !isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(messageModel.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                ),
                if (!isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Provider.of<ChatProvider>(context, listen: false)
                              .deleteMessage(messageModel.messageID.toString(),
                                  messageModel.chatID);
                        },
                        child: Icon(Icons.delete, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          var url = Uri.parse(messageModel.image);
                          var response = await http.get(url);
                          var bytes = response.bodyBytes;
                          var temp = await getTemporaryDirectory();
                          var path = '${temp.path}/image.jpg';
                          File(path).writeAsBytesSync(bytes);
                          await Share.shareXFiles([XFile(path)], text: messageModel.image);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        // onTap: () async {
                        //   await GallerySaver.saveImage(messageModel.image,
                        //           albumName: 'صور الإتحاد الدولى')
                        //       .then((value) {
                        //     if (value!) {
                        //       showToast(
                        //           text: 'تم حفظ الصورة بنجاح',
                        //           state: ToastStates.SUCCESS);
                        //     }
                        //   });
                        // },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                if (isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(
                          context,
                          messageModel.user.name,
                          messageModel.user.image,
                          messageModel.user.country,
                          messageModel.user.id.toString(),
                          messageModel.chatID,
                          messageModel.chatMessage.messageAdmin);
                    },
                    child: storyShape(
                      context,
                      white,
                      messageModel.user.image == ''
                          ? null
                          : NetworkImage(messageModel.user.image),
                      40,
                      35,
                    ),
                  ),
              ],
            ),
          if (messageModel.message != '' &&
              !(messageModel.message.contains('https') ||
                  messageModel.message.contains('www') ||
                  messageModel.message.contains('http')) &&
              !(messageModel.message.contains('غادر الدردشة') ||
                  messageModel.message.contains('دخل الدردشة') ||
                  messageModel.message.contains('entered chat') ||
                  messageModel.message.contains('left chat')))
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(
                            context,
                            messageModel.user.name,
                            messageModel.user.image,
                            messageModel.user.country,
                            messageModel.user.id.toString(),
                            messageModel.chatID,
                            messageModel.chatMessage.messageAdmin);
                      },
                      child: storyShape(
                        context,
                        white,
                        messageModel.user.image == ''
                            ? null
                            : NetworkImage(messageModel.user.image),
                        40,
                        35,
                      ),
                    ),
                  if (isMe)
                    InkWell(
                      onTap: () async {
                        Provider.of<ChatProvider>(context, listen: false)
                            .deleteMessage(messageModel.messageID.toString(),
                                messageModel.chatID);
                      },
                      child: Icon(Icons.delete, color: primaryColor),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isMe ? darkGrey : lightGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: const Radius.circular(10),
                              bottomLeft: !isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                              bottomRight: isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: '${messageModel.message} \n',
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.normal,
                                    color: isMe ? white : petroleum,
                                  )),
                              TextSpan(
                                text: messageModel.date,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 45),
                                  fontWeight: FontWeight.normal,
                                  color: isMe ? white : petroleum,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(
                            context,
                            messageModel.user.name,
                            messageModel.user.image,
                            messageModel.user.country,
                            messageModel.user.id.toString(),
                            messageModel.chatID,
                            messageModel.chatMessage.messageAdmin);
                      },
                      child: storyShape(
                        context,
                        white,
                        messageModel.user.image == ''
                            ? null
                            : NetworkImage(messageModel.user.image),
                        40,
                        35,
                      ),
                    ),
                  SizedBox(width: sizeFromWidth(context, 80)),
                ],
              ),
            ),
          if (messageModel.message != '' &&
              (messageModel.message.contains('https') ||
                  messageModel.message.contains('www') ||
                  messageModel.message.contains('http')))
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(
                            context,
                            messageModel.user.name,
                            messageModel.user.image,
                            messageModel.user.country,
                            messageModel.user.id.toString(),
                            messageModel.chatID,
                            messageModel.chatMessage.messageAdmin);
                      },
                      child: storyShape(
                        context,
                        white,
                        messageModel.user.image == ''
                            ? null
                            : NetworkImage(messageModel.user.image),
                        40,
                        35,
                      ),
                    ),
                  if (isMe)
                    InkWell(
                      onTap: () async {
                        Provider.of<ChatProvider>(context, listen: false)
                            .deleteMessage(messageModel.messageID.toString(),
                                messageModel.chatID);
                      },
                      child: Icon(Icons.delete, color: primaryColor),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isMe ? darkGrey : lightGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: const Radius.circular(10),
                              bottomLeft: !isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                              bottomRight: isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  dynamic link =
                                      Uri.parse(messageModel.message);
                                  try {
                                    await launchUrl(link,
                                        mode: LaunchMode.inAppWebView);
                                  } catch (e) {
                                    showToast(
                                        text: 'there are error in link',
                                        state: ToastStates.ERROR);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '${messageModel.message} \n',
                                      style: TextStyle(
                                        fontSize: sizeFromWidth(context, 30),
                                        fontWeight: FontWeight.w500,
                                        color: isMe ? white : petroleum,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                messageModel.date,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 45),
                                  fontWeight: FontWeight.normal,
                                  color: isMe ? white : petroleum,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(
                            context,
                            messageModel.user.name,
                            messageModel.user.image,
                            messageModel.user.country,
                            messageModel.user.id.toString(),
                            messageModel.chatID,
                            messageModel.chatMessage.messageAdmin);
                      },
                      child: storyShape(
                        context,
                        white,
                        messageModel.user.image == ''
                            ? null
                            : NetworkImage(messageModel.user.image),
                        40,
                        35,
                      ),
                    ),
                  SizedBox(width: sizeFromWidth(context, 80)),
                ],
              ),
            ),
          if (messageModel.message != '' &&
              (messageModel.message.contains('غادر الدردشة') ||
                  messageModel.message.contains('دخل الدردشة') ||
                  messageModel.message.contains('entered chat') ||
                  messageModel.message.contains('left chat')))
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(children: [
                        TextSpan(
                            text: '${messageModel.message} \n',
                            style: TextStyle(
                              fontSize: sizeFromWidth(context, 30),
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            )),
                        TextSpan(
                          text: messageModel.date,
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 45),
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showAlertDialog(
                          context,
                          messageModel.user.name,
                          messageModel.user.image,
                          messageModel.user.country,
                          messageModel.user.id.toString(),
                          messageModel.chatID,
                          messageModel.chatMessage.messageAdmin);
                    },
                    child: storyShape(
                      context,
                      white,
                      messageModel.user.image == ''
                          ? null
                          : NetworkImage(messageModel.user.image),
                      40,
                      35,
                    ),
                  ),
                ],
              ),
            ),
          if (messageModel.video != '')
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(
                          context,
                          messageModel.user.name,
                          messageModel.user.image,
                          messageModel.user.country,
                          messageModel.user.id.toString(),
                          messageModel.chatID,
                          messageModel.chatMessage.messageAdmin);
                    },
                    child: storyShape(
                      context,
                      white,
                      messageModel.user.image == ''
                          ? null
                          : NetworkImage(messageModel.user.image),
                      40,
                      35,
                    ),
                  ),
                if (isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Provider.of<ChatProvider>(context, listen: false)
                              .deleteMessage(messageModel.messageID.toString(),
                                  messageModel.chatID);
                        },
                        child: Icon(Icons.delete, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          await Share.share(messageModel.video);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        // onTap: () async {
                        //   await GallerySaver.saveVideo(messageModel.video,
                        //           albumName: 'فيديوهات الإتحاد الدولى')
                        //       .then((value) {
                        //     if (value!) {
                        //       showToast(
                        //           text: language ? 'Video Saved' : 'تم حفظ الفيديو بنجاح',
                        //           state: ToastStates.SUCCESS);
                        //     }
                        //   });
                        // },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                InkWell(
                  onTap: () {
                    navigateTo(context, ShowVideo(messageModel.video));
                  },
                  child: Container(
                    width: sizeFromWidth(context, 2.8),
                    height: sizeFromWidth(context, 2.8),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: !isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                      ),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Icon(Icons.play_circle, color: white),
                  ),
                ),
                if (!isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Provider.of<ChatProvider>(context, listen: false)
                              .deleteMessage(messageModel.messageID.toString(),
                                  messageModel.chatID);
                        },
                        child: Icon(Icons.delete, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          await Share.share(messageModel.video);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        // onTap: () async {
                        //   await GallerySaver.saveVideo(messageModel.video,
                        //           albumName: 'فيديوهات الإتحاد الدولى')
                        //       .then((value) {
                        //     if (value!) {
                        //       showToast(
                        //           text: language ? 'Video Saved' : 'تم حفظ الفيديو بنجاح',
                        //           state: ToastStates.SUCCESS);
                        //     }
                        //   });
                        // },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                if (isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(
                          context,
                          messageModel.user.name,
                          messageModel.user.image,
                          messageModel.user.country,
                          messageModel.user.id.toString(),
                          messageModel.chatID,
                          messageModel.chatMessage.messageAdmin);
                    },
                    child: storyShape(
                      context,
                      white,
                      messageModel.user.image == ''
                          ? null
                          : NetworkImage(messageModel.user.image),
                      40,
                      35,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

showAlertDialog(
  BuildContext context,
  String name,
  String image,
  String country,
  String id,
  String chatID,
  var chatAdmin,
) {
  var chatProvider = Provider.of<ChatProvider>(context, listen: false);
  var userID = CacheHelper.getData(key: 'id');
  bool isChatAdmin = userID == chatAdmin;
  AlertDialog alert = AlertDialog(
    backgroundColor: primaryColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: sizeFromHeight(context, 20),
          backgroundColor: primaryColor,
          backgroundImage: image != '' ? NetworkImage(image) : null,
        ),
        textWidget(
          name,
          null,
          TextAlign.center,
          white,
          sizeFromWidth(context, 25),
          FontWeight.bold,
        ),
        textWidget(
          country,
          null,
          TextAlign.center,
          white,
          sizeFromWidth(context, 30),
          FontWeight.bold,
        ),
        textButton(
          context,
          'عرض الملف الشخصى',
          primaryColor,
          white,
          sizeFromWidth(context, 30),
          FontWeight.bold,
          () {
            Provider.of<UserProvider>(context, listen: false)
                .getDataOtherUser(context, id)
                .then((value) {
              chatProvider.checkIsUserBlocked(chatID, id);
              navigateTo(
                  context,
                  Profile(id, 'chat', isChatAdmin, chatProvider.userBlocked,
                      chatID, false));
            });
          },
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
