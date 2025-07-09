class PlayerModel {
  late String name;
  late String profile;
  late String money;
  late String birthDate;
  late String birthPlace;
  late String birthPlaceLogo;
  late String age;
  late String height;
  late String citizen;
  late String position;
  late String foot;
  late String playerAgent;
  late String currentCub;
  late String currentCubLogo;
  late String joinedDate;
  late String contractExpire;
  late String outFitter;
  late String goals;

  PlayerModel({
    required this.name,
    required this.profile,
    required this.money,
    required this.birthDate,
    required this.birthPlace,
    required this.birthPlaceLogo,
    required this.age,
    required this.height,
    required this.citizen,
    required this.position,
    required this.foot,
    required this.playerAgent,
    required this.currentCub,
    required this.currentCubLogo,
    required this.joinedDate,
    required this.contractExpire,
    required this.outFitter,
    required this.goals,
  });

  factory PlayerModel.fromJSON(Map<String, dynamic> json) {
    return PlayerModel(
      name: json['playerName'].toString().replaceAll(' ', '') ?? '',
      profile: json['playerImage'].toString().replaceAll(' ', '') ?? '',
      money: json['payerPrice'].toString().replaceAll(' ', '') ?? '',
      birthDate: json['playerDateOfBirth'].toString().replaceAll(' ', '') ?? '',
      birthPlace: json['placeOfBirth'].toString().replaceAll(' ', '') ?? '',
      birthPlaceLogo: json['payerNaImage'].toString().replaceAll(' ', '') ?? '',
      age: json['playerOfAge'].toString().replaceAll(' ', '') ?? '',
      height: json['playerHeight'].toString().replaceAll(' ', '') ?? '',
      citizen: json['playerOfCitizenship'].toString().replaceAll(' ', '') ?? '',
      position: json['playerCenter'].toString().replaceAll(' ', '') ?? '',
      foot: json['playerOfFoot'].toString().replaceAll(' ', '') ?? '',
      playerAgent: json['playerOfAgent'].toString().replaceAll(' ', '') ?? '',
      currentCub:
          json['playerOfCurrentClub'].toString().replaceAll(' ', '') ?? '',
      currentCubLogo:
          json['payerClubImage'].toString().replaceAll(' ', '') ?? '',
      joinedDate:
          json['playerOfJoinedDate'].toString().replaceAll(' ', '') ?? '',
      contractExpire:
          json['playerOfContractExpires'].toString().replaceAll(' ', '') ?? '',
      outFitter: json['playerOfOutfitter'].toString().replaceAll(' ', '') ?? '',
      goals: json['playerCupCount'].toString().replaceAll(' ', '').replaceAll('Caps/Goals:', ''),
    );
  }
}
