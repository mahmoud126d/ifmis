// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat/chat module.dart';
import '../../providers/chat provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'chats room.dart';

class EditChat extends StatefulWidget {
  int categoryChatNumber;
  ChatModel chatModel;
  EditChat(this.categoryChatNumber, this.chatModel, {Key? key}) : super(key: key);

  @override
  State<EditChat> createState() => _EditChatState();
}

class _EditChatState extends State<EditChat> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController number = TextEditingController();
  late ChatProvider chatProvider;

  @override
  void initState() {
    //name.text = widget.chatModel.name;
    number.text = widget.chatModel.users;
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
            child: Column(
              children: [
                textFormField(
                  controller: name,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال اسم المحادثة';
                    }
                    return null;
                  },
                  hint: 'أدخل اسم المحادثة',
                ),
                textFormField(
                  controller: number,
                  type: TextInputType.number,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال عدد المستخدمين بالمحادثة';
                    }
                    return null;
                  },
                  hint: 'أدخل عدد مستخدمين المحادثة',
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'تعديل صورة المحادثة',
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
                            'تعديل المحادثة',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                                () async {
                              if (formKey.currentState!.validate()) {
                                chatProvider.userEditChat(
                                  widget.chatModel.id.toString(),
                                  name.text.trim(),
                                  number.text.trim(),
                                  widget.categoryChatNumber.toString(),
                                ).then((value){
                                  number.clear();
                                  name.clear();
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
    );
  }
}
