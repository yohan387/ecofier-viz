import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/widgets/buttons.dart';
import 'package:ecofier_viz/features/authentication/presentation/widgets/inputs.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatefulWidget {
  final void Function(bool) setIsLogin;
  const SignInWidget({super.key, required this.setIsLogin});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
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
            labelText: "Nom et prénoms",
            description: "Veuillez saisir votre nom et prénoms",
            width: 284,
            prefixIcon: AppIcons.avatar,
            validator: (p0) {},
          ),
          const SizedBox(height: 16),
          AppTextInput(
            isReadOnly: false,
            controller: _phoneNumberController,
            labelText: "Téléphone",
            description: "Veuillez saisir votre téléphone",
            width: 284,
            prefixIcon: AppIcons.phone,
            validator: (p0) {},
          ),
          const SizedBox(height: 16),
          AppPasswordInput(
            controller: _passwordController,
            labelText: "Mot de passe",
            description: "Veuillez définir votre mot de passe",
            width: 284,
            validatePassword: (p0) {},
          ),
          const SizedBox(height: 24),
          // Bouton de validation
          AppButton(
            width: 284,
            title: "Créer mon compte",
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
              const Text("J'ai déjà un compte,"),
              TextButton(
                onPressed: () {
                  widget.setIsLogin(true);
                },
                child: const Text(
                  'Me connecter',
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
