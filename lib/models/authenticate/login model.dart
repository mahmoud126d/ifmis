class LoginModel {
  late String email;
  late String password;
  late String token;

  LoginModel({
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'fcm_token': token
    };
  }
}
