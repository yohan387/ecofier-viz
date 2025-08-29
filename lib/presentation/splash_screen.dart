import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/presentation/authentication/screens/auth_screen.dart';
import 'package:ecofier_viz/presentation/authentication/state/get_local_user/get_local_user_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetLocalUserCubit>().call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetLocalUserCubit, GetLocalUserState>(
      listener: (context, state) {
        if (state is GetLocalUserLoaded) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: state.localUser)),
            (Route<dynamic> route) => false,
          );
        } else if (state is GetLocalUserError) {
          if (state.failure?.statusCode == AppErrorStatusCode.localStorage) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(state.failure?.userMessage ?? "Erreur inattendue.")),
            );
          }
        }
      },
      child: const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
