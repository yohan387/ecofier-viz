import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/utils/validators.dart';
import 'package:ecofier_viz/core/widgets/buttons.dart';
import 'package:ecofier_viz/presentation/authentication/state/register_client/register_client_cubit.dart';
import 'package:ecofier_viz/presentation/authentication/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWidget extends StatefulWidget {
  final void Function(bool) setIsLogin;
  const SignInWidget({super.key, required this.setIsLogin});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Champ numéro de téléphone
            AppTextInput(
              isReadOnly: false,
              controller: _firstNameController,
              labelText: "Nom",
              width: 284,
              prefixIcon: AppIcons.avatar,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 6),
            AppTextInput(
              isReadOnly: false,
              controller: _lastNameController,
              labelText: "Prénoms",
              width: 284,
              prefixIcon: AppIcons.avatar,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Veuillez entrer votre prénom';
                }
                return null;
              },
            ),
            const SizedBox(height: 6),
            AppTextInput(
              isReadOnly: false,
              controller: _phoneNumberController,
              labelText: "Téléphone",
              width: 284,
              prefixIcon: AppIcons.phone,
              validator: phoneNumberValidator,
            ),
            const SizedBox(height: 6),
            AppPasswordInput(
              controller: _passwordController,
              labelText: "Mot de passe",
              width: 284,
            ),
            const SizedBox(height: 16),
            // Bouton de validation
            BlocBuilder<RegisterClientCubit, RegisterClientState>(
              builder: (context, state) {
                return AppButton(
                  width: 284,
                  title: "Créer mon compte",
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (state is RegisterClientLoading) return;
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<RegisterClientCubit>().register(
                            firstname: _firstNameController.text,
                            lastname: _lastNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            password: _passwordController.text,
                          );
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 16),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
