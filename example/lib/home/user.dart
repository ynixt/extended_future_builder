import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String name;

  User({
    @required this.id,
    @required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
