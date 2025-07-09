import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ifmis/member.dart';
import '../models/ifmis/visit%20details%20model.dart';
import '../models/championship stats/championship stats.dart';
import '../models/ifmis/visit model.dart';
import '../models/language/language.dart';
import '../shared/Components.dart';

class IFMISProvider with ChangeNotifier {
  bool isLoading = false;
  List<VisitModel> visitModel = [];
  List<MemberModel> memberModel = [];
  List<ChampionshipStatsModel> championshipStatsModel = [];
  List<MemberDetailsModel> memberDetailsModel = [];
  VisitDetailsModel visitDetailsModel = VisitDetailsModel(
    id: 0,
    title: LanguageModel(ar: '', en: ''),
    description: LanguageModel(ar: '', en: ''),
    video: '',
    images: [],
  );

  void getVisits() async {
    visitModel = [];
    isLoading = true;
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/union-business');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        visitModel.add(VisitModel.fromJSON(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getVisitDetails(String visitID) async {
    isLoading = true;
    visitDetailsModel = VisitDetailsModel(
      id: 0,
      title: LanguageModel(ar: '', en: ''),
      description: LanguageModel(ar: '', en: ''),
      video: '',
      images: [],
    );
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/union-business/$visitID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      visitDetailsModel = VisitDetailsModel.fromJson(getData['data']);
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMembers() async {
    memberModel = [];
    memberDetailsModel = [];
    isLoading = true;
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/union-members');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        memberModel.add(MemberModel.fromJSON(element));
      });
      memberModel.sort((a, b) => a.id > b.id ? a.id : b.id);
      for (var element in memberModel) {
        await getMemberDetails(element.id.toString());
      }
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMemberDetails(String memberID) async {
    isLoading = true;
    var url =
        Uri.parse('https://iffsma-2030.com/public/api/v1/member/$memberID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      memberDetailsModel.add(MemberDetailsModel.fromJSON(getData['data']));
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void getChampionshipStats(String page) async {
    championshipStatsModel = [];
    isLoading = true;
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/union-news');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        if (element["the_place_to_add_the_news"] == page) {
          championshipStatsModel.add(ChampionshipStatsModel.fromJSON(element));
        }
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }
}
