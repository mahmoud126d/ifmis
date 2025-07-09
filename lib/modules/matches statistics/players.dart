
import 'package:flutter/material.dart';
import '../matches%20statistics/show%20player.dart';
import '../matches%20statistics/statistics.dart';
import 'package:provider/provider.dart';
import '../../models/statistics/player.dart';
import '../../providers/articles provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class PlayersTransaction extends StatefulWidget {
  const PlayersTransaction({Key? key}) : super(key: key);

  @override
  State<PlayersTransaction> createState() => _PlayersTransactionState();
}

class _PlayersTransactionState extends State<PlayersTransaction> {
  late ArticlesProvider articlesProvider;

  @override
  Widget build(BuildContext context) {
    articlesProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const Statistics());
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'Player',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'Nat.',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
                SizedBox(width: sizeFromWidth(context, 10)),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'Club',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (players.isEmpty)
                  SizedBox(
                    height: sizeFromHeight(context, 2),
                    child: Center(
                        child: circularProgressIndicator(
                            lightGrey, primaryColor, context)),
                  ),
                if (players.isNotEmpty)
                  for (int i = 0; i < players.length; i++)
                    itemPlayer(i, players[i]),
                if (otherPlayers.isNotEmpty)
                  for (int i = 0; i < otherPlayers.length; i++)
                    itemPlayer(i, otherPlayers[i]),
                if (!articlesProvider.isLoading &&
                    otherPlayers.isNotEmpty)
                  itemPlayer(otherPlayers.length, otherPlayers[0]),
                if (articlesProvider.isLoading &&
                    otherPlayers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                        child:
                            circularProgressIndicator(lightGrey, primaryColor, context)),
                 ),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }

  Widget itemPlayer(index, PlayerModel playerModel) {
    if (index < otherPlayers.length && otherPlayers.isNotEmpty) {
      return InkWell(
        onTap: () {
          navigateTo(context, ShowPlayer(playerModel));
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: sizeFromWidth(context, 8),
                height: sizeFromWidth(context, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.profile.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: sizeFromWidth(context, 4),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: textWidget(
                      playerModel.name.trim(),
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 40),
                      FontWeight.bold,
                      null,
                      1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: textWidget(
                      playerModel.position.trim(),
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 40),
                      FontWeight.bold,
                      null,
                      1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: sizeFromWidth(context, 12),
                height: sizeFromWidth(context, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.birthPlaceLogo.toString()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: sizeFromWidth(context, 10)),
              Container(
                width: sizeFromWidth(context, 12),
                height: sizeFromWidth(context, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.currentCubLogo.toString()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index < players.length && otherPlayers.isEmpty) {
      return InkWell(
        onTap: () {
          navigateTo(context, ShowPlayer(playerModel));
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: sizeFromWidth(context, 8),
                height: sizeFromWidth(context, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.profile.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: sizeFromWidth(context, 4),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: textWidget(
                      playerModel.name.trim(),
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 40),
                      FontWeight.bold,
                      null,
                      1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: textWidget(
                      playerModel.position.trim(),
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 40),
                      FontWeight.bold,
                      null,
                      1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: sizeFromWidth(context, 12),
                height: sizeFromWidth(context, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.birthPlaceLogo.toString()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: sizeFromWidth(context, 10)),
              Container(
                width: sizeFromWidth(context, 12),
                height: sizeFromWidth(context, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.currentCubLogo.toString()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index == otherPlayers.length) {
      return InkWell(
        onTap: () {
          articlesProvider.getOtherPlayers(false);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            color: lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: textWidget(
                    'عرض المزيد',
                    null,
                    TextAlign.center,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    null,
                    1),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
