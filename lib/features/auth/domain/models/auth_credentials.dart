// lib/domain/auth/models/auth_credentials.dart

class AuthCredentials {
  final String email;
  final String password;

  AuthCredentials({
    required this.email,
    required this.password,
  });
}