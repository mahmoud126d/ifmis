import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/games/game%20details%20model.dart';
import '../models/games/game%20model.dart';
import '../models/language/language.dart';
import '../shared/Components.dart';

class GamesProvider with ChangeNotifier {
  bool isLoading = false;
  List<GameModel> gameModel = [];

  GameDetailsModel gameDetailsModel = GameDetailsModel(
    id: 0,
    name: LanguageModel(en: '', ar: ''),
    description: LanguageModel(en: '', ar: ''),
    video: '',
    images: [],
    google: '',
    apple: '',
  );

  void getGames() async {
    gameModel = [];
    isLoading = true;
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/digital_games');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        gameModel.add(GameModel.fromJSON(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getGameDetails(String gameID) async {
    isLoading = true;
    gameDetailsModel = GameDetailsModel(
      id: 0,
      name: LanguageModel(en: '', ar: ''),
      description: LanguageModel(en: '', ar: ''),
      video: '',
      images: [],
      google: '',
      apple: '',
    );
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/digital_games/$gameID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      gameDetailsModel = GameDetailsModel.fromJson(getData['data']);
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }
}
