// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../models/authenticate/login%20model.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import 'forget%20password.dart';
import 'sign%20up.dart';
import 'package:provider/provider.dart';

import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
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
                        otherProvider.getTexts('welcome').toString(),
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
                        otherProvider.getTexts('welcome text').toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    if (!userProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                otherProvider.getTexts('log in').toString(),
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () async {
                                  if (formKey.currentState!.validate()) {
                                    await userProvider.getUserFcmToken(
                                        email.text.trim(),
                                        password.text.trim());
                                    LoginModel loginModel = LoginModel(
                                      email: email.text.trim(),
                                      password: password.text.trim(),
                                      token: userProvider.token,
                                    );
                                    userProvider.userLogin(
                                        context, loginModel, 'login');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
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
                                otherProvider
                                    .getTexts('create account')
                                    .toString(),
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () {
                                  navigateAndFinish(context, const SignUP());
                                },
                              ),
                            ),
                          ],
                        ),
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
                                otherProvider
                                    .getTexts('forget password')
                                    .toString(),
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () {
                                  navigateAndFinish(
                                      context, const ForgetPassword());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    // if (!userProvider.isLoading)
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       margin: const EdgeInsets.only(right: 20, top: 10, left: 20),
                    //       width: sizeFromWidth(context, 3),
                    //       height: 1,
                    //       color: primaryColor,
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.only(top: 10),
                    //       child: textWidget(
                    //         otherProvider
                    //             .getTexts('or register')
                    //             .toString(),
                    //         null,
                    //         null,
                    //         primaryColor,
                    //         sizeFromWidth(context, 30),
                    //         FontWeight.bold,
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
                    //       width: sizeFromWidth(context, 3),
                    //       height: 1,
                    //       color: primaryColor,
                    //     ),
                    //   ],
                    // ),
                    // if (!userProvider.isLoading)
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //         child: InkWell(
                    //           onTap: (){
                    //             userProvider.googleSignUp(context);
                    //           },
                    //           child:  Container(
                    //             padding: const EdgeInsets.symmetric(vertical: 10),
                    //             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //             decoration: BoxDecoration(
                    //               color: primaryColor,
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 textWidget(
                    //                   otherProvider
                    //                       .getTexts('google')
                    //                       .toString(),
                    //                   null,
                    //                   null,
                    //                   white,
                    //                   sizeFromWidth(context, 20),
                    //                   FontWeight.bold,
                    //                 ),
                    //                 Icon(FontAwesomeIcons.google, color: white),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
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
