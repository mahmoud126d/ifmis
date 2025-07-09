
import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import 'log%20in.dart';
import 'package:provider/provider.dart';

import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController name = TextEditingController();
  late UserProvider userProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const LogIn());
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Directionality(
              textDirection: language ? TextDirection.ltr : TextDirection.rtl,
              child: Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: sizeFromHeight(context, 20)),
                    Container(
                      margin: EdgeInsets.only(
                          right: language ? 0 : 20, left: language ? 20 : 0),
                      child: Text(
                        otherProvider.getTexts('forget password title').toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: primaryColor),
                      ),
                    ),
                    SizedBox(height: sizeFromHeight(context, 90)),
                    Container(
                      margin: EdgeInsets.only(
                          right: language ? 0 : 20, left: language ? 20 : 0),
                      child: Text(
                        otherProvider.getTexts('forget password text').toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: darkGrey,
                          height: 0.2,
                        ),
                      ),
                    ),
                    SizedBox(height: sizeFromHeight(context, 50)),
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
                    ),
                    textFormField(
                      controller: name,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          if (language) {
                            return 'You must enter the name registered with your account';
                          }
                          return 'يجب إدخال الإسم المسجل بحسابك';
                        }
                        return null;
                      },
                      hint: otherProvider.getTexts('enter name in account').toString(),
                      fromLTR: language,
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
                      hint: otherProvider.getTexts('enter new password').toString(),
                      fromLTR: language,
                    ),
                    textFormField(
                      controller: newPassword,
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
                      hint: otherProvider.getTexts('enter confirm password').toString(),
                      fromLTR: language,
                    ),
                    if (!userProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                otherProvider.getTexts('update password').toString(),
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                    () {
                                  if (password.text != newPassword.text) {
                                    showToast(
                                        text: otherProvider.getTexts('ensure password match').toString(),
                                        state: ToastStates.WARNING);
                                  } else if (formKey.currentState!.validate()) {
                                    userProvider.checkExistAccount(
                                      email.text.trim(),
                                      password.text.trim(),
                                      newPassword.text.trim(),
                                      name.text.trim(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
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
