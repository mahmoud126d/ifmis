import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/notification/notification.dart';
import '../models/other/screens.dart';
import '../models/other/setting%20model.dart';
import '../models/other/side menu.dart';
import '../models/programmer/programmer.dart';
import '../network/cash_helper.dart';
import '../shared/Components.dart';
import 'package:http/http.dart' as http;
import '../shared/const.dart';

import '../models/other/banner model.dart';

class OtherProvider with ChangeNotifier {
  Future<void> getBanners() async {
    upBanners = [];
    downBanners = [];
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/banners');
    var response = await http.get(url, headers: {'Accept': 'application/json'});
    Map<String, dynamic> data = json.decode(response.body);
    var bannerList = data['data'];
    if (response.statusCode == 200) {
      bannerList.forEach((element) {
        if (element['type'] == 'down') {
          downBanners.add(BannerModel.fromJSON(element));
        } else if (element['type'] == 'up') {
          upBanners.add(BannerModel.fromJSON(element));
        }
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void getSettings() async {
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/setting');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      settingModel = SettingModel.fromJSON(getData['data']);
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void addVisitor() async {
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://iffsma-2030.com/public/api/v1/add/visitor'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
    } else {}
  }

  Object? getTexts(String text) {
    bool isEnglish = CacheHelper.getData(key: 'language') ?? false;
    if (isEnglish == true) return textsEnglish[text];
    return textsArabic[text];
  }

  Future<void> changeLanguage(bool value) async{
    CacheHelper.saveData(key: 'language', value: value);
    notifyListeners();
  }

  void getProgrammers() async {
    programmers = [];
    var available = await FirebaseFirestore.instance
        .collection('admin')
        .doc('Qa1ZsddOKeCm0R3mDPNp')
        .get();
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET', Uri.parse('https://iffsma-2030.com/public/api/v1/get/teams'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((e) {
        if (available['programmer'] == false) {
          programmers.add(ProgrammerModel.fromJSON(e));
        } else {
          programmers.add(programmerModel);
        }
      });
      if (!programmers.contains(programmerModel)) {
        programmers.sort((a, b) {
          if (a.name.contains('عبدالرحمن')) {
            return 0;
          }
          return 1;
        });
      }
      notifyListeners();
    } else {
      showToast(
          text: decodedData['message'].toString(), state: ToastStates.ERROR);
    }
  }

  void getHomeScreens() async {
    screens = [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
        'GET', Uri.parse('https://iffsma-2030.com/public/api/v1/app-screens'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      decodedData['data'].forEach((e) {
        screens.add(ScreensModel.fromJson(e));
      });
      notifyListeners();
    } else {
      showToast(
          text: decodedData['message'].toString(), state: ToastStates.ERROR);
    }
  }

  Future<void> getSideMenu() async {
    sideMenu = [];
    var headers = {
      'Accept': 'application/json',
    };
    var request = http.Request(
        'GET', Uri.parse('https://iffsma-2030.com/public/api/v1/side-menus'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((e) {
        sideMenu.add(SideMenuModel.fromJson(e));
      });
      sideMenu.sort((a, b) => a.id.compareTo(b.id));
      notifyListeners();
    } else {
      showToast(
          text: decodedData['message'].toString(), state: ToastStates.ERROR);
    }
  }

  void getNotifications() async {
    notifications = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('GET',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/notifications'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        notifications.add(NotificationModel.fromJson(element));
      });
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
    notifyListeners();
  }

  void deleteNotification(
      String id, NotificationModel notificationModel) async {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    String token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/user/delete/notification/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(
          text: language ? "Deleted" : "تم الحذف", state: ToastStates.SUCCESS);
      notifications.remove(notificationModel);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
    notifyListeners();
  }

  Future<void> updateAppLanguage(bool isEnglish) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/setting/app-lang'));
    request.fields.addAll({'app_lang': isEnglish ? 'en' : 'ar'});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: isEnglish ? "Done" : "تم", state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }
}
