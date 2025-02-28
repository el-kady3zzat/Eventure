import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void init() {
  // Register FirebaseAuth instance ////////////////////////////////////////////
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  /// Data Sources /////////////////////////////////////////////////////////////
  // getIt.registerSingleton<AuthDatasource>(AuthDatasource());
  // getIt.registerSingleton<UserDatasource>(UserDatasource());

  /// Repositories /////////////////////////////////////////////////////////////
  // getIt.registerSingleton<UserRepository>(
  //   UserRepositoryImpl(fsDatasource: getIt<UserDatasource>()),
  // );
  // getIt.registerSingleton<AuthRepository>(
  //   AuthRepositoryImpl(
  //     fbDatasource: getIt<AuthDatasource>(),
  //     userRepository: getIt<UserRepository>(),
  //   ),
  // );

  /// Use Cases ////////////////////////////////////////////////////////////////
  // getIt.registerSingleton(RegisterUser(repository: getIt<AuthRepository>()));
  // getIt.registerSingleton(LoginUser(repository: getIt<AuthRepository>()));
  // getIt.registerSingleton(GetUser(repository: getIt<UserRepository>()));

  /// BLoCs ////////////////////////////////////////////////////////////////////
  // getIt.registerFactory(
  //   () => UserBloc(getUser: getIt<GetUser>()),
  // );
  // getIt.registerFactory(
  //   () => AuthBloc(authRepository: getIt<AuthRepository>()),
  // );
}
