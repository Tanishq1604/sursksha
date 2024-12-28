class UserModel {
  final String name;
  final String mobile;
  final String email;
  final Map<String, dynamic> contacts;

  UserModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.contacts,
  });
}
