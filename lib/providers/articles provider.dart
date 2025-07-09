import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/statistics/articles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/statistics/player.dart';
import '../shared/Components.dart';
import '../shared/const.dart';

class ArticlesProvider with ChangeNotifier {
  int articleNumber = 2;
  int gameNumber = 2;
  int playerNumber = 2;
  bool isLoading = false;

  Future<void> getArticles() async {
    articles = [];
    String url = "https://iffsma-2030.com/public/api/v1/scraping/articles";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data['data']['articles'].forEach((element) {
          articles.add(ArticlesModel.fromJSON(element));
          notifyListeners();
        });
      } catch (e) {}
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getOtherArticles(bool setArticle) async {
    try {
      if (setArticle) {
        otherArticles = [];
      }
      if (!setArticle) {
        isLoading = true;
        articleNumber++;
        notifyListeners();
      }
      String url =
          "https://iffsma-2030.com/public/api/v1/scraping/articles/$articleNumber";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        data['data']['articles'].forEach((element) {
          otherArticles.add(ArticlesModel.fromJSON(element));
        });
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPlayers() async {
    players = [];
    String url =
        "https://iffsma-2030.com/public/api/v1/scraping/transfer-market/players";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        Map<String, dynamic> elements = data['data']['players'];
        elements.forEach((key, value) {
          players.add(PlayerModel.fromJSON(value));
          notifyListeners();
        });
      } catch (e) {
        showToast(text: e.toString(), state: ToastStates.ERROR);
      }
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getOtherPlayers(bool setGame) async {
    if (setGame) {
      otherPlayers = [];
    }
    if (!setGame) {
      isLoading = true;
      playerNumber++;
      notifyListeners();
    }
    log(playerNumber.toString());
    String url =
        "https://iffsma-2030.com/public/api/v1/scraping/transfer-market/players/$playerNumber";
    final response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> elements = data['data']['players'];
        elements.forEach((key, value) {
          otherPlayers.add(PlayerModel.fromJSON(value));
          notifyListeners();
        });
      } catch (e) {}
      isLoading = false;
    } else {
      log(data['message'].toString());
    }
  }
}
