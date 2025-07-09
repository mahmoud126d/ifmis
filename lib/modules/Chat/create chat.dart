// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'chats room.dart';

class CreateChat extends StatefulWidget {
  int categoryChatNumber;

  CreateChat(this.categoryChatNumber, {Key? key}) : super(key: key);

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameAR = TextEditingController();
  final TextEditingController nameEN = TextEditingController();
  final TextEditingController number = TextEditingController();
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            navigateAndFinish(context, ChatsRoom(widget.categoryChatNumber));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: sizeFromWidth(context, 1),
          height: sizeFromHeight(context, 1, hasAppBar: true),
          child: Form(
            key: formKey,
            child: Directionality(
              textDirection: language ? TextDirection.ltr : TextDirection.rtl,
              child: Column(
                children: [
                  textFormField(
                    controller: nameAR,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return language ? 'Chat name is required with arabic' : 'يجب إدخال اسم المحادثة بالعربى';
                      }
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider.getTexts('chat name ar').toString(),
                  ),
                  textFormField(
                    controller: nameEN,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return language ? 'Chat name is required with english' : 'يجب إدخال اسم المحادثة بالإنجليزى';
                      }
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider.getTexts('chat name en').toString(),
                  ),
                  textFormField(
                    controller: number,
                    type: TextInputType.number,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return language ? 'You must enter the number of users in the conversation' : 'يجب إدخال عدد المستخدمين بالمحادثة';
                      }
                      return null;
                    },
                    fromLTR: language,
                    hint: otherProvider.getTexts('chat numbers').toString(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            otherProvider.getTexts('chat image').toString(),
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                                () {
                              chatProvider.selectChatImage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 10)),
                  if (!chatProvider.isLoading)
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: textButton(
                              context,
                              otherProvider.getTexts('create chat').toString(),
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                                  () async {
                                if (formKey.currentState!.validate()) {
                                  chatProvider.createChat(
                                    widget.categoryChatNumber.toString(),
                                    number.text.trim(),
                                    nameAR.text.trim(),
                                    nameEN.text.trim(),
                                  ).then((value){
                                    number.clear();
                                    nameAR.clear();
                                    nameEN.clear();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (chatProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(lightGrey, primaryColor, context),
                    ),
                  const Spacer(),
                  bottomScaffoldWidget(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
