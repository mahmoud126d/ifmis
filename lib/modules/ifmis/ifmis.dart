
import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../../providers/other provider.dart';
import 'show%20visit.dart';
import '../../providers/ifmis%20provider.dart';

import 'package:provider/provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class IFMIS extends StatefulWidget {
  const IFMIS({Key? key}) : super(key: key);

  @override
  State<IFMIS> createState() => _IFMISState();
}

class _IFMISState extends State<IFMIS> {
  late IFMISProvider ifmisProvider;
  late OtherProvider otherProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false).getVisits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(Icons.home, color: white),
        ),
      ),
      body: Directionality(
        textDirection: !language ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ifmisProvider.visitModel.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      navigateTo(
                          context, ShowVisit(ifmisProvider.visitModel[index]));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      width: sizeFromWidth(context, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF7f0e14),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  language ? ifmisProvider.visitModel[index].title.en : ifmisProvider.visitModel[index].title.ar,
                                  textDirection: language ? TextDirection.ltr : TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: sizeFromWidth(context, 7),
                                height:
                                sizeFromHeight(context, 12, hasAppBar: true),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          ifmisProvider.visitModel[index].image),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
