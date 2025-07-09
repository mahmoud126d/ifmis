
import 'package:flutter/material.dart';
import '../../network/cash_helper.dart';
import '../../providers/ifmis%20provider.dart';
import 'package:provider/provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';
import 'member details.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  late IFMISProvider ifmisProvider;
  bool language = CacheHelper.getData(key: 'language') ?? false;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false).getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
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
      body: Column(
        children: [
          if (ifmisProvider.memberDetailsModel.isNotEmpty)
            Directionality(
              textDirection: language ? TextDirection.rtl : TextDirection.ltr,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ifmisProvider.memberDetailsModel.length,
                  itemBuilder: (ctx, index) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            width: sizeFromHeight(context, 4),
                            height: sizeFromHeight(context, 4),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(color: primaryColor, width: 2),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(ifmisProvider
                                    .memberDetailsModel[index].image),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            width: sizeFromHeight(context, 4),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: primaryColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  language
                                      ? ifmisProvider
                                          .memberDetailsModel[index].name.en
                                      : ifmisProvider
                                          .memberDetailsModel[index].name.ar,
                                  textDirection: language
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          navigateTo(context, MemberDetails(ifmisProvider.memberDetailsModel[index]));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: textWidget(
                                            'اضغط هنا للمزيد',
                                            null,
                                            null,
                                            primaryColor,
                                            sizeFromWidth(context, 25),
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          if (ifmisProvider.memberDetailsModel.isEmpty)
            Expanded(
              child: Center(
                child:
                    circularProgressIndicator(lightGrey, primaryColor, context),
              ),
            ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
