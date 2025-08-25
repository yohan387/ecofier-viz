import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/widgets/buttons.dart';
import 'package:ecofier_viz/presentation/authentication/state/login_cubit/login_cubit.dart';
import 'package:ecofier_viz/presentation/authentication/widgets/inputs.dart';
import 'package:ecofier_viz/presentation/visualisation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return AppButton(
                width: 284,
                title: "Connexion",
                icon: state is LoginLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                onTap: () {
                  if (state is LoginLoading) return;
                  context.read<LoginCubit>().login(
                        _usernameController.text,
                        _passwordController.text,
                      );

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              );
            },
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
