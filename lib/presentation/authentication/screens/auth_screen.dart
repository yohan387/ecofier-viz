import 'package:ecofier_viz/presentation/authentication/widgets/login_widget.dart';
import 'package:ecofier_viz/presentation/authentication/widgets/register_client_widget.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void setIsLogin(bool value) {
    setState(() {
      isLogin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bannière image
            SizedBox(
              height: 256,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(64),
                    ),
                    child: Image.asset(
                      'lib/core/assets/bg_1.jpeg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image, size: 80)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      isLogin ? 'Connexion' : 'Créer un compte',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLogin
                ? LoginWidget(setIsLogin: setIsLogin)
                : SignInWidget(setIsLogin: setIsLogin),
          ],
        ),
      ),
    );
  }
}
