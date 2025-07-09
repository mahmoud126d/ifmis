// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class EditProfile extends StatefulWidget {
  String token;
  String chatID;
  bool isChatAdmin;
  bool isUserBlocked;

  EditProfile(this.token, this.isChatAdmin, this.isUserBlocked, this.chatID,
      {Key? key})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController kind = TextEditingController();
  final TextEditingController about = TextEditingController();
  final TextEditingController facebook = TextEditingController();
  final TextEditingController website = TextEditingController();
  final TextEditingController instagram = TextEditingController();
  final TextEditingController twitter = TextEditingController();
  final TextEditingController snapchat = TextEditingController();
  final TextEditingController tiktok = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController position = TextEditingController();
  late UserProvider userProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    userName.text = userModel.name;
    email.text = userModel.email;
    phone.text = userModel.phone;
    country.text = userModel.country;
    kind.text = userModel.type;
    about.text = userModel.bio;
    facebook.text = userModel.facebook;
    instagram.text = userModel.instagram;
    twitter.text = userModel.twitter;
    tiktok.text = userModel.tiktok;
    snapchat.text = userModel.snapchat;
    age.text = userModel.age;
    position.text = userModel.position;
    website.text = userModel.placeOfWork;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: sizeFromHeight(context, 50)),
                  textFormField(
                    controller: userName,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty ||
                          value.length < 10 ||
                          value.length > 20) {
                        if (language) {
                          return 'Username must between 10 to 20 character';
                        }
                        return 'اسم المستخدم يجب أن يكون بين 10 إلى 20 حرف';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('enter name').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: email,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        if (language) {
                          return 'Email must contain @';
                        }
                        return 'يجب أن يحتوى الايميل على @';
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('enter email').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: phone,
                    type: TextInputType.number,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter phone').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: country,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter location').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: kind,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.length > 4) {
                        return language
                            ? "it must less than 5 characters"
                            : "يجب أن تكون أقل من 5 حروف";
                      }
                      return null;
                    },
                    hint: otherProvider.getTexts('enter gender').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: about,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter bio').toString(),
                    fromLTR: language,
                    textAlignVertical: TextAlignVertical.bottom,
                    maxLines: 4,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: age,
                    type: TextInputType.number,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter age').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: position,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter position').toString(),
                    fromLTR: language,
                    suffixIcon: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: sizeFromHeight(context, 30),
                    ),
                  ),
                  textFormField(
                    controller: website,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter website').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    controller: facebook,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter facebook').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    controller: instagram,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter instagram').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    controller: twitter,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter twitter').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    controller: snapchat,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter snapchat').toString(),
                    fromLTR: language,
                  ),
                  textFormField(
                    controller: tiktok,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: otherProvider.getTexts('enter tiktok').toString(),
                    fromLTR: language,
                  ),
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: textButton(
                        context,
                        otherProvider
                            .getTexts('update profile information')
                            .toString(),
                        primaryColor,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                        () {
                          if (userName.text.isNotEmpty &&
                              (userName.text.length < 10 ||
                                  userName.text.length > 25)) {
                            showToast(
                                text: language
                                    ? 'Username must between 10 to 25 character'
                                    : 'اسم المستخدم يجب أن يكون بين 10 إلى 25 حرف',
                                state: ToastStates.ERROR);
                          } else if (formKey.currentState!.validate()) {
                            userProvider.updateUserData(
                              context,
                              widget.token,
                              userName.text.trim(),
                              email.text.trim(),
                              phone.text.trim(),
                              kind.text.trim(),
                              country.text.trim(),
                              about.text.trim(),
                              facebook.text.trim(),
                              instagram.text.trim(),
                              twitter.text.trim(),
                              snapchat.text.trim(),
                              tiktok.text.trim(),
                              age.text.trim(),
                              position.text.trim(),
                              website.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                  if (userProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(
                          lightGrey, primaryColor, context),
                    ),
                ],
              ),
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
