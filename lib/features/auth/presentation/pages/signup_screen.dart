// lib/presentation/auth/screens/signup_screen.dart

import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_states.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
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

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
            state is OTPVerificationError) {
          CustomSnackBar.showError(
            context: context,
            message: state is AuthError
                ? state.message
                : state is GoogleSignInError
                ? state.message
                : (state as OTPVerificationError).message,
            duration: const Duration(milliseconds: 1500),
          );
        } else if (state is PhoneNumberVerificationSent) {
          CustomSnackBar.showInfo(
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36.h),
                        Text(
                          'Sign up!',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Create your account to get started.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 36.h),
                        _buildSignUpForm(),
                        SizedBox(height: 24.h),
                        _buildSignUpButton(),
                        SizedBox(height: 24.h),
                        _buildDivider(),
                        SizedBox(height: 24.h),
                        _buildSocialSignIn(),
                        SizedBox(height: 36.h),
                        _buildLoginRow(),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading)
                LoadingOverlay(message: state.message),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        AuthTextField(
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: Icons.person,
          controller: _nameController,
          fieldType: 'name',
        ),
        SizedBox(height: 24.h),
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
        SizedBox(height: 24.h),
        AuthTextField(
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          prefixIcon: Icons.lock_outline,
          controller: _confirmPasswordController,
          isPassword: true,
          fieldType: 'confirmPassword',
          passwordController: _passwordController,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          fieldType: 'phone',
          labelText: 'Phone Number (Optional)',
          hintText: 'Enter your phone number',
          prefixIcon: Icons.phone,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: CustomButton(
        text: 'Sign Up',
        onPressed: _handleSignUp,
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

  Widget _buildSocialSignIn() {
    return Column(
      children: [
        _buildGoogleSignInButton(),
        SizedBox(height: 16.h),
        _buildPhoneSignInButton(),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
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

  Widget _buildPhoneSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton.icon(
        icon: Icon(Icons.phone, color: Colors.green),
        label: Text(
          'Continue with Phone',
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
        onPressed: _showPhoneSignInDialog,
      ),
    );
  }

  Widget _buildLoginRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            'Already have an account?',
            style: TextStyle(fontSize: 14.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen())),
          child: Text(
            'Log In',
            style: TextStyle(
              color: isDarkMode ? kMainDark : kMainLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phone: _phoneController.text.trim(),
        ),
      );
    }
  }

  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(GoogleSignInRequested());
  }

  void _showPhoneSignInDialog() {
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    bool isVerifying = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Phone Authentication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isVerifying) ...[
                AuthTextField(
                  controller: phoneController,
                  labelText: 'Phone Number',
                  hintText: '+1234567890',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  fieldType: 'phone',
                ),
              ] else ...[
                AuthTextField(
                  controller: otpController,
                  labelText: 'OTP Code',
                  hintText: '123456',
                  prefixIcon: Icons.lock_clock,
                  keyboardType: TextInputType.number,
                  fieldType: 'otp',
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (!isVerifying) {
                  context.read<AuthBloc>().add(
                    PhoneNumberSubmitted(
                        phoneNumber: phoneController.text),
                  );
                  setState(() => isVerifying = true);
                } else {
                  context.read<AuthBloc>().add(
                    OTPSubmitted(otp: otpController.text),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(isVerifying ? 'Verify' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}