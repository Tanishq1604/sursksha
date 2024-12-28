class UserModel {
  final String name;
  final String email;
  final String mobile;
  Map<String, dynamic> contacts;
  bool isSafe;

  UserModel({
    required this.name,
    required this.email,
    required this.mobile,
    this.contacts = const {},
    this.isSafe = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      contacts: json['contacts'] ?? {},
      isSafe: json['isSafe'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'mobile': mobile,
        'contacts': contacts,
        'isSafe': isSafe,
      };
}
