import 'package:ecofier_viz/models/user.dart';

class AuthRepository {
  Future<void> registerClient({
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String password,
  }) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  Future<User> login(String phoneNumber, String password) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    return User(
      id: '1',
      firstName: "firstname",
      lastName: "lastname",
      phoneNumber: phoneNumber,
      password: password,
      email: 'user@example.com',
    );
  }

  Future<void> logout() async {
    return Future.delayed(const Duration(seconds: 1));
  }
}
