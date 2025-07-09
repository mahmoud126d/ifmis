
import '../language/language.dart';

class SportsCoursesModel {
  late int id;
  late LanguageModel name;
  late String image;
  late String fileOfCourse;
  late String successRate;
  late String videoLink;
  late LanguageModel trainer;
  late String status;
  late String open;
  late String close;
  late String type;
  List<Questions> questions = [];

  SportsCoursesModel({
    required this.id,
    required this.name,
    required this.image,
    required this.fileOfCourse,
    required this.successRate,
    required this.videoLink,
    required this.trainer,
    required this.questions,
    required this.status,
    required this.open,
    required this.close,
    required this.type,
  });

  SportsCoursesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = LanguageModel.fromJSON(json['name']);
    image = json['image'];
    fileOfCourse = json['file_of_course'];
    successRate = json['success_rate'];
    videoLink = json['video_link'];
    trainer = json['coach_name'] == null ? LanguageModel(ar: '', en: '') : LanguageModel.fromJSON(json['coach_name']);
    status = json['status'];
    open = json['open_course_date'] ?? '';
    close = json['close_course_date'] ?? '';
    type = json['type_of_course'] ?? 'public_course';
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }
}

class Questions {
  late int id;
  late String name;
  late String answer;
  late String educationalCourseId;

  Questions({
    required this.id,
    required this.name,
    required this.answer,
    required this.educationalCourseId,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    answer = json['answer'];
    educationalCourseId = json['educational_course_id'];
  }
}

class UserAnswer {
  late int id;
  late String name;
  late String answer;
  late String educationalCourseId;
  late String answerFromUser;

  UserAnswer({
    required this.id,
    required this.name,
    required this.answer,
    required this.educationalCourseId,
    required this.answerFromUser,
  });
}

class CreateQuestions {
  late String name;
  late String answer;

  CreateQuestions({
    required this.name,
    required this.answer,
  });
}

class SuccessStudents {
  late int id;
  late String educationalCourseId;
  late String userId;
  late String degreeSuccess;
  late Student student;

  SuccessStudents({
    required this.id,
    required this.educationalCourseId,
    required this.userId,
    required this.degreeSuccess,
    required this.student,
  });

  SuccessStudents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    educationalCourseId = json['educational_course_id'];
    userId = json['user_id'];
    degreeSuccess = json['degree_success'];
    student =
        (json['student'] != null ? Student.fromJson(json['student']) : null)!;
  }
}

class Student {
  late int id;
  late String name;
  late String image;

  Student({
    required this.id,
    required this.name,
    required this.image,
  });

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'] ?? '';
  }
}

class CourseCategory {
  late int id;
  late LanguageModel name;
  late String image;

  CourseCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  CourseCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? LanguageModel(ar: '', en: '') : LanguageModel.fromJSON(json['name']);
    image = json['image'];
  }
}
