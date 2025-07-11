import 'package:ecofier_viz/features/authentication/presentation/widgets/inputs.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
                  const PhoneInput(),
                  const SizedBox(height: 16),
                  // Champ mot de passe
                  const PasswordInput(),
                  const SizedBox(height: 24),
                  // Bouton de validation
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Valider'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 30, 95, 33), // background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(44), // custom shape
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20), // custom padding
                      textStyle: TextStyle(
                        fontSize: 20, // text size
                      ),
                    ),
                  ),

                  // Texte bas de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("J'ai déjà un compte ? "),
                      GestureDetector(
                        onTap: () {
                          // Action pour créer un compte
                        },
                        child: Text(
                          'Créer un compte',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
