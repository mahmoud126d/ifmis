class MatchesScoresModel {
  String rank;
  String name;
  String img;
  String goals;
  String aldawla;
  String logo;
  String champName;

  MatchesScoresModel({
    required this.name,
    required this.rank,
    required this.img,
    required this.goals,
    required this.aldawla,
    required this.logo,
    required this.champName,
  });

  factory MatchesScoresModel.fromJSON(Map<String, dynamic> json) {
    return MatchesScoresModel(
      name: json['playerName'],
      rank: json['playerId'],
      img: json['playerImage'] ?? '',
      goals: json['playerNumberOfScore'],
      aldawla: json['nameOfClub'],
      logo: json['imageOfClub'] ?? '',
      champName: json['champName'] ?? '',
    );
  }
}
