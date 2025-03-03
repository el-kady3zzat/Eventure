// lib/presentation/auth/screens/login_screen.dart

import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_states.dart';
import 'package:eventure/features/auth/presentation/pages/signup_screen.dart';
import 'package:eventure/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_button.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:eventure/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          CustomSnackBar.showInfo(
            context: context,
            message: state.message,
            duration: const Duration(milliseconds: 1500),
          );
        } else if (state is AuthSuccess ||
            state is GoogleSignInSuccess ||
            state is OTPVerificationSuccess) {
          CustomSnackBar.showSuccess(
            context: context,
            message: state is AuthSuccess
                ? state.message
                : state is GoogleSignInSuccess
                ? state.message
                : (state as OTPVerificationSuccess).message,
            duration: const Duration(milliseconds: 1500),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (state is AuthError ||
            state is GoogleSignInError ||
            state is ResetPasswordError) {
          CustomSnackBar.showError(
            context: context,
            message: state is AuthError
                ? state.message
                : state is GoogleSignInError
                ? state.message
                : (state as ResetPasswordError).message,
            duration: const Duration(milliseconds: 1500),
          );
        } else if (state is ResetPasswordEmailSent) {
          CustomSnackBar.showSuccess(
            context: context,
            message: state.message,
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36.h),
                        Text(
                          'Welcome Back! 😍',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Enter your email and password to log in.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 36.h),
                        _buildLoginForm(),
                        SizedBox(height: 24.h),
                        _buildForgotPassword(),
                        SizedBox(height: 24.h),
                        _buildLoginButton(),
                        SizedBox(height: 24.h),
                        _buildDivider(),
                        SizedBox(height: 24.h),
                        _buildGoogleSignIn(),
                        SizedBox(height: 36.h),
                        _buildSignUpRow(),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading) LoadingOverlay(message: state.message),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        AuthTextField(
          labelText: 'Email',
          hintText: 'Enter your email',
          prefixIcon: Icons.email,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          fieldType: 'email',
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: Icons.lock,
          controller: _passwordController,
          isPassword: true,
          fieldType: 'password',
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _showForgotPasswordDialog,
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: CustomButton(
        text: 'Log In',
        onPressed: _handleLogin,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton.icon(
        icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
        label: Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _handleGoogleSignIn,
      ),
    );
  }

  Widget _buildSignUpRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'Don\'t have an account?',
            style: TextStyle(fontSize: 14.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignUpScreen())),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: isDarkMode ? kMainDark : kMainDark,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } else {
      CustomSnackBar.showError(
        context: context,
        message: 'Please fill all required fields correctly',
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(GoogleSignInRequested());
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            AuthTextField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              fieldType: 'email',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<AuthBloc>().add(
                  ResetPasswordRequested(email: emailController.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}