import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String phoneNumber;
  final String? password;
  final String email;
  final String? accessToken;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.password,
    required this.email,
    this.accessToken,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['data']['id'],
      firstName: json['data']['nom'],
      lastName: json['data']['prenoms'],
      phoneNumber: json['data']['telephone'],
      email: json['data']['email'],
      accessToken: json['accessToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': {
        'id': id,
        'nom': firstName,
        'prenoms': lastName,
        'telephone': phoneNumber,
        'email': email,
      },
      'accessToken': accessToken,
    };
  }

  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}';
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, phoneNumber, password, email];
}
