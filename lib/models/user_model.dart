class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String companyName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      companyName: json['company']?['name'] ?? '',
    );
  }
}