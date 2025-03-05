// lib/application/auth/bloc/auth_states.dart

import 'package:eventure/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String message;

  AuthLoading({required this.message});
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  final String message;
  final bool shouldNavigate;

  AuthSuccess({
    required this.user,
    required this.message,
    this.shouldNavigate = true,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class SignOutSuccess extends AuthState {}

class BiometricAuthSuccess extends AuthState {}

class BiometricAuthError extends AuthState {
  final String message;

  BiometricAuthError(this.message);
}

class ValidationSuccess extends AuthState {}

class ValidationError extends AuthState {
  final String message;

  ValidationError(this.message);
}

// New states
class PhoneNumberVerificationSent extends AuthState {
  final String message;

  PhoneNumberVerificationSent(this.message);
}

class OTPVerificationSuccess extends AuthState {
  final UserEntity user;
  final String message;

  OTPVerificationSuccess({
    required this.user,
    required this.message,
  });
}

class OTPVerificationError extends AuthState {
  final String message;

  OTPVerificationError(this.message);
}

class ResetPasswordEmailSent extends AuthState {
  final String message;

  ResetPasswordEmailSent(this.message);
}

class ResetPasswordError extends AuthState {
  final String message;

  ResetPasswordError(this.message);
}

class GoogleSignInSuccess extends AuthState {
  final UserEntity user;
  final String message;

  GoogleSignInSuccess({
    required this.user,
    required this.message,
  });
}

class GoogleSignInError extends AuthState {
  final String message;

  GoogleSignInError(this.message);
}