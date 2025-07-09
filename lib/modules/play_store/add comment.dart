// ignore_for_file: must_be_immutable, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../models/store/product.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class AddProductComment extends StatefulWidget {
  ProductModel productModel;

  AddProductComment(this.productModel, {Key? key}) : super(key: key);

  @override
  State<AddProductComment> createState() => _AddProductCommentState();
}

class _AddProductCommentState extends State<AddProductComment> {
  final TextEditingController comment = TextEditingController();
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: lightGrey1,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: Column(
        children: [
          textFormField(
            controller: comment,
            type: TextInputType.text,
            validate: (value) {
              if (value!.isEmpty) {
                return language ? 'You must enter comment' : 'يجب إدخال تعليق';
              }
              return null;
            },
            fromLTR: language,
            hint: otherProvider.getTexts('write comment').toString(),
          ),
          RatingBar(
            ratingWidget: RatingWidget(
              full: _image('assets/heart.png'),
              half: _image('assets/heart_half.png'),
              empty: _image('assets/heart_border.png'),
            ),
            itemSize: sizeFromHeight(context, 20),
            onRatingUpdate: (value) => storeProvider.changeRating(value),
            initialRating: 0.0,
            allowHalfRating: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: textButton(
                    context,
                    otherProvider.getTexts('add comment').toString(),
                    primaryColor,
                    white,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    () {
                      if (comment.text.isEmpty) {
                        showToast(
                            text: language ? 'Enter Comment' : 'أدخل التعليق', state: ToastStates.ERROR);
                      } else {
                        storeProvider
                            .addProductComment(
                                widget.productModel.id.toString(),
                                comment.text.trim())
                            .then((value) {
                          comment.clear();
                          storeProvider.ratingBar = 0.0;
                          storeProvider.getProductComments(
                              widget.productModel.id.toString());
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }

  Widget _image(String asset) => Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: amber,
    );
}
