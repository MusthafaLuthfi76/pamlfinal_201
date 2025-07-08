class LoginRequest {
  final String name;
  final String password;

  LoginRequest({
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "password": password,
  };
}
