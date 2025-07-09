import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sport%20services/sport%20services%20categories.dart';
import 'package:http/http.dart' as http;
import '../network/cash_helper.dart';
import '../models/sport services/sport services comments.dart';
import '../models/sport services/sport services news.dart';
import '../shared/Components.dart';

class SportServicesProvider with ChangeNotifier {
  bool isLoading = false;
  List<SportServicesCategoriesModel> sportServicesCategoriesModel = [];
  List<SportServicesNewsModel> sportServicesNewsModel = [];
  var picker = ImagePicker();
  List<File> pickedImage = [];
  List<SportServicesCommentsModel> comments = [];
  TextEditingController search = TextEditingController();
  bool language = CacheHelper.getData(key: 'language') ?? false;


  void searchAboutNews() {
    List<SportServicesNewsModel> news = [];
    news = sportServicesNewsModel.where((element) {
      String searchItem;
      if (language) {
        searchItem = element.title.en.toLowerCase();
      } else {
        searchItem = element.title.ar.toLowerCase();
      }
      return searchItem.contains(search.text.toLowerCase());
    }).toList();
    sportServicesNewsModel = [];
    sportServicesNewsModel = news;
    notifyListeners();
  }

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
      showToast(text: 'تم إختيار الصور', state: ToastStates.SUCCESS);
    } else {
      showToast(
          text: 'يجب اختيار عدد من الصور أقل من 6', state: ToastStates.ERROR);
    }
  }

  void getSportServicesCategories() async {
    sportServicesCategoriesModel = [];
    isLoading = true;
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/sport_service_categories');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        sportServicesCategoriesModel
            .add(SportServicesCategoriesModel.fromJSON(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSportServicesNews(String id) async {
    sportServicesNewsModel = [];
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/sport_service_categories/$id');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'] != null
          ? getData['data'].forEach((element) {
              sportServicesNewsModel
                  .add(SportServicesNewsModel.fromJson(element));
            })
          : [];
      sportServicesNewsModel.sort((a, b) {
        return b.id.compareTo(a.id);
      });
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addNews(
    String link,
    String categoryID,
    String publisherName,
    String publisherCountry,
  ) async {
    String countryImage = CacheHelper.getData(key: 'countryImage') ?? '';
    String name = CacheHelper.getData(key: 'name') ?? '';
    String bio = CacheHelper.getData(key: 'bio') ?? '';
    String phone = CacheHelper.getData(key: 'phone') ?? '';
    bool language = CacheHelper.getData(key: 'language') ?? false;
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
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
              'https://iffsma-2030.com/public/api/v1/create/sport_service'));
      request.fields.addAll({
        'title_ar': name,
        'title_en': name,
        'description_ar': bio,
        'description_en': bio,
        'video_link': link,
        'sport_service_category_id': categoryID,
        'tell_about_yourself': phone,
        'publisher_name': publisherName,
        'publisher_age': '0',
        'publisher_country': publisherCountry,
        'user_id': id.toString(),
        'publisher_country_image': countryImage,
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
        showToast(
            text: language
                ? 'Wait for the news to be accepted by the official'
                : 'انتظر قبول الخبر من المسئول',
            state: ToastStates.SUCCESS);
        isLoading = false;
        notifyListeners();
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> deleteNews(String category) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/delete/sport_service?id=$category&user_id=$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: language ? 'Deleted' : 'تم الحذف بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addComment(int serviceID, String comment) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var userID = CacheHelper.getData(key: 'id') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/sport_service/addComment');
    Map<String, dynamic> serviceModel = {
      'user_id': userID.toString(),
      'sport_service_id': serviceID.toString(),
      'comment': comment,
    };
    var body1 = jsonEncode(serviceModel);
    var body2 = jsonDecode(body1);
    var response = await http.post(
      url,
      body: body2,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      showToast(text: 'تم التعليق بنجاح', state: ToastStates.SUCCESS);
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> getComments(int serviceID) async {
    comments = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/sport_service/getComments?sport_service_id=$serviceID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    var commentList = data['data'];
    if (response.statusCode == 200) {
      commentList.forEach((element) {
        comments.add(SportServicesCommentsModel.fromJSON(element));
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }
}
