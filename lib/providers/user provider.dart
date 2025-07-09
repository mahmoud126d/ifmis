// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/authenticate/login model.dart';
import '../models/authenticate/register model.dart';
import '../models/authenticate/user model.dart';
import '../modules/Authentication/log in.dart';
import '../modules/home/home.dart';
import '../modules/profile/profile.dart';
import '../network/cash_helper.dart';
import '../shared/Components.dart';
import '../shared/const.dart';

class UserProvider with ChangeNotifier {
  bool isLoading = false;
  late UserCredential userCredential;
  final auth = FirebaseAuth.instance;
  File? reportImage;
  File? pickedImage;
  final picker = ImagePicker();
  String token = 'no token';
  List<String> allUsers = [];
  String randomString = '';
  bool language = CacheHelper.getData(key: 'language') ?? false;
  IconData iconData = Icons.visibility;
  bool isSecure = true;

  void changeIcon() {
    isSecure = !isSecure;
    if (isSecure) {
      iconData = Icons.visibility;
    } else {
      iconData = Icons.visibility_off;
    }
    notifyListeners();
  }

  Future<void> getUserFcmToken(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await FirebaseMessaging.instance.getToken().then((value) {
        token = value!;
      });
      notifyListeners();
      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
        'email': email,
        'password': password,
        'FB_ID': value.user!.uid,
        'API_ID': '',
      });
    }).catchError((signUpError) async {
      if (signUpError.code.toString().contains("email-already-in-use")) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await FirebaseMessaging.instance.getToken().then((value) {
            token = value!;
          });
          notifyListeners();
        }).catchError((e) {
          showToast(text: e.toString(), state: ToastStates.ERROR);
        });
      } else {
        showToast(text: signUpError.code.toString(), state: ToastStates.ERROR);
      }
    });
    notifyListeners();
  }

  void userRegister(BuildContext context, RegisterModel registerModel) async {
    isLoading = true;
    notifyListeners();
    String body = json.encode(registerModel.toMap());
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/user/register');
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 201) {
      userModel = UserModel.fromJSON(data["data"]);
      var id = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'API_ID': userModel.id.toString(),
      });
      CacheHelper.saveData(key: 'token', value: data['token']);
      CacheHelper.saveData(key: 'email', value: userModel.email);
      CacheHelper.saveData(key: 'password', value: registerModel.password);
      CacheHelper.saveData(key: 'id', value: userModel.id);
      CacheHelper.saveData(key: 'phone', value: userModel.phone);
      CacheHelper.saveData(key: 'name', value: userModel.name);
      CacheHelper.saveData(key: 'type', value: userModel.type);
      CacheHelper.saveData(key: 'country', value: userModel.country);
      CacheHelper.saveData(key: 'bio', value: '');
      CacheHelper.saveData(key: 'image', value: '');
      CacheHelper.saveData(key: 'facebook', value: '');
      CacheHelper.saveData(key: 'instagram', value: '');
      CacheHelper.saveData(key: 'twitter', value: '');
      CacheHelper.saveData(key: 'snapchat', value: '');
      CacheHelper.saveData(key: 'tiktok', value: '');
      CacheHelper.saveData(key: 'age', value: '');
      CacheHelper.saveData(key: 'position', value: '');
      CacheHelper.saveData(key: 'placeOfWork', value: '');
      CacheHelper.saveData(key: 'countryImage', value: '');
      CacheHelper.saveData(key: 'fcmToken', value: data["data"]['fcm_token']);
      showToast(text: 'تم التسجيل بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
      String token = CacheHelper.getData(key: 'token') ?? '';
      await getDataUser(context, token);
      navigateAndFinish(
          context, Profile(token, 'home', false, false, '', true));
    } else if (response.statusCode == 422) {
      showToast(text: data['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void userLogin(
      BuildContext context, LoginModel loginModel, String pageName) async {
    isLoading = true;
    notifyListeners();
    String body = json.encode(loginModel.toMap());
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/user/login');
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      userModel = UserModel.fromJSON(data["data"]);
      var id = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'API_ID': userModel.id.toString(),
      });
      CacheHelper.saveData(key: 'token', value: data['token']);
      CacheHelper.saveData(key: 'email', value: userModel.email);
      CacheHelper.saveData(key: 'password', value: loginModel.password);
      CacheHelper.saveData(key: 'id', value: userModel.id);
      CacheHelper.saveData(key: 'phone', value: userModel.phone);
      CacheHelper.saveData(key: 'name', value: userModel.name);
      CacheHelper.saveData(key: 'type', value: userModel.type);
      CacheHelper.saveData(key: 'country', value: userModel.country);
      CacheHelper.saveData(key: 'bio', value: userModel.bio);
      CacheHelper.saveData(key: 'image', value: userModel.image);
      CacheHelper.saveData(key: 'facebook', value: userModel.facebook);
      CacheHelper.saveData(key: 'instagram', value: userModel.instagram);
      CacheHelper.saveData(key: 'twitter', value: userModel.twitter);
      CacheHelper.saveData(key: 'snapchat', value: userModel.snapchat);
      CacheHelper.saveData(key: 'tiktok', value: userModel.tiktok);
      CacheHelper.saveData(key: 'age', value: userModel.age);
      CacheHelper.saveData(key: 'position', value: userModel.position);
      CacheHelper.saveData(key: 'placeOfWork', value: userModel.placeOfWork);
      CacheHelper.saveData(key: 'countryImage', value: userModel.countryImage);
      CacheHelper.saveData(key: 'fcmToken', value: data["data"]['fcm_token']);
      if (pageName == 'login') {
        showToast(text: data['message'], state: ToastStates.SUCCESS);
      }
      isLoading = false;
      notifyListeners();
      if (userModel.toMap().containsValue('')) {
        String token = CacheHelper.getData(key: 'token') ?? '';
        navigateAndFinish(
            context, Profile(token, 'home', false, false, '', false));
      } else {
        navigateAndFinish(context, const Home());
      }
    } else if (response.statusCode == 200 && data['status'] == false) {
      if (pageName == 'login') {
        showToast(text: data['message'], state: ToastStates.ERROR);
      }
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void userLogout(BuildContext context) async {
    var url = Uri.parse('https://iffsma-2030.com/public/api/v1/user/logout');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${CacheHelper.getData(key: 'token')}',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      showToast(text: data['message'], state: ToastStates.SUCCESS);
      CacheHelper.saveData(key: 'token', value: '');
      CacheHelper.saveData(key: 'email', value: '');
      CacheHelper.saveData(key: 'id', value: '');
      CacheHelper.saveData(key: 'phone', value: '');
      CacheHelper.saveData(key: 'name', value: '');
      CacheHelper.saveData(key: 'type', value: '');
      CacheHelper.saveData(key: 'country', value: '');
      CacheHelper.saveData(key: 'bio', value: '');
      CacheHelper.saveData(key: 'image', value: '');
      CacheHelper.saveData(key: 'facebook', value: '');
      CacheHelper.saveData(key: 'instagram', value: '');
      CacheHelper.saveData(key: 'twitter', value: '');
      CacheHelper.saveData(key: 'snapchat', value: '');
      CacheHelper.saveData(key: 'tiktok', value: '');
      CacheHelper.saveData(key: 'age', value: '');
      CacheHelper.saveData(key: 'position', value: '');
      CacheHelper.saveData(key: 'placeOfWork', value: '');
      CacheHelper.saveData(key: 'countryImage', value: '');
      CacheHelper.saveData(key: 'password', value: '');
      navigateAndFinish(context, const LogIn());
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> getDataUser(BuildContext context, String token) async {
    isLoading = true;
    userModel = UserModel(
      id: CacheHelper.getData(key: 'id'),
      name: CacheHelper.getData(key: 'name'),
      email: CacheHelper.getData(key: 'email'),
      phone: CacheHelper.getData(key: 'phone'),
      type: CacheHelper.getData(key: 'type'),
      bio: CacheHelper.getData(key: 'bio'),
      image: '',
      facebook: CacheHelper.getData(key: 'facebook'),
      instagram: CacheHelper.getData(key: 'instagram'),
      twitter: CacheHelper.getData(key: 'twitter'),
      snapchat: CacheHelper.getData(key: 'snapchat'),
      tiktok: CacheHelper.getData(key: 'tiktok'),
      country: CacheHelper.getData(key: 'country'),
      age: CacheHelper.getData(key: 'age'),
      position: CacheHelper.getData(key: 'position'),
      placeOfWork: CacheHelper.getData(key: 'placeOfWork'),
      countryImage: '',
      courses: [],
    );
    String body = json.encode(userModel.toMap());
    var url =
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/edit/profile');
    var response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(data["data"]);
      userModel.image = CacheHelper.getData(key: 'image') ?? '';
      userModel.countryImage = CacheHelper.getData(key: 'countryImage') ?? '';
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDataOtherUser(BuildContext context, String id) async {
    String token = CacheHelper.getData(key: 'token');
    var url =
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/profile?id=$id');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(data["data"]);
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void changeUserImage(BuildContext context, String token) async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImage = File(pickedImageFile!.path);
    showToast(text: 'انتظر جارى تغيير الصورة', state: ToastStates.WARNING);
    isLoading = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/edit/profile'));
    request.fields.addAll({
      'id': CacheHelper.getData(key: 'id').toString(),
      'name': CacheHelper.getData(key: 'name'),
      'email': CacheHelper.getData(key: 'email'),
      'phone': CacheHelper.getData(key: 'phone'),
      'type': CacheHelper.getData(key: 'type'),
      'bio': CacheHelper.getData(key: 'bio') ?? '',
      'facebook': CacheHelper.getData(key: 'facebook') ?? '',
      'instagram': CacheHelper.getData(key: 'instagram') ?? '',
      'twitter': CacheHelper.getData(key: 'twitter') ?? '',
      'snapchat': CacheHelper.getData(key: 'snapchat') ?? '',
      'tiktok': CacheHelper.getData(key: 'tiktok') ?? '',
      'country': CacheHelper.getData(key: 'country') ?? '',
      'age': CacheHelper.getData(key: 'age') ?? '',
      'position': CacheHelper.getData(key: 'position') ?? '',
      'Employer_name': CacheHelper.getData(key: 'placeOfWork') ?? '',
      'fcm_token': CacheHelper.getData(key: 'fcmToken') ?? '',
    });
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedImageFile.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      String token = CacheHelper.getData(key: 'fcmToken') ?? '';
      LoginModel loginModel = LoginModel(
        email: CacheHelper.getData(key: 'email'),
        password: CacheHelper.getData(key: 'password'),
        token: token,
      );
      userLogin(context, loginModel, '');
      showToast(text: 'تم تغيير الصورة بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void changeUserCountryImage(BuildContext context, String token) async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImage = File(pickedImageFile!.path);
    showToast(text: 'انتظر جارى تغيير الصورة', state: ToastStates.WARNING);
    isLoading = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/edit/profile'));
    request.fields.addAll({
      'id': CacheHelper.getData(key: 'id').toString(),
      'name': CacheHelper.getData(key: 'name'),
      'email': CacheHelper.getData(key: 'email'),
      'phone': CacheHelper.getData(key: 'phone'),
      'type': CacheHelper.getData(key: 'type'),
      'bio': CacheHelper.getData(key: 'bio') ?? '',
      'facebook': CacheHelper.getData(key: 'facebook') ?? '',
      'instagram': CacheHelper.getData(key: 'instagram') ?? '',
      'twitter': CacheHelper.getData(key: 'twitter') ?? '',
      'snapchat': CacheHelper.getData(key: 'snapchat') ?? '',
      'tiktok': CacheHelper.getData(key: 'tiktok') ?? '',
      'country': CacheHelper.getData(key: 'country') ?? '',
      'age': CacheHelper.getData(key: 'age') ?? '',
      'position': CacheHelper.getData(key: 'position') ?? '',
      'Employer_name': CacheHelper.getData(key: 'placeOfWork') ?? '',
      'fcm_token': CacheHelper.getData(key: 'fcmToken') ?? '',
    });
    request.files.add(await http.MultipartFile.fromPath(
        'country_image', pickedImageFile.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      String token = CacheHelper.getData(key: 'fcmToken') ?? '';
      LoginModel loginModel = LoginModel(
        email: CacheHelper.getData(key: 'email'),
        password: CacheHelper.getData(key: 'password'),
        token: token,
      );
      userLogin(context, loginModel, '');
      showToast(text: 'تم تغيير الصورة بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void updateUserData(
    BuildContext context,
    String token,
    String name,
    String email,
    String phone,
    String type,
    String country,
    String bio,
    String facebook,
    String instagram,
    String twitter,
    String snapchat,
    String tiktok,
    String age,
    String position,
    String web,
  ) async {
    isLoading = true;
    notifyListeners();
    userModel = UserModel(
      id: CacheHelper.getData(key: 'id'),
      name: name,
      email: email,
      phone: phone,
      type: type,
      bio: bio,
      image: '',
      facebook: facebook,
      instagram: instagram,
      twitter: twitter,
      snapchat: snapchat,
      tiktok: tiktok,
      country: country,
      age: age,
      position: position,
      placeOfWork: web,
      countryImage: '',
      courses: [],
    );
    String body = json.encode(userModel.toMap());
    var url =
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/edit/profile');
    var response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(data["data"]);
      userModel.image = CacheHelper.getData(key: 'image');
      CacheHelper.saveData(key: 'phone', value: phone);
      CacheHelper.saveData(key: 'name', value: name);
      CacheHelper.saveData(key: 'email', value: email);
      CacheHelper.saveData(key: 'type', value: type);
      CacheHelper.saveData(key: 'country', value: country);
      CacheHelper.saveData(key: 'bio', value: bio);
      CacheHelper.saveData(key: 'facebook', value: facebook);
      CacheHelper.saveData(key: 'instagram', value: instagram);
      CacheHelper.saveData(key: 'twitter', value: twitter);
      CacheHelper.saveData(key: 'snapchat', value: snapchat);
      CacheHelper.saveData(key: 'tiktok', value: tiktok);
      CacheHelper.saveData(key: 'age', value: age);
      CacheHelper.saveData(key: 'position', value: position);
      showToast(text: 'تم تحديث البيانات بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectReportImage() async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    reportImage = File(pickedImageFile!.path);
  }

  Future<void> sendReport(String userReported, String reason) async {
    String token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    isLoading = true;
    notifyListeners();
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/send/communication'));
    request.fields.addAll({
      'user_id': id.toString(),
      'reported_id': userReported,
      'message': reason,
    });
    if (reportImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('proof_image', reportImage!.path));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      showToast(
          text: 'تم إرسال البلاغ للمسئول بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: 'يوجد خطأ', state: ToastStates.ERROR);
    }
    isLoading = false;
    notifyListeners();
  }

  void deleteAccount(BuildContext context) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id');
    var fb = FirebaseAuth.instance.currentUser!.uid;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/delete/account'));
    request.fields.addAll({
      'id': id.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      await FirebaseFirestore.instance.collection('users').doc(fb).delete();
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();
      CacheHelper.saveData(key: 'token', value: '');
      CacheHelper.saveData(key: 'email', value: '');
      CacheHelper.saveData(key: 'id', value: '');
      CacheHelper.saveData(key: 'phone', value: '');
      CacheHelper.saveData(key: 'name', value: '');
      CacheHelper.saveData(key: 'type', value: '');
      CacheHelper.saveData(key: 'country', value: '');
      CacheHelper.saveData(key: 'bio', value: '');
      CacheHelper.saveData(key: 'image', value: '');
      CacheHelper.saveData(key: 'facebook', value: '');
      CacheHelper.saveData(key: 'instagram', value: '');
      CacheHelper.saveData(key: 'twitter', value: '');
      CacheHelper.saveData(key: 'snapchat', value: '');
      CacheHelper.saveData(key: 'tiktok', value: '');
      showToast(
          text: language ? 'Deleted' : 'تم حذف حسابك بنجاح',
          state: ToastStates.SUCCESS);
      navigateAndFinish(context, const LogIn());
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void checkExistAccount(
    String email,
    String password,
    String confirmPassword,
    String name,
  ) async {
    isLoading = true;
    notifyListeners();
    var headers = {
      'Accept': 'application/json',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/user/reset/password/$email'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      if (decodedData['message'] == 'البريد الالكترونى غير موجود') {
        showToast(
            text: 'البريد الالكترونى غير موجود', state: ToastStates.WARNING);
        isLoading = false;
        notifyListeners();
      } else {
        updatePassword(
          email,
          password,
          confirmPassword,
          name,
        );
        isLoading = false;
        notifyListeners();
      }
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void updatePassword(
    String email,
    String password,
    String confirmPassword,
    String name,
  ) async {
    var headers = {
      'Accept': 'application/json',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/user/update/password'));
    request.fields.addAll({
      'email': email,
      'new_password': password,
      'password_confirmation': confirmPassword,
      'name': name,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200 && decodedData['status']) {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .snapshots()
          .listen((data) async {
        for (var doc in data.docs) {
          try {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: email, password: doc['password'])
                .then((value) async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.uid)
                  .update({
                'password': password,
              }).then((_) async {
                await value.user!.updatePassword(password).then((value) async {
                  await FirebaseAuth.instance.signOut();
                });
              });
            });
          } catch (e) {
            showToast(text: e.toString(), state: ToastStates.ERROR);
          }
        }
      });
      showToast(
          text: language ? 'Password Updated' : 'تم تحديث كلمة السر بنجاح',
          state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      if (decodedData['message'] == 'هناك خطأ فى البياات') {
        showToast(
            text: 'هذا ليس حسابك, خطأ فى اسم المستخدم',
            state: ToastStates.ERROR);
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> googleSignUp(BuildContext context) async {
    bool isSignedIn = false;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn) {
        googleSignIn.signOut();
      }
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await auth.signInWithCredential(credential)).user!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'password': '',
        'FB_ID': user.uid,
        'API_ID': '',
      });
      await socialLogin('google', context, user);
    } catch (e) {
      showToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  Future<void> socialLogin(String type, BuildContext context, User user) async {
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/register/social-media'));
    request.fields.addAll({
      'name': user.displayName.toString(),
      'email': user.email.toString(),
      'social_login_by': type
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(decodedData["data"]);
      var id = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'API_ID': userModel.id.toString(),
      });
      CacheHelper.saveData(key: 'token', value: decodedData['token']);
      CacheHelper.saveData(key: 'email', value: userModel.email);
      CacheHelper.saveData(key: 'id', value: userModel.id);
      CacheHelper.saveData(key: 'phone', value: userModel.phone);
      CacheHelper.saveData(key: 'name', value: userModel.name);
      CacheHelper.saveData(key: 'type', value: userModel.type);
      CacheHelper.saveData(key: 'country', value: userModel.country);
      CacheHelper.saveData(key: 'bio', value: userModel.bio);
      CacheHelper.saveData(key: 'image', value: userModel.image);
      CacheHelper.saveData(key: 'facebook', value: userModel.facebook);
      CacheHelper.saveData(key: 'instagram', value: userModel.instagram);
      CacheHelper.saveData(key: 'twitter', value: userModel.twitter);
      CacheHelper.saveData(key: 'snapchat', value: userModel.snapchat);
      CacheHelper.saveData(key: 'tiktok', value: userModel.tiktok);
      CacheHelper.saveData(key: 'age', value: userModel.age);
      CacheHelper.saveData(key: 'position', value: userModel.position);
      CacheHelper.saveData(key: 'placeOfWork', value: userModel.placeOfWork);
      CacheHelper.saveData(key: 'countryImage', value: userModel.countryImage);
      CacheHelper.saveData(key: 'password', value: '');
      showToast(text: 'تم التسجيل بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
      String token = CacheHelper.getData(key: 'token') ?? '';
      await getDataUser(context, token);
      navigateAndFinish(
          context, Profile(token, 'home', false, false, '', true));
    } else {
      isLoading = false;
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void getRegisterNumber() async {
    randomString = '';
    var headers = {'Accept': 'application/json'};
    var request = http.Request('GET',
        Uri.parse('https://iffsma-2030.com/public/api/v1/random-string'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      randomString = decodedData['random_string'];
    } else {
      showToast(text: "Error", state: ToastStates.ERROR);
    }
    notifyListeners();
  }
}
