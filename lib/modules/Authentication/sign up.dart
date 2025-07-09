// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import 'log%20in.dart';
import '../../providers/user%20provider.dart';
import '../../shared/Components.dart';
import 'package:provider/provider.dart';
import '../../models/authenticate/register model.dart';
import '../../shared/Style.dart';

class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController confirmCode = TextEditingController();
  late UserProvider userProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getRegisterNumber();
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
      body: Directionality(
        textDirection: language ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: sizeFromHeight(context, 20)),
                    Container(
                      margin: EdgeInsets.only(
                          right: language ? 0 : 20, left: language ? 20 : 0),
                      child: Text(
                        otherProvider.getTexts('sign up new').toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: primaryColor),
                      ),
                    ),
                    SizedBox(height: sizeFromHeight(context, 90)),
                    Container(
                      margin: EdgeInsets.only(
                          right: language ? 0 : 20, left: language ? 20 : 0),
                      child: Text(
                        otherProvider.getTexts('sign up new text').toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: darkGrey,
                              height: 0.2,
                            ),
                      ),
                    ),
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
                      suffixIcon: Icon(Icons.person, color: primaryColor),
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
                      suffixIcon: Icon(Icons.email, color: primaryColor),
                    ),
                    textFormField(
                      controller: password,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          if (language) {
                            return 'Password week';
                          }
                          return 'كلمة السر ضعيفة';
                        }
                        return null;
                      },
                      hint: otherProvider.getTexts('enter password').toString(),
                      fromLTR: language,
                      isSecure: userProvider.isSecure,
                      suffixIcon: IconButton(
                        onPressed: () {
                          userProvider.changeIcon();
                        },
                        icon: Icon(userProvider.iconData, color: primaryColor),
                      ),
                    ),
                    if (userProvider.randomString.isNotEmpty)
                      Container(
                        width: sizeFromWidth(context, 1),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightGrey,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            textWidget(
                              language
                                  ? userProvider.randomString[0]
                                  : userProvider.randomString[3],
                              null,
                              null,
                              primaryColor,
                              sizeFromWidth(context, 10),
                              FontWeight.bold,
                            ),
                            textWidget(
                              language
                                  ? userProvider.randomString[1]
                                  : userProvider.randomString[2],
                              null,
                              null,
                              primaryColor,
                              sizeFromWidth(context, 10),
                              FontWeight.bold,
                            ),
                            textWidget(
                              language
                                  ? userProvider.randomString[2]
                                  : userProvider.randomString[1],
                              null,
                              null,
                              primaryColor,
                              sizeFromWidth(context, 10),
                              FontWeight.bold,
                            ),
                            textWidget(
                              language
                                  ? userProvider.randomString[3]
                                  : userProvider.randomString[0],
                              null,
                              null,
                              primaryColor,
                              sizeFromWidth(context, 10),
                              FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    textFormField(
                      controller: confirmCode,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          if (language) {
                            return 'Enter Confirm code';
                          }
                          return 'أدخل رمز التأكيد';
                        }
                        return null;
                      },
                      hint: otherProvider.getTexts('confirm code').toString(),
                      fromLTR: language,
                      suffixIcon: Icon(Icons.code, color: primaryColor)
                    ),
                    if (!userProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: textButton(
                          context,
                          otherProvider.getTexts('create account').toString(),
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () async {
                            if (userProvider.randomString !=
                                confirmCode.text.trim()) {
                              showToast(
                                  text: language
                                      ? "Enter Right Code"
                                      : "أدخل الكود صحيح",
                                  state: ToastStates.ERROR);
                            } else if (formKey.currentState!.validate()) {
                              await userProvider.getUserFcmToken(
                                  email.text.trim(), password.text.trim());
                              RegisterModel userModel = RegisterModel(
                                userName: userName.text.trim(),
                                email: email.text.trim(),
                                password: password.text.trim(),
                                token: userProvider.token,
                              );
                              userProvider.userRegister(context, userModel);
                            }
                          },
                        ),
                      ),
                    if (!userProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: textButton(
                          context,
                          otherProvider.getTexts('log in').toString(),
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            navigateAndFinish(context, const LogIn());
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
      ),
    );
  }
}
