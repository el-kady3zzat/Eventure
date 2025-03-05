import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_page_route.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_event.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_state.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashBloc>()..add(CheckLoginStatusEvent()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDark,
      body: SafeArea(
        child: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashNavigationState) {
              Navigator.of(context).pushReplacement(
                CustomPageRoute(
                  child: state.isLoggedIn
                      ? const HomePage()
                      : const LoginScreen(),
                  type: PageTransitionType.slideUp,
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOutCubic,
                ),
              );
            }

            if (state is SplashErrorState) {
              CustomSnackBar.showError(
                context: context,
                message: state.error,
              );
            }
          },
          builder: (context, state) {
            if (state is SplashLoadingState || state is SplashInitialState) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/images/splash_animation.json',
                      height: 300.h,
                      animate: true,
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      'Welcome to Tourist Guide',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Discover amazing places and create unforgettable memories',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 50.h),
                    _buildActionButton(context, state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, SplashState state) {
    if (state is SplashErrorState) {
      return _buildButton(
        onPressed: () {
          context.read<SplashBloc>().add(CheckLoginStatusEvent());
        },
        text: 'Retry',
      );
    }

    return _buildButton(
      onPressed: () {
        context.read<SplashBloc>().add(NavigateToNextScreenEvent());
      },
      text: state is SplashLoggedInState ? 'Continue to Home' : 'Get Started',
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: 50.w,
          vertical: 15.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
