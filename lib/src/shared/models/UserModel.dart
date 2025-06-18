import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] is int)
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? '0') ?? 0, // 🔥 seguro
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory UserModel.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return UserModel.fromMap(map);
  }

  String toJson() => json.encode(toMap());
}
