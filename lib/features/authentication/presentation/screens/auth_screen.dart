import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/widgets/buttons.dart';
import 'package:ecofier_viz/features/authentication/presentation/widgets/inputs.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Connexion',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Champ numéro de téléphone
                  AppTextInput(
                    isReadOnly: false,
                    controller: _usernameController,
                    labelText: "Matricule",
                    // description: "Veuillez saisir votre matricule",
                    width: 284,
                    prefixIcon: AppIcons.avatar,
                    validator: (p0) {},
                  ),
                  const SizedBox(height: 16),
                  AppPasswordInput(
                    controller: _passwordController,
                    labelText: "Mot de passe",
                    // description: "Veuillez saisir votre mot de passe",
                    width: 284,
                    validatePassword: (p0) {},
                  ),
                  const SizedBox(height: 24),
                  // Bouton de validation
                  AppButton(
                    width: 284,
                    title: "Connexion",
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),

                  // Texte bas de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("J'ai déjà un compte ? "),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Créer un compte',
                          style: TextStyle(
                            color: AppColors.green1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
