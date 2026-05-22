class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String token;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? 'Usuário', 
      lastName: json['lastName'] as String? ?? '',
      token: (json['token'] ?? json['accessToken']) as String? ?? '',
    );
  }

  String get fullName {
    if (lastName.isEmpty) return firstName;
    return '$firstName $lastName';
  }
}
