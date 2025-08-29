import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String phoneNumber;
  final String password;
  final String email;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.email,
  });

  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}';
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, phoneNumber, password, email];
}
