import 'package:ecofier_viz/core/dependencies_injection.dart';
import 'package:ecofier_viz/core/theme.dart';
import 'package:ecofier_viz/presentation/authentication/screens/auth_screen.dart';
import 'package:ecofier_viz/presentation/authentication/state/login_cubit/login_cubit.dart';
import 'package:ecofier_viz/presentation/authentication/state/logout_cubit/logout_cubit.dart';
import 'package:ecofier_viz/presentation/authentication/state/register_client/register_client_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<RegisterClientCubit>()),
        BlocProvider(create: (context) => sl<LoginCubit>()),
        BlocProvider(create: (context) => sl<LogoutCubit>()),
        BlocProvider(create: (context) => sl<GetWeighingListCubit>()),
        BlocProvider(create: (context) => sl<GetWeighingSummaryCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthScreen(),
      ),
    );
  }
}
