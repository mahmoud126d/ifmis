import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/ifmis/member.dart';
import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class MemberDetails extends StatefulWidget {
  MemberDetailsModel member;

  MemberDetails(this.member, {Key? key}) : super(key: key);

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: sizeFromWidth(context, 1),
                      height: sizeFromHeight(context, 4),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(widget.member.countryImage),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      bottom: -sizeFromHeight(context, 13),
                      child: CircleAvatar(
                        radius: sizeFromHeight(context, 9.5),
                        backgroundColor: primaryColor,
                        child: CircleAvatar(
                          radius: sizeFromHeight(context, 10),
                          backgroundColor: primaryColor,
                          backgroundImage: NetworkImage(widget.member.image),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizeFromHeight(context, 12)),
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
                      textWidget(
                        language ? widget.member.bio.en : widget.member.bio.ar,
                        language ? TextDirection.ltr : TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ],
                  ),
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
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.whatsapp, color: white),
                      textWidget(
                        ' WhatsApp',
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          String number = widget.member.whats;
                          var url = Uri.parse('whatsapp://send?phone=$number');
                          await launchUrl(url,
                              mode: LaunchMode.externalNonBrowserApplication);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: textWidget(
                            language ? 'Contact' : 'اضغط هنا للتواصل',
                            null,
                            null,
                            primaryColor,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: sizeFromWidth(context, 1),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: Row(
                    mainAxisAlignment: language ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      textWidget(
                        language ? "Name: ${widget.member.name.en}" : "الأسم: ${widget.member.name.ar}",
                        language ? TextDirection.ltr : TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: sizeFromWidth(context, 1),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: Column(
                    crossAxisAlignment: language ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      textWidget(
                        language ? "Job: ${widget.member.job.en}" : "الوظيفة: ${widget.member.job.ar}",
                        language ? TextDirection.ltr : TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: sizeFromWidth(context, 1),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: Row(
                    mainAxisAlignment: language ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      textWidget(
                        language ? "Country: ${widget.member.countryName.en}" : "الدولة: ${widget.member.countryName.ar}",
                        language ? TextDirection.ltr : TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
