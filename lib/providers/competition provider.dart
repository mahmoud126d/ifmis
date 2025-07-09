import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/competition/competition%20comment%20model.dart';
import '../network/cash_helper.dart';
import '../shared/Components.dart';
import 'package:video_player/video_player.dart';

import '../models/competition/competition model.dart';
import '../models/competition/competitor model.dart';

class CompetitionProvider with ChangeNotifier {
  bool isLoading = false;
  final picker = ImagePicker();
  File? pickedVideo;
  String dateAfterEdit = '';
  List<CompetitionModel> competitions = [];
  List<CompetitorModel> competitors = [];
  List<CompetitionCommentModel> comments = [];
  double score = 0.0;

  void pickVideoCompetitor() async {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    var pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 40),
    );
    if (pickedFile != null) {
      pickedVideo = File(pickedFile.path);
      VideoPlayerController videoPlayerController =
          VideoPlayerController.file(File(pickedFile.path));
      await videoPlayerController.initialize();
      if (videoPlayerController.value.duration.inSeconds > 40) {
        pickedFile = null;
        pickedVideo = null;
        showToast(
            text: language
                ? 'No video will be sent that exceeds 40 seconds'
                : 'لا يتم ارسال فيديو يتخطى 40 ثانيه',
            state: ToastStates.WARNING);
        notifyListeners();
      } else {
        showToast(
            text: language ? 'Video Selected' : 'تم اختيار الفيديو',
            state: ToastStates.SUCCESS);
      }
    }
  }

  Future<void> getCompetitions() async {
    competitions = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/competitions');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allCompetitions = data['data'];
    if (response.statusCode == 200) {
      for (var element in allCompetitions) {
        competitions.add(CompetitionModel.fromJSON(element));
      }
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> getAllCompetitors(int competitionID) async {
    competitors = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/contestants?competition_id=$competitionID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allCompetitions = data['data'];
    if (response.statusCode == 200) {
      for (var element in allCompetitions) {
        competitors.add(CompetitorModel.fromJSON(element));
      }
      competitors.sort((a, b) {
        double aScore = double.parse(a.score);
        double bScore = double.parse(b.score);
        return bScore.compareTo(aScore);
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> addComment(
      int competitionID, int competitorID, String comment) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var userID = CacheHelper.getData(key: 'id') ?? '';
    var url =
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/add/comment');
    Map<String, dynamic> competitionCommentModel = {
      'user_id': userID.toString(),
      'competition_id': competitionID.toString(),
      'contestant_id': competitorID.toString(),
      'comment': comment,
    };
    var body1 = jsonEncode(competitionCommentModel);
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

  Future<void> getComments(int competitorID) async {
    comments = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/contestant/comments?contestant_id=$competitorID');
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
        comments.add(CompetitionCommentModel.fromJSON(element));
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> addVote(int competitionID, int competitorID) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var userID = CacheHelper.getData(key: 'id') ?? '';
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/user/add/vote');
    Map<String, dynamic> data = {
      'user_id': userID.toString(),
      'competition_id': competitionID.toString(),
      'contestant_id': competitorID.toString(),
    };
    var response = await http.post(
      url,
      body: data,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200 && getData['status'] == true) {
      showToast(text: 'تم التصويت بنجاح', state: ToastStates.SUCCESS);
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void shareInCompetition(
    String competitionID,
    String positionAR,
    String positionEN,
    String videoLink,
    BuildContext context,
  ) async {
    String countryImage = CacheHelper.getData(key: 'countryImage') ?? '';
    String image = CacheHelper.getData(key: 'image') ?? '';
    String name = CacheHelper.getData(key: 'name') ?? '';
    bool language = CacheHelper.getData(key: 'language') ?? false;
    if (videoLink == '' && pickedVideo == null) {
      showToast(
          text: 'يجب وضع رابط فيديو أو اختيار فيديو لا يزيد عن 40 ثانيه',
          state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      String token = CacheHelper.getData(key: 'token') ?? '';
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://iffsma-2030.com/public/api/v1/user/Participate'));
      request.fields.addAll({
        'name_ar': name,
        'name_en': name,
        'center_ar': positionAR,
        'center_en': positionEN,
        'video_link': videoLink,
        'competition_id': competitionID,
        'country_image': countryImage,
        'image': image,
      });
      if (pickedVideo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('video', pickedVideo!.path));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        isLoading = false;
        showToast(
            text: language
                ? "wait until you are accepted into the competition"
                : 'انتظر حتى يتم قبولك بالمسابقة',
            state: ToastStates.SUCCESS);
        notifyListeners();
        navigatePop(context);
      } else {
        isLoading = false;
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        notifyListeners();
      }
    }
  }

  void updateDate(String date) {
    if (date.contains('Jan')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '1,');
    } else if (date.contains('Feb')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('F'), date.indexOf('F') + 3, '2,');
    } else if (date.contains('Mar')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('M'), date.indexOf('M') + 3, '3,');
    } else if (date.contains('Apr')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('A'), date.indexOf('A') + 3, '4,');
    } else if (date.contains('May')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('M'), date.indexOf('M') + 3, '5,');
    } else if (date.contains('Jun')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '6,');
    } else if (date.contains('Jul')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '7,');
    } else if (date.contains('Aug')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('A'), date.indexOf('A') + 3, '8,');
    } else if (date.contains('Sep')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('S'), date.indexOf('S') + 3, '9,');
    } else if (date.contains('Oct')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('O'), date.indexOf('O') + 3, '10,');
    } else if (date.contains('Nov')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('N'), date.indexOf('N') + 3, '11,');
    } else if (date.contains('Dec')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('D'), date.indexOf('D') + 3, '12,');
    }
  }

  void getGoldenMedal() {
    score = 0.0;
    score = double.parse(competitors[0].score);
    notifyListeners();
  }
}
