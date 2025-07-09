import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/talents/specific talent.dart';
import '../../network/cash_helper.dart';
import '../../providers/talent provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class TalentAddComment extends StatefulWidget {
  SpecificTalentModel specificTalentModel;

  TalentAddComment(this.specificTalentModel, {Key? key}) : super(key: key);

  @override
  State<TalentAddComment> createState() => _TalentAddCommentState();
}

class _TalentAddCommentState extends State<TalentAddComment> {
  TextEditingController comment = TextEditingController();
  late TalentProvider talentProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    // Provider.of<TalentProvider>(context, listen: false)
    //     .getComments(widget.serviceID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    talentProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          language ? "Comments" : 'التعليقات',
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
              widget.specificTalentModel.comments.length.toString(),
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
                itemCount: widget.specificTalentModel.comments.length,
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
                                  widget.specificTalentModel.comments[index].name,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  widget.specificTalentModel.comments[index]
                                      .comment,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  widget.specificTalentModel.comments[index]
                                      .date,
                                  TextDirection.ltr,
                                  null,
                                  black,
                                  sizeFromWidth(context, 50),
                                  FontWeight.w500,
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
                          widget.specificTalentModel.comments[index].image != ''
                              ? NetworkImage(widget.specificTalentModel.comments[index].image)
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
                      hint: language ? 'Write comment...' : 'اكتب تعليق...',
                      isExpanded: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: !talentProvider.isLoading
                        ? IconButton(
                            onPressed: () async {
                              if (comment.text == '') {
                                showToast(
                                    text: language
                                        ? 'You must enter comment'
                                        : 'يجب كتابة تعليق',
                                    state: ToastStates.ERROR);
                              } else {
                                talentProvider
                                    .addTalentComment(
                                        widget.specificTalentModel.id
                                            .toString(),
                                        comment.text.trim())
                                    .then((value) {
                                  comment.clear();
                                  talentProvider.getComments(
                                      widget.specificTalentModel.id,
                                      widget.specificTalentModel.comments);
                                });
                              }
                            },
                            icon: Icon(
                              Icons.send_sharp,
                              size: sizeFromWidth(context, 15),
                            ),
                            color: Colors.white,
                          )
                        : circularProgressIndicator(
                            lightGrey, primaryColor, context),
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
