import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/widgets/buttons.dart';
import 'package:ecofier_viz/presentation/authentication/widgets/inputs.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  final void Function(bool) setIsLogin;
  const LoginWidget({super.key, required this.setIsLogin});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              const Text("Pas de compte ? "),
              TextButton(
                onPressed: () {
                  widget.setIsLogin(false);
                },
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
    );
  }
}
