import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/talents/specific talent.dart';
import '../models/talents/talent category.dart';
import '../network/cash_helper.dart';
import '../shared/Components.dart';

class TalentProvider with ChangeNotifier {
  List<TalentCategoriesModel> talentCategories = [];
  List<SpecificTalentModel> specificTalents = [];
  bool isLoading = false;
  TextEditingController search = TextEditingController();
  bool language = CacheHelper.getData(key: 'language') ?? false;
  var picker = ImagePicker();
  List<File> pickedImage = [];

  void pickImagesNews() async {
    pickedImage = [];
    await picker.pickMultiImage().then((value) {
      if (value.length <= 6) {
        for (var element in value) {
          pickedImage.add(File(element.path));
        }
        notifyListeners();
      } else {
        pickedImage = [];
        notifyListeners();
      }
    });
    if (pickedImage.isNotEmpty) {
      showToast(
          text: language ? 'photo selected' : 'تم إختيار الصور',
          state: ToastStates.SUCCESS);
    } else {
      showToast(
          text: language
              ? 'images must be less than 6'
              : 'يجب اختيار عدد من الصور أقل من 6',
          state: ToastStates.ERROR);
    }
  }

  void addTalentRate(SpecificTalentModel specificTalentModel) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/talent_explorations/addRating'));
    request.fields.addAll({
      'talent_exploration_id': specificTalentModel.id.toString(),
      'user_id': id.toString(),
      'rate': '1'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      specificTalentModel.points += 1;
      showToast(text: language ? "Done" : "تم", state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
    notifyListeners();
  }

  Future<void> getComments(int talentID, List<TalentComments> comments) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/talent_explorations/comments/$id/$talentID?='));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((c) {
        if (!comments.any((element) {
          return element.comment == c['comment'];
        })) {
          comments.add(TalentComments.fromJson(c));
        }
      });
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void searchAboutTalents() {
    List<SpecificTalentModel> talents = [];
    talents = specificTalents.where((element) {
      String searchItem;
      if (language) {
        searchItem = element.playerName.en.toLowerCase();
      } else {
        searchItem = element.playerName.ar.toLowerCase();
      }
      return searchItem.contains(search.text.toLowerCase());
    }).toList();
    specificTalents = [];
    specificTalents = talents;
    notifyListeners();
  }

  void getTalentCategories() async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    talentCategories = [];
    isLoading = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/talent_exploration_categories'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        talentCategories.add(TalentCategoriesModel.fromJSON(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void getSpecificTalentCategories(String id) async {
    specificTalents = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    isLoading = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/talent_explorations/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        specificTalents.add(SpecificTalentModel.fromJSON(element));
      });
      specificTalents.sort((a, b) => b.points.compareTo(a.points));
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addTalentComment(String talentID, String comment) async {
    specificTalents = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    isLoading = true;
    notifyListeners();
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/talent_explorations/addComment'));
    request.fields.addAll({
      'talent_exploration_id': talentID,
      'user_id': id.toString(),
      'comment': comment
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: language ? "Done" : "تم", state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void addTalent(
    String nameEN,
    String nameAR,
    String school,
    String position,
    String height,
    String classRoom,
    String age,
    String categoryID,
    String video,
  ) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    if (pickedImage.isEmpty) {
      showToast(
          text: language
              ? 'You must select a number of photos less than 6'
              : 'يجب اختيار عدد من الصور أقل من 6',
          state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://iffsma-2030.com/public/api/v1/create/talent_exploration'));
      request.fields.addAll({
        'player_name_en': nameEN,
        'player_name_ar': nameAR,
        'school_name': school,
        'Player_position': position,
        'Player_height': age,
        'class_room': classRoom,
        'player_age': age,
        'talent_exploration_category_id': categoryID,
        'video_link': video,
      });
      for (var element in pickedImage) {
        request.files
            .add(await http.MultipartFile.fromPath('images[]', element.path));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        showToast(text: language ? "Done" : "تم", state: ToastStates.SUCCESS);
        isLoading = false;
        notifyListeners();
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTalent(String talentID) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/delete/talent_explorations/$talentID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(
          text: language ? "Deleted" : "تم الحذف", state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
    notifyListeners();
  }
}
