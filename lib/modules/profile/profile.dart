// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:ifmis/modules/profile/report.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/cash_helper.dart';
import '../../providers/chat provider.dart';
import '../../providers/other provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

import '../../shared/const.dart';
import '../home/home.dart';
import 'edit profile.dart';

class Profile extends StatefulWidget {
  String token;
  String page;
  String chatID;
  bool isChatAdmin;
  bool isUserBlocked;
  bool isNewAccount;

  Profile(this.token, this.page, this.isChatAdmin, this.isUserBlocked,
      this.chatID, this.isNewAccount,
      {Key? key})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserProvider userProvider;
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;
  TextEditingController confirmDelete = TextEditingController();

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      language ? 'Back' : 'رجوع',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigatePop(context);
      },
    );
    Widget continueButton = textButton(
      context,
      language ? 'Delete' : 'حذف',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        if (confirmDelete.text.trim() == CacheHelper.getData(key: 'password')) {
          Provider.of<UserProvider>(context, listen: false)
              .deleteAccount(context);
          confirmDelete.clear();
        } else {
          showToast(
              text: language ? 'Wrong Password' : 'خطأ فى كلمة سر',
              state: ToastStates.ERROR);
          confirmDelete.clear();
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        language
            ? 'Are you sure you want to delete your account ?'
            : 'هل أنت متأكد من حذف حسابك ؟',
        null,
        TextAlign.end,
        black,
        sizeFromWidth(context, 25),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textFormField(
            controller: confirmDelete,
            type: TextInputType.text,
            validate: (value) {
              return null;
            },
            fromLTR: language,
            isExpanded: true,
            hint: language ? 'Enter your password' : 'أدخل كلمة السر الخاصة بك',
          ),
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
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

  dialogCompleteProfile(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: primaryColor,
      title: textWidget(
        language
            ? 'You must enter your information to browse app'
            : 'يجب عليك إدخال المعلومات الخاصة بك لتصفح التطبيق',
        null,
        TextAlign.center,
        white,
        sizeFromWidth(context, 20),
        FontWeight.bold,
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    Timer(
      const Duration(seconds: 2),
      () async {
        if (widget.isNewAccount) {
          dialogCompleteProfile(context);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    userProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: widget.page == 'chat'
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  navigatePop(context);
                },
              )
            : IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  if (userModel.toMap().containsValue('')) {
                    dialogCompleteProfile(context);
                  } else {
                    navigateAndFinish(context, const Home());
                  }
                },
              ),
        actions: [
          if (token == widget.token && widget.page != 'chat')
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showAlertDialog(context);
              },
            ),
        ],
      ),
      body: ConditionalBuilder(
        condition: !userProvider.isLoading,
        builder: (context) {
          return SizedBox(
            width: sizeFromWidth(context, 1),
            height: sizeFromHeight(context, 1, hasAppBar: true),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                            height:
                                sizeFromHeight(context, 90, hasAppBar: true)),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: sizeFromWidth(context, 1),
                              height: sizeFromHeight(context, 5),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: primaryColor),
                                image: userModel.countryImage != ''
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            userModel.countryImage),
                                        fit: BoxFit.fill,
                                      )
                                    : null,
                              ),
                              alignment: Alignment.bottomRight,
                            ),
                            Positioned(
                              right: 20,
                              top: sizeFromHeight(context, 8),
                              child: Row(
                                children: [
                                  if (token == widget.token &&
                                      widget.page != 'chat')
                                    InkWell(
                                      onTap: () {
                                        userProvider.changeUserImage(
                                            context, token);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            textWidget(
                                              otherProvider
                                                  .getTexts('change your image')
                                                  .toString(),
                                              null,
                                              null,
                                              black,
                                              sizeFromWidth(context, 30),
                                              FontWeight.bold,
                                            ),
                                            Icon(Icons.camera_alt_outlined,
                                                color: black)
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 3),
                                  CircleAvatar(
                                    radius: sizeFromHeight(context, 15),
                                    backgroundColor: white,
                                    child: CircleAvatar(
                                      radius: sizeFromHeight(context, 16),
                                      backgroundColor: primaryColor,
                                      backgroundImage: userModel.image != ''
                                          ? NetworkImage(userModel.image)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (token == widget.token && widget.page != 'chat')
                              Positioned(
                                left: 20,
                                top: 10,
                                child: InkWell(
                                  onTap: () {
                                    userProvider.changeUserCountryImage(
                                        context, token);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        textWidget(
                                          otherProvider
                                              .getTexts('change bg image')
                                              .toString(),
                                          null,
                                          null,
                                          black,
                                          sizeFromWidth(context, 30),
                                          FontWeight.bold,
                                        ),
                                        Icon(Icons.camera_alt_outlined,
                                            color: black)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: sizeFromHeight(context, 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: textWidget(
                                "${otherProvider.getTexts('serial').toString()}: ${CacheHelper.getData(key: 'id')}",
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 25),
                                FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: textWidget(
                                userModel.name,
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 25),
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (token != widget.token &&
                                id.toString() != widget.token)
                              InkWell(
                                onTap: () {
                                  navigateTo(context, Report(widget.token));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: primaryColor,
                                  ),
                                  child: textWidget(
                                    otherProvider.getTexts('report').toString(),
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (token != widget.token &&
                                id.toString() != widget.token &&
                                widget.isChatAdmin)
                              InkWell(
                                onTap: () {
                                  chatProvider.blockUser(
                                      widget.chatID, widget.token);
                                  widget.isUserBlocked = !widget.isUserBlocked;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: primaryColor,
                                  ),
                                  child: textWidget(
                                    widget.isUserBlocked
                                        ? otherProvider
                                            .getTexts('un block')
                                            .toString()
                                        : otherProvider
                                            .getTexts('block')
                                            .toString(),
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Container(
                          width: sizeFromWidth(context, 1),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              if (token == widget.token &&
                                  widget.page != 'chat')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          navigateTo(
                                              context,
                                              EditProfile(
                                                  token,
                                                  widget.isChatAdmin,
                                                  widget.isUserBlocked,
                                                  widget.chatID));
                                        },
                                        child: textWidget(
                                          otherProvider
                                              .getTexts('edit')
                                              .toString(),
                                          null,
                                          null,
                                          primaryColor,
                                          sizeFromWidth(context, 20),
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.info, color: white),
                                  ],
                                ),
                              textWidget(
                                userModel.bio,
                                null,
                                TextAlign.end,
                                white,
                                sizeFromWidth(context, 25),
                                FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                height: sizeFromHeight(context, 8),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.work, color: white),
                                    textWidget(
                                      userModel.position,
                                      null,
                                      TextAlign.end,
                                      white,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: sizeFromHeight(context, 8),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.location_on, color: white),
                                    textWidget(
                                      userModel.country,
                                      null,
                                      TextAlign.center,
                                      white,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.email, color: white),
                                        Expanded(
                                          child: textWidget(
                                            token == widget.token
                                                ? userModel.email
                                                : language
                                                    ? 'This private data belong to this user'
                                                    : 'بيانات خاصة بصاحب الحساب',
                                            null,
                                            TextAlign.end,
                                            white,
                                            sizeFromWidth(context, 30),
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.call, color: white),
                                        Expanded(
                                          child: textWidget(
                                            token == widget.token
                                                ? userModel.phone
                                                : language
                                                    ? 'This private data belong to this user'
                                                    : 'بيانات خاصة بصاحب الحساب',
                                            null,
                                            TextAlign.end,
                                            white,
                                            sizeFromWidth(context, 30),
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: sizeFromHeight(context, 10),
                              width: sizeFromWidth(context, 5),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                      userModel.type == 'ذكر'
                                          ? Icons.male
                                          : Icons.female,
                                      color: white),
                                  textWidget(
                                    userModel.type,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.bold,
                                    1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: sizeFromHeight(context, 10),
                              width: sizeFromWidth(context, 5),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.calendar_today, color: white),
                                  textWidget(
                                    userModel.age,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 20),
                                    FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: sizeFromHeight(context, 10),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        textWidget(
                                          otherProvider
                                              .getTexts('accounts')
                                              .toString(),
                                          null,
                                          TextAlign.end,
                                          white,
                                          sizeFromWidth(context, 20),
                                          FontWeight.bold,
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(Icons.manage_accounts_sharp,
                                            color: white),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            dynamic link =
                                                Uri.parse(userModel.facebook);
                                            try {
                                              await launchUrl(link,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              showToast(
                                                  text: language
                                                      ? 'There are error in link'
                                                      : 'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                  state: ToastStates.ERROR);
                                            }
                                          },
                                          child: Icon(FontAwesomeIcons.facebook,
                                              color: white),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            dynamic link =
                                                Uri.parse(userModel.snapchat);
                                            try {
                                              await launchUrl(link,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              showToast(
                                                  text: language
                                                      ? 'There are error in link'
                                                      : 'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                  state: ToastStates.ERROR);
                                            }
                                          },
                                          child: Icon(FontAwesomeIcons.snapchat,
                                              color: white),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            dynamic link =
                                                Uri.parse(userModel.tiktok);
                                            try {
                                              await launchUrl(link,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              showToast(
                                                  text: language
                                                      ? 'There are error in link'
                                                      : 'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                  state: ToastStates.ERROR);
                                            }
                                          },
                                          child: Icon(FontAwesomeIcons.tiktok,
                                              color: white),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            dynamic link =
                                                Uri.parse(userModel.instagram);
                                            try {
                                              await launchUrl(link,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              showToast(
                                                  text: language
                                                      ? 'There are error in link'
                                                      : 'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                  state: ToastStates.ERROR);
                                            }
                                          },
                                          child: Icon(
                                              FontAwesomeIcons.instagram,
                                              color: white),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            dynamic link =
                                                Uri.parse(userModel.twitter);
                                            try {
                                              await launchUrl(link,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              showToast(
                                                  text: language
                                                      ? 'There are error in link'
                                                      : 'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                  state: ToastStates.ERROR);
                                            }
                                          },
                                          child: Icon(FontAwesomeIcons.twitter,
                                              color: white),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            dynamic link = Uri.parse(
                                                userModel.placeOfWork);
                                            try {
                                              await launchUrl(link,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              showToast(
                                                  text: language
                                                      ? 'There are error in link'
                                                      : 'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                  state: ToastStates.ERROR);
                                            }
                                          },
                                          child: Icon(FontAwesomeIcons.earth,
                                              color: white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottomScaffoldWidget(context),
              ],
            ),
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }
}
