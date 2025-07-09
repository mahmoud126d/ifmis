import 'package:flutter/material.dart';
import 'play%20store.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class StoreCategory extends StatefulWidget {
  const StoreCategory({Key? key}) : super(key: key);

  @override
  State<StoreCategory> createState() => _StoreCategoryState();
}

class _StoreCategoryState extends State<StoreCategory> {
  late StoreProvider storeProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false).getStoreCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: lightGrey1,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(
            Icons.home,
            color: white,
          ),
        ),
      ),
      body: Directionality(
        textDirection: language ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            if (storeProvider.storeCategories.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: storeProvider.storeCategories.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () async {
                        navigateAndFinish(
                            context,
                            PlayStore(
                                storeProvider.storeCategories[index].id
                                    .toString(),
                                language
                                    ? storeProvider.storeCategories[index].name.en
                                    : storeProvider
                                    .storeCategories[index].name.ar));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                              color: lightGrey,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    language
                                        ? storeProvider
                                        .storeCategories[index].name.en
                                        : storeProvider
                                        .storeCategories[index].name.ar,
                                    style: TextStyle(
                                      fontSize: sizeFromWidth(context, 30),
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: sizeFromWidth(context, 7),
                              height:
                              sizeFromHeight(context, 12, hasAppBar: true),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      storeProvider.storeCategories[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (storeProvider.storeCategories.isEmpty)
              Expanded(
                child: Center(
                  child:
                  circularProgressIndicator(lightGrey, primaryColor, context),
                ),
              ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
