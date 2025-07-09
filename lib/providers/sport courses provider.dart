import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
//import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sports%20courses/Sports%20courses.dart';
import 'package:http/http.dart' as http;
import '../network/cash_helper.dart';
import 'package:path_provider/path_provider.dart';
import '../shared/Components.dart';

class SportCoursesProvider with ChangeNotifier {
  bool isLoading = false;
  List<SportsCoursesModel> courses = [];
  List<SuccessStudents> successStudents = [];
  int index = 0;
  bool startExam = false;
  bool startCreateExam = false;
  double degree = 0.0;
  List<UserAnswer> answers = [];
  List<CreateQuestions> questions = [];
  CreateQuestions questionModel = CreateQuestions(name: '', answer: '');
  File? courseImage;
  File? paperCourseFile;
  var picker = ImagePicker();
  TextEditingController question = TextEditingController();
  bool isExamined = false;
  double firstStudent = 0.0;
  List<CourseCategory> categories = [];

  Future<void> getCoursesCategory() async {
    categories = [];
    isLoading = true;
    var token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/educational_course_categories'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        categories.add(CourseCategory.fromJson(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void setAnswersModel(List<Questions> questions) {
    answers = [];
    startExam = true;
    for (var element in questions) {
      UserAnswer userAnswer = UserAnswer(
        id: element.id,
        name: element.name,
        answer: element.answer,
        educationalCourseId: element.educationalCourseId,
        answerFromUser: '',
      );
      answers.add(userAnswer);
    }
  }

  void changeQuestionIndex(int value) {
    index = value;
    notifyListeners();
  }

  Future<void> finishExam() async {
    startExam = false;
    degree = 0.0;
    double questionDegree =
        double.parse((100 / answers.length).toStringAsFixed(2));
    for (var element in answers) {
      if (element.answer == element.answerFromUser) {
        degree += questionDegree;
        degree = double.parse(degree.toStringAsFixed(1));
      }
    }
    if (degree > 100) {
      degree = 100.0;
    }
    notifyListeners();
  }

  void setCreateExamValue(bool value) {
    startCreateExam = value;
    notifyListeners();
  }

  void setQuestionModel(CreateQuestions question) {
    questionModel = question;
    notifyListeners();
  }

  void setQuestionModelName(String name) {
    questionModel.name = name;
    notifyListeners();
  }

  void changeQuestionValue(String text) {
    question.text = text;
    notifyListeners();
  }

  void addQuestion(CreateQuestions question) {
    questions.add(question);
    notifyListeners();
  }

  void getCourses(String id) async {
    courses = [];
    var token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'https://iffsma-2030.com/public/api/v1/educational/courses/$id');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        courses.add(SportsCoursesModel.fromJson(element));
      });
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void pickCourseImage() async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      courseImage = File(pickedImageFile.path);
      notifyListeners();
    }
    if (courseImage != null) {
      showToast(
          text: 'تم إختيار صورة الدورة بنجاح', state: ToastStates.SUCCESS);
    }
  }

  Future<void> pickPaperCourseFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      paperCourseFile = File(result.files.first.path.toString());
      showToast(text: 'تم إختيار ملف الدورة بنجاح', state: ToastStates.SUCCESS);
    }
    notifyListeners();
  }

  Future<void> filterQuestions() async {
    for (var element in questions) {
      if (element.name == '' || element.answer == '') {
        questions.remove(element);
      }
    }
    notifyListeners();
  }

  Future<void> createSportCourse(
    String nameAR,
    String nameEN,
    String trainerAR,
    String trainerEN,
    String video,
    String successRate,
    String categoryID,
    String openDate,
    String closeDate,
    String type,
  ) async {
    var token = CacheHelper.getData(key: 'token') ?? '';
    bool language = CacheHelper.getData(key: 'language') ?? false;
    if (courseImage == null) {
      if (language) {
        showToast(
            text: 'You must select a course image', state: ToastStates.SUCCESS);
      } else {
        showToast(text: 'يجب إختيار صورة الدورة', state: ToastStates.SUCCESS);
      }
    } else if (paperCourseFile == null) {
      if (language) {
        showToast(
            text: 'The course file must be selected',
            state: ToastStates.SUCCESS);
      } else {
        showToast(text: 'يجب إختيار ملف الدورة', state: ToastStates.SUCCESS);
      }
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
              'https://iffsma-2030.com/public/api/v1/educational/courses/create'));
      for (int i = 0; i < questions.length; i++) {
        request.fields.addAll({
          'coursesQuestions[$i][question_name]': questions[i].name,
          'coursesQuestions[$i][success_answer]': questions[i].answer,
        });
      }
      request.fields.addAll({
        'name_en': nameEN,
        'name_ar': nameAR,
        'video_link': video,
        'success_rate': successRate,
        'educational_course_category_id': categoryID,
        'coach_name_ar': trainerAR,
        'coach_name_en': trainerEN,
        'open_course_date': openDate,
        'close_course_date': closeDate,
        'type_of_course': type,
      });
      request.files
          .add(await http.MultipartFile.fromPath('image', courseImage!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'file_of_course', paperCourseFile!.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        if (language) {
          showToast(
              text: 'Course Created Successfully Wait for Admin Acceptance',
              state: ToastStates.SUCCESS);
        } else {
          showToast(
              text: 'تم إنشاء الدورة بنجاح انتظر القبول من الأدمن',
              state: ToastStates.SUCCESS);
        }

        isLoading = false;
        notifyListeners();
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<String> _getSavedFilePath(Uint8List bytes) async {
    if (Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      final image = File('${dir.path}email.png');
      image.writeAsBytesSync(bytes);
      return image.path;
    } else {
      return '';
      // return FileSaver.instance.saveFile(
      //   name: '${DateTime.now()}email',
      //   bytes: bytes,
      //   mimeType: MimeType.png,
      // );
    }
  }

  Future<void> sendCertificateToEmail(
      String email, Uint8List bytes, String courseName) async {
    showToast(
        text: 'انتظر جاري إرسال الشهادة على الاميل الخاص بك',
        state: ToastStates.WARNING);
    final String imagePath = await _getSavedFilePath(bytes);
    var token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/educational/courses/send/email'));
    request.fields.addAll({
      'message': 'نشكركم على المشاركة بدورة $courseName بتطبيق الإتحاد الدولي',
      'to': email,
    });
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(
          text: 'تم إرسال الشهادة على الاميل الخاص بك',
          state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> checkTestDuration(String courseID) async {
    var token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    isExamined = false;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/check/test/duration'));
    request.fields.addAll({
      'educational_course_id': courseID,
      'user_id': id.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      if (decodedData['message'] == 'لا يمكنك الدخول الى الاختبار') {
        isExamined = true;
        notifyListeners();
      } else {
        isExamined = false;
        notifyListeners();
      }
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> studentSuccess(String courseID) async {
    var token = CacheHelper.getData(key: 'token') ?? '';
    var id = CacheHelper.getData(key: 'id') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/successful/students'));
    request.fields.addAll({
      'course_id': courseID.toString(),
      'user_id': id.toString(),
      'degree_success': degree.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'مبروك اجتيازك الدورة', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> getSuccessfulStudent(String courseID) async {
    successStudents = [];
    firstStudent = 0.0;
    var token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/get/successful/students?course_id=$courseID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        successStudents.add(SuccessStudents.fromJson(element));
      });
      for (var element in successStudents) {
        if (double.parse(element.degreeSuccess) > firstStudent) {
          firstStudent = double.parse(element.degreeSuccess);
        }
      }
      successStudents.sort((a, b) => double.parse(b.degreeSuccess)
          .compareTo(double.parse(a.degreeSuccess)));
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> registerShared(int courseID) async {
    try {
      var id = CacheHelper.getData(key: 'id') ?? '';
      var token = CacheHelper.getData(key: 'token') ?? '';
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://iffsma-2030.com/public/api/v1/user/create/participation/course'));
      request.fields.addAll({
        'user_id': id.toString(),
        'educational_course_id': courseID.toString(),
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  bool sharedCourse = false;

  Future<void> countShared(int courseID) async {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    sharedCourse = false;
    var id = CacheHelper.getData(key: 'id') ?? '';
    var token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/user/$id/check/participation/course/$courseID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      if (decodedData['message'] == 'لقد شاركت الدورة بنجاح20مرة') {
        sharedCourse = true;
      } else {
        showToast(
          text: language
              ? 'Dear participant, in order to get the sports course for free, you must share the course with 20 people and bring them to the application.'
              : 'عزيزى المشارك من أجل الحصول على الدورة الرياضية مجانا عليك مشاركة الدورة مع 20 شخص و جلبهم للتطبيق.',
          state: ToastStates.WARNING,
          gravity: ToastGravity.CENTER,
          time: 10,
        );
      }
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }
}
