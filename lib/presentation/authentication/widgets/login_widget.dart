import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/utils.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: state.user)),
            (Route<dynamic> route) => false,
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.userMessage)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 32),
              AppTextInput(
                isReadOnly: false,
                controller: _usernameController,
                labelText: "Numéro de téléphone",
                width: 284,
                maxLength: 10,
                prefixIcon: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Text(
                      "🇨🇮",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: phoneNumberValidator,
              ),
              const SizedBox(height: 8),
              AppPasswordInput(
                controller: _passwordController,
                labelText: "Mot de passe",
                width: 284,
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return AppButton(
                    width: 284,
                    title: "Connexion",
                    icon: state is LoginLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
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
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<LoginCubit>().login(
                              _usernameController.text,
                              _passwordController.text,
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
        ),
      ),
    );
  }
}
