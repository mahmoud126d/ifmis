// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as PluginDatetimePicker;
import '../shared/Components.dart';
import '../shared/Style.dart';
import '../models/statistics/matches scores.dart';
import '../models/statistics/matches statistics.dart';
import '../models/statistics/matches.dart';
import '../models/statistics/team.dart';
import '../shared/const.dart';

class MatchesStatisticsProvider with ChangeNotifier {
  List<MatchesStatisticsModel> matches = [];
  String date = '';
  String getNameOfDay = '';
  List<MatchSummary> matchesSummary = [];
  List scoresFiltered = [];
  List teamsFiltered = [];
  List<ScreensOfStatistics> screens = [];

  Future<void> getMatches(String date) async {
    DateTime dateTime = DateTime.parse(date);
    String dateAfterEdit =
        '${dateTime.year}-${dateTime.month < 10 ? '0' : ''}${dateTime.month}-${dateTime.day < 10 ? '0' : ''}${dateTime.day}';
    //
    matches = [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/scraping/matches?date=$dateAfterEdit'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data']['matches'].forEach((element) {
        matches.add(MatchesStatisticsModel.fromJson(element));
      });
      notifyListeners();
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  void getDateOfDay() {
    date = '';
    getNameOfDay = '';
    date = DateFormat("yyyy-MM-dd")
        .format(DateTime.parse(DateTime.now().toString()));
    getNameOfDay = '';
  }

  void getNameDay(String day) {
    switch (day) {
      case 'Monday':
        getNameOfDay = 'الاثنين';
        break;
      case 'Tuesday':
        getNameOfDay = 'الثلاثاء';
        break;
      case 'Wednesday':
        getNameOfDay = 'الأربعاء';
        break;
      case 'Thursday':
        getNameOfDay = 'الخميس';
        break;
      case 'Friday':
        getNameOfDay = 'الجمعة';
        break;
      case 'Saturday':
        getNameOfDay = 'السبت';
        break;
      case 'Sunday':
        getNameOfDay = 'الأحد';
        break;
      default:
        getNameOfDay = '';
        break;
    }
    notifyListeners();
  }

  Future<void> selectDatePerDay(BuildContext context) async {
    picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2, 3, 5),
      maxTime: DateTime(3500, 6, 7),
      onChanged: (dateNow) {
        date = DateFormat("yyyy-MM-dd").format(dateNow);
        getNameDay(DateFormat('EEEE').format(dateNow));
        date = date.replaceAll('/', '-');
        matches = [];
        notifyListeners();
        getMatches(date);
      },
      onConfirm: (dateNow) {
        date = DateFormat("yyyy-MM-dd").format(dateNow);
        getNameDay(DateFormat('EEEE').format(dateNow));
        date = date.replaceAll('/', '-');
        matches = [];
        notifyListeners();
        getMatches(date);
      },
      currentTime: DateTime.now(),
      theme: picker.DatePickerTheme(
        cancelStyle: TextStyle(color: primaryColor),
        doneStyle: TextStyle(color: primaryColor),
      ),
    );
  }

  Future<void> getScores() async {
    scores = [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/scraping/get/all-TeamScores'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      if(decodedData['data'] != []){
        decodedData['data']['champions'].forEach((element) {
          scores.add(MatchesScoresModel.fromJSON(element['playerScorers']));
        });
      }
      notifyListeners();
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> filterScores() async {
    scoresFiltered = [];
    for (int i = 0; i < scores.length; i++) {
      if (!scoresFiltered.contains(scores[i].champName)) {
        scoresFiltered.add(scores[i].champName);
      }
    }
  }

  Future<void> filterTeams() async {
    teamsFiltered = [];
    for (int i = 0; i < teams.length; i++) {
      if (!teamsFiltered.contains(teams[i].champName)) {
        teamsFiltered.add(teams[i].champName);
      }
    }
  }

  Future<void> getTeams() async {
    teams = [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/scraping/raking/teams/champ'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      if (decodedData['data'] != []) {
        decodedData['data']['rakingTeam'].forEach((element) {
          teams.add(TeamModel.fromJSON(element['allChamp']));
        });
      }
      notifyListeners();
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getMatchesSummary() async {
    matchesSummary = [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/football_match_summaries'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        getMatchesSummaryDetails(element['id'].toString());
      });
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> getMatchesSummaryDetails(String id) async {
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/football_match_summaries/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      matchesSummary.add(MatchSummary.fromJSON(decodedData['data'], true));
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void getScreens() async {
    screens = [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request('GET',
        Uri.parse('https://iffsma-2030.com/public/api/v1/get/newSports'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((e) {
        screens.add(ScreensOfStatistics.fromJson(e));
      });
      notifyListeners();
    } else {
      showToast(
          text: decodedData['message'].toString(), state: ToastStates.ERROR);
    }
  }
}
