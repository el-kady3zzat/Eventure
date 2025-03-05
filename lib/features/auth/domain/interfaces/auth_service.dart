


import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';
import 'package:eventure/features/auth/domain/models/auth_credentials.dart';
import 'package:eventure/features/auth/domain/models/sign_up_data.dart';

abstract class IAuthService {
  Future<Result<UserEntity>> signIn(AuthCredentials credentials);
  Future<Result<UserEntity>> signUp(SignUpData signUpData);
  Future<Result<void>> signOut();
  Future<Result<void>> verifyPhoneNumber(String phoneNumber);
  Future<Result<UserEntity>> verifyOTP(String otp);
  Future<Result<UserEntity>> signInWithGoogle();
  Stream<bool> get authStateChanges;
}