import '../language/language.dart';

class MatchesStatisticsModel {
  late String champName;
  late Club firstClub;
  late Club secondClub;
  late String middle;
  late String liveChannel;
  late String matchTime;

  MatchesStatisticsModel({
    required this.champName,
    required this.firstClub,
    required this.secondClub,
    required this.middle,
    required this.liveChannel,
    required this.matchTime,
  });

  MatchesStatisticsModel.fromJson(Map<String, dynamic> json) {
    champName = json['champName'];
    firstClub =
        (json['firstClub'] != null ? Club.fromJson(json['firstClub']) : null)!;
    secondClub = (json['secondClub'] != null
        ? Club.fromJson(json['secondClub'])
        : null)!;
    middle = json['middle'];
    liveChannel = json['liveChannel'];
    matchTime = json['matchTime'].toString().split('-')[3];
  }
}

class Club {
  late String name;
  late String score;
  late String image;

  Club({
    required this.name,
    required this.score,
    required this.image,
  });

  Club.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    score = json['score'];
    image = json['image'].toString().contains('http')
        ? json['image']
        : "https:${json['image']}";
  }
}

class ScreensOfStatistics {
  late LanguageModel name;
  late int id;
  late String image;

  ScreensOfStatistics({
    required this.name,
    required this.id,
    required this.image,
  });

  ScreensOfStatistics.fromJson(Map<String, dynamic> json) {
    name = json['title'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['title']);
    id = json['id'];
    image = json['image'].toString().contains('http')
        ? json['image']
        : "https:${json['image']}";
  }
}
