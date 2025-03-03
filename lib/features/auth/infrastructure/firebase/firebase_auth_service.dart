// lib/infrastructure/auth/firebase/firebase_auth_service.dart

import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';
import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/interfaces/user_repository.dart';
import 'package:eventure/features/auth/domain/models/auth_credentials.dart';
import 'package:eventure/features/auth/domain/models/sign_up_data.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _verificationId;

  factory FirebaseAuthService({required IUserRepository userRepository}) {
    _instance._userRepository = userRepository;
    return _instance;
  }

  final FirebaseAuth _auth;
  late final IUserRepository _userRepository;

  FirebaseAuthService._internal() : _auth = FirebaseAuth.instance;

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  Future<Result<UserEntity>> signIn(AuthCredentials credentials) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: credentials.email.trim(),
        password: credentials.password,
      );

      if (userCredential.user != null) {
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('Authentication failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  @override
  Future<Result<UserEntity>> signUp(SignUpData signUpData) async {
    try {
      // Check if name is taken
      final nameResult = await _userRepository.isNameTaken(signUpData.name);
      if (nameResult.isSuccess && nameResult.data!) {
        return Result.failure('This name is already taken');
      }

      // Check if phone is taken (if provided)
      if (signUpData.phone != null) {
        final phoneResult = await _userRepository.isPhoneTaken(signUpData.phone!);
        if (phoneResult.isSuccess && phoneResult.data!) {
          return Result.failure('This phone number is already registered');
        }
      }

      // Create Firebase auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: signUpData.email.trim(),
        password: signUpData.password,
      );

      if (userCredential.user != null) {
        // Create user in Firestore
        await _userRepository.createUser(signUpData, userCredential.user!.uid);

        // Get created user
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('User creation failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  @override
  Future<Result<void>> verifyPhoneNumber(String phoneNumber) async {
    try {
      final completer = Completer<Result<void>>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          completer.complete(Result.success(null));
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(Result.failure(_mapFirebaseAuthError(e)));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          completer.complete(Result.success(null));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      return await completer.future;
    } catch (e) {
      return Result.failure('Failed to verify phone number');
    }
  }

  @override
  Future<Result<UserEntity>> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        return Result.failure('No verification ID found');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('OTP verification failed');
    } catch (e) {
      return Result.failure('Invalid OTP');
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Result.failure('Google sign in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user exists in Firestore
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);

        if (userResult.isSuccess) {
          if (userResult.data != null) {
            // Existing user
            return Result.success(userResult.data!);
          } else {
            // New user - create profile
            final signUpData = SignUpData.builder()
                .setEmail(userCredential.user!.email!)
                .setName(userCredential.user!.displayName ?? 'User')
                .setPassword('') // Google users don't need password
                .setPhone(userCredential.user!.phoneNumber)
                .build();

            await _userRepository.createUser(signUpData, userCredential.user!.uid);

            // Get created user
            final newUserResult = await _userRepository.getUserById(userCredential.user!.uid);
            if (newUserResult.isSuccess && newUserResult.data != null) {
              return Result.success(newUserResult.data!);
            }
          }
        }
      }
      return Result.failure('Google sign in failed');
    } catch (e) {
      return Result.failure('Failed to sign in with Google');
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to sign out');
    }
  }

  String _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'The password provided is too weak';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'invalid-phone-number':
        return 'Invalid phone number';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}