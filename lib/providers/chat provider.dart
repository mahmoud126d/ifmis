import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat/message%20model.dart';
import '../shared/Components.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/chat/category chat model.dart';
import '../models/chat/chat module.dart';
import '../models/chat/user chat module.dart';
import '../network/cash_helper.dart';

class ChatProvider with ChangeNotifier {
  var picker = ImagePicker();
  File? pickedVideo;
  bool isLoading = false;
  var messageControl = TextEditingController();
  Duration position = Duration.zero;
  VideoPlayerController videoPlayerController =
      VideoPlayerController.network('');
  bool isVideoPlay = true;
  bool isPortrait = true;
  bool showControl = true;
  List<CategoryChatModel> categoryChat = [];
  List<ChatModel> chats = [];
  List<MessageModel> messages = [];
  List<UserChatModule> userChat = [];
  File? chatImage;
  File? messageImage;
  late Stream<void> stream;
  TextEditingController search = TextEditingController();
  bool userBlocked = false;

  Future<void> getCategoryChats() async {
    categoryChat = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/categories');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allCategoryChats = data['data'];
    if (response.statusCode == 200) {
      for (var element in allCategoryChats) {
        categoryChat.add(CategoryChatModel.fromJSON(element));
      }
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> getChats(int chatID) async {
    chats = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/chats?category_id=$chatID');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allChats = data['data'];
    if (response.statusCode == 200) {
      for (var element in allChats) {
        chats.add(ChatModel.fromJSON(element));
      }
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void searchAboutChat() {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    List<ChatModel> searchChats = [];
    searchChats = chats.where((element) {
      String searchItem = '';
      if (language) {
        searchItem = element.name.en.toLowerCase();
      } else {
        searchItem = element.name.en.toLowerCase();
      }

      return searchItem.contains(search.text.toLowerCase());
    }).toList();
    chats = [];
    chats = searchChats;
    notifyListeners();
  }

  Future<void> userEnterChat(int chatID) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    var url =
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/enter/chat');
    Map<String, dynamic> data = {
      'user_id': id.toString(),
      'chat_id': chatID.toString(),
    };
    await http.post(
      url,
      body: data,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> userLeaveChat(int chatID) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/user/leave/chat?user_id=$id&chat_id=$chatID');
    Map<String, dynamic> data = {
      'user_id': id.toString(),
      'chat_id': chatID.toString(),
    };
    await http.delete(
      url,
      body: data,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> sendMessage(String chatID, String message, String type) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    if (type == 'image') {
      final pickedImageFile =
          await picker.pickImage(source: ImageSource.gallery);
      messageImage = File(pickedImageFile!.path);
    }
    if (type == 'video') {
      var pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );
      if (pickedFile != null) {
        pickedVideo = File(pickedFile.path);
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(File(pickedFile.path));
        await videoPlayerController.initialize();
        if (videoPlayerController.value.duration.inSeconds > 60) {
          pickedFile = null;
          pickedVideo = null;
          showToast(
              text: 'لا يتم ارسال فيديو يتخطى الدقيقة',
              state: ToastStates.WARNING);
          notifyListeners();
        } else {
          showToast(
              text: 'انتظر يتم إرسال الفيديو', state: ToastStates.SUCCESS);
        }
      }
    }
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    isLoading = true;
    notifyListeners();
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/send/message'));
    request.fields.addAll({
      'user_id': id.toString(),
      'chat_id': chatID,
      'message': message,
      'date': '${DateTime.now().hour}:${DateTime.now().minute} ${periodTime()}',
    });
    if (messageImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', messageImage!.path));
    }
    if (pickedVideo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('video', pickedVideo!.path));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      messageControl.clear();
      messageImage = null;
      pickedVideo = null;
      messageImage = null;
      getMessages(chatID);
    }
    isLoading = false;
    notifyListeners();
  }

  void setStream(String chatID) {
    stream = Stream.periodic(const Duration(seconds: 5))
        .asyncMap((event) async => await getMessages(chatID));
  }

  Future<void> getMessages(String chatID) async {
    messages = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/chat/messages?chat_id=$chatID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allMessages = data['data'];
    if (response.statusCode == 200) {
      for (var element in allMessages) {
        messages.add(MessageModel.fromJSON(element));
      }
      messages.sort((a, b) {
        return b.messageID.compareTo(a.messageID);
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> deleteMessage(String messageID, String chatID) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/delete/message?message_id=$messageID');
    var response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      showToast(text: 'تم الحذف', state: ToastStates.SUCCESS);
      getMessages(chatID);
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> getUserChat(String chatID) async {
    userChat = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/user/images/chat?chat_id=$chatID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allImage = data['data'];
    if (response.statusCode == 200) {
      for (var element in allImage) {
        userChat.add(UserChatModule.fromJSON(element['user']));
      }
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void selectChatImage() async {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      chatImage = File(pickedImageFile.path);
      showToast(text: language ? 'photo selected' : 'تم اختيار الصورة', state: ToastStates.SUCCESS);
      notifyListeners();
    }
  }

  Future<void> createChat(
    String categoryID,
    String number,
    String nameAR,
    String nameEN,
  ) async {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    if (chatImage == null) {
      showToast(text: language ? 'Image is required' : 'يجب اختيار صورة المحادثة', state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      String token = CacheHelper.getData(key: 'token') ?? '';
      var id = CacheHelper.getData(key: 'id') ?? '';
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://iffsma-2030.com/public/api/v1/contestant/create/chat'));
      request.fields.addAll({
        'name_ar': nameAR,
        'name_en': nameEN,
        'number_of_users': number,
        'category_id': categoryID,
        'user_id': id.toString(),
      });
      request.files
          .add(await http.MultipartFile.fromPath('image', chatImage!.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        isLoading = false;
        chatImage = null;
        if (decodedData['message'] == "انت انشات شات من قبل") {
          showToast(
              text: language ? 'You\'ve already created a chat and can\'t create more than that' : 'أنت أنشات محادثة من قبل ولا يمكنك إنشاء أكثر من ذلك',
              state: ToastStates.WARNING);
        } else {
          showToast(
              text: language ? 'Wait for your chat to be accepted' : 'انتظر حتى يتم قبول الدردشة الخاصة بك',
              state: ToastStates.SUCCESS);
        }
        notifyListeners();
      } else {
        isLoading = false;
        chatImage = null;
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        notifyListeners();
      }
    }
  }

  Future<void> blockUser(String chatID, String id) async {
    String token = CacheHelper.getData(key: 'token');
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/switch/bans');
    Map<String, dynamic> body = {
      "user_id": id,
      "chat_id": chatID,
    };
    var response = await http.post(
      url,
      body: body,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      showToast(text: data['message'], state: ToastStates.SUCCESS);
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> checkIsUserBlocked(String chatID, String userID) async {
    String token = CacheHelper.getData(key: 'token');
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/check/user/ban?user_id=$userID&chat_id=$chatID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data['message'] == 'yes') {
      userBlocked = true;
      notifyListeners();
    } else {
      userBlocked = false;
      notifyListeners();
    }
  }

  Future<void> userEditChat(String chatID, String chatName,
      String numberOfUsers, String categoryID) async {
    isLoading = true;
    notifyListeners();
    var id = CacheHelper.getData(key: 'id');
    String token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/edit/chat'));
    request.fields.addAll({
      'chat_id': chatID,
      'user_id': id.toString(),
      'name': chatName,
      'number_of_users': numberOfUsers,
      'category_id': categoryID,
    });
    if (chatImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', chatImage!.path));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم التعديل بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  String? periodTime() {
    if (TimeOfDay.now().period == DayPeriod.am) {
      return 'AM';
    }
    if (TimeOfDay.now().period == DayPeriod.pm) {
      return 'PM';
    }
    return null;
  }

  void initVideoPlayer(String videoLink) async {
    videoPlayerController = VideoPlayerController.network(videoLink);
    await videoPlayerController.initialize();
    videoPlayerController.addListener(updateSliderPosition);
    videoPlayerController.play();
    isVideoPlay = true;
    notifyListeners();
  }

  void updateSliderPosition() {
    position = videoPlayerController.value.position;
    if (videoPlayerController.value.position.inSeconds != 0 &&
        videoPlayerController.value.position.inSeconds ==
            videoPlayerController.value.duration.inSeconds) {
      getVideoSeek(0);
    }
    notifyListeners();
  }

  void getVideoSeek(value) async {
    videoPlayerController.seekTo(Duration(seconds: value.toInt()));
    notifyListeners();
  }

  void changePortraitToLandscape(bool value) {
    if (!value) {
      isPortrait = value;
    } else {
      isPortrait = value;
    }
    notifyListeners();
  }

  void showControlVideo() {
    showControl = !showControl;
    notifyListeners();
  }

  void pauseAndPlayVideo() {
    if (isVideoPlay) {
      isVideoPlay = false;
      videoPlayerController.pause();
    } else {
      isVideoPlay = true;
      videoPlayerController.play();
    }
    notifyListeners();
  }

  void increaseOrDecrease(bool increase) {
    if (increase) {
      videoPlayerController.value.position.inSeconds + 5;
      getVideoSeek(videoPlayerController.value.position.inSeconds + 5);
    }
    if (!increase) {
      videoPlayerController.value.position.inSeconds - 5;
      getVideoSeek(videoPlayerController.value.position.inSeconds - 5);
    }
    notifyListeners();
  }

  void killVideo() async {
    videoPlayerController.removeListener(() {});
    videoPlayerController.pause();
    videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    notifyListeners();
  }

  YoutubePlayerController youtubePlayerController =
      YoutubePlayerController(initialVideoId: '');

  void initializeYoutubePlayer(String videoLink) {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoLink).toString(),
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }
}
