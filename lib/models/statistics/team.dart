class TeamModel {
  String teamID;
  String teamLogo;
  String team;
  String pld;
  String won;
  String draw;
  String lost;
  String matchLeft;
  String goalPlusMinus;
  String diff;
  String? pts;
  String champName;

  TeamModel({
    required this.teamLogo,
    required this.teamID,
    required this.team,
    required this.pld,
    required this.won,
    required this.draw,
    required this.lost,
    required this.matchLeft,
    required this.goalPlusMinus,
    required this.diff,
    required this.pts,
    required this.champName,
  });

  factory TeamModel.fromJSON(Map<String, dynamic> json) {
    return TeamModel(
      teamID: json['teamID'],
      teamLogo: json['teamImage'],
      team: json['teamName'],
      pld: json['numberOfGoalsReceived'],
      won: json['numberOfMatchesWon'],
      draw: json['numberOfMatchesDraw'],
      lost: json['numberOfMatchesDefeat'],
      matchLeft: json['numberOfMatches'],
      goalPlusMinus: json['numberOfGoals'],
      diff: json['numberOfDifference'],
      pts: json['numberOfPoints'],
      champName: json['champName'],
    );
  }
}
