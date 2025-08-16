import 'package:ecofier_viz/models/user.dart';

class AuthRepository {
  Future<User> login(String username, String password) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    return User(
      id: '1',
      username: username,
      password: password,
      email: 'user@example.com',
    );
  }

  Future<void> logout() async {
    return Future.delayed(const Duration(seconds: 1));
  }
}
