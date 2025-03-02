import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/interfaces/biometric_service.dart';
import 'package:eventure/features/auth/domain/interfaces/user_repository.dart';
import 'package:eventure/features/auth/infrastructure/biometric/local_biometric_service.dart';
import 'package:eventure/features/auth/infrastructure/firebase/firebase_auth_service.dart';
import 'package:eventure/features/auth/infrastructure/firebase/firebase_user_repository.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/calendar/calendar_cubit.dart';
import 'package:eventure/features/events/presentation/blocs/nav_bar/nav_bar_cubit.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void init() {
  // Register FirebaseAuth instance ////////////////////////////////////////////
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);


  getIt.registerFactory(() => SplashBloc(
    authService: getIt<IAuthService>(),
    userRepository: getIt<IUserRepository>(),
  ));
  /// Data Sources /////////////////////////////////////////////////////////////
  // getIt.registerSingleton<AuthDatasource>(AuthDatasource());
  // getIt.registerSingleton<UserDatasource>(UserDatasource());
  getIt.registerFactory(() => AuthBloc(
    authService: getIt<IAuthService>(),
    biometricService: getIt<IBiometricService>(),
  ));
  getIt.registerSingleton<IUserRepository>(
    FirebaseUserRepository(),
  );

  // Then register the auth service with the repository
  getIt.registerSingleton<IAuthService>(
    FirebaseAuthService(userRepository: getIt<IUserRepository>()),
  );

  // Register biometric service
  getIt.registerSingleton<IBiometricService>(
    LocalBiometricService(),
  );
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
  getIt.registerFactory(() => NavBarCubit(0));

  getIt.registerFactory(() => CalendarCubit());
}
