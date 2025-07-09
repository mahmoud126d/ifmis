// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/competition/competition model.dart';
import '../../network/cash_helper.dart';
import '../../providers/competition provider.dart';
import '../../providers/other provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'Fans_vote.dart';

class Comments extends StatefulWidget {
  CompetitionModel competitionModel;
  String endDate;
  int competitorId;
  String numberOfComments;
  bool isEnd;

  Comments(this.competitionModel, this.endDate, this.competitorId, this.numberOfComments, this.isEnd,{Key? key})
      : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController comment = TextEditingController();
  late CompetitionProvider competitionProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<CompetitionProvider>(context, listen: false)
        .getComments(widget.competitorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          otherProvider.getTexts('comments').toString(),
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
            navigateAndFinish(
                context, FansVote(widget.competitionModel, widget.endDate, widget.isEnd));
          },
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        actions: [
          Center(
            child: Text(
              widget.numberOfComments,
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
                itemCount: competitionProvider.comments.length,
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
                                  competitionProvider.comments[index].user.name,
                                  TextDirection.rtl,
                                  null,
                                  black,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                textWidget(
                                  competitionProvider.comments[index].comment,
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
                          competitionProvider.comments[index].user.image != ''
                              ? NetworkImage(competitionProvider
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
                      hint: otherProvider.getTexts('write comment').toString(),
                      isExpanded: true,
                      fromLTR: language
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
                          competitionProvider
                              .addComment(widget.competitionModel.id,
                                  widget.competitorId, comment.text.trim())
                              .then((value) {
                            comment.clear();
                            competitionProvider.getComments(widget.competitorId);
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
