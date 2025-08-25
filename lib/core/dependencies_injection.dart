import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecofier_viz/core/connection_checker.dart';
import 'package:ecofier_viz/presentation/authentication/state/login_cubit/login_cubit.dart';
import 'package:ecofier_viz/presentation/authentication/state/logout_cubit/logout_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initExternalLibraries();
  await _registerAuthDependencies();
  await _registerVisDependencies();
}

Future<void> _registerAuthDependencies() async {
  sl
    ..registerFactory(() => LoginCubit(sl()))
    ..registerFactory(() => LogoutCubit(sl()));
}

Future<void> _registerVisDependencies() async {
  sl
    ..registerFactory(() => GetWeighingListCubit(sl()))
    ..registerFactory(() => GetWeighingSummaryCubit(sl()));
}

Future<void> _initExternalLibraries() async {
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  final weighingBox = await Hive.openBox<String>('weighingBox');

  sl
    ..registerLazySingleton<http.Client>(() => http.Client())
    ..registerFactory(() => Connectivity())
    ..registerFactory<IConnectionChecker>(
        () => ConnectionChecker(sl<Connectivity>()))
    ..registerLazySingleton<Box<String>>(() => weighingBox,
        instanceName: 'weighingBox');
}
