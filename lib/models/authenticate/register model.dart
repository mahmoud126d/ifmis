class RegisterModel {
  late String userName;
  late String email;
  late String password;
  late String token;

  RegisterModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'email': email,
      'password': password,
      'fcm_token': token
    };
  }
}
