// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sport services provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class SportServicesComments extends StatefulWidget {
  int serviceID;
  SportServicesComments(this.serviceID, {Key? key}) : super(key: key);

  @override
  State<SportServicesComments> createState() => _SportServicesCommentsState();
}

class _SportServicesCommentsState extends State<SportServicesComments> {
  TextEditingController comment = TextEditingController();
  late SportServicesProvider sportServicesProvider;

  @override
  void initState() {
    Provider.of<SportServicesProvider>(context, listen: false)
        .getComments(widget.serviceID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sportServicesProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          'التعليقات',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sizeFromWidth(context, 20),
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigatePop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        actions: [
          Center(
            child: Text(
              sportServicesProvider.comments.length.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: sizeFromWidth(context, 20),
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SizedBox(
        width: sizeFromWidth(context, 1),
        height: sizeFromHeight(context, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: sportServicesProvider.comments.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: materialWidget(
                              context,
                              null,
                              sizeFromWidth(context, 1),
                              15,
                              "",
                              BoxFit.fill,
                              [
                                textWidget(
                                  sportServicesProvider.comments[index].user.name,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  sportServicesProvider.comments[index].comment,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                ),
                              ],
                              MainAxisAlignment.start,
                              false,
                              10,
                              lightGrey,
                                  () {},
                              CrossAxisAlignment.end),
                        ),
                        const SizedBox(width: 5),
                        storyShape(
                          context,
                          lightGrey,
                          sportServicesProvider.comments[index].user.image != ''
                              ? NetworkImage(sportServicesProvider
                              .comments[index].user.image)
                              : null,
                          30,
                          33,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    height: sizeFromHeight(context, 10, hasAppBar: true),
                    child: textFormField(
                      controller: comment,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      hint: 'اكتب تعليق...',
                      isExpanded: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        if (comment.text == '') {
                          showToast(
                              text: 'يجب كتابة تعليق',
                              state: ToastStates.ERROR);
                        } else {
                          sportServicesProvider
                              .addComment(widget.serviceID, comment.text.trim())
                              .then((value) {
                            comment.clear();
                            sportServicesProvider.getComments(widget.serviceID);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send_sharp,
                        size: sizeFromWidth(context, 15),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
