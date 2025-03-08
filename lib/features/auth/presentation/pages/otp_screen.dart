import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/bloc/auth_states.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_button.dart';
import 'package:eventure/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui' as ui;

class OTPVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onVerificationComplete;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.onVerificationComplete,
  });

  @override
  Widget build(BuildContext context) {
    return OTPVerificationView(
      initialPhoneNumber: phoneNumber,
      onVerificationComplete: onVerificationComplete,
    );
  }
}

class OTPVerificationView extends StatefulWidget {
  final String initialPhoneNumber;
  final VoidCallback onVerificationComplete;

  const OTPVerificationView({
    super.key,
    required this.initialPhoneNumber,
    required this.onVerificationComplete,
  });

  @override
  State<OTPVerificationView> createState() => _OTPVerificationViewState();
}
class _OTPVerificationViewState extends State<OTPVerificationView> {
  final TextEditingController textEditingController = TextEditingController();
  final StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>.broadcast();
  final FocusNode focusNode = FocusNode();
  bool hasError = false;
  String currentText = "";
  bool _isResendEnabled = false;
  int _resendTimer = 30;
  Timer? _timer;
  bool _isDisposed = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startResendTimer();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();

    // Remove focus before disposing
    focusNode.unfocus();

    // Dispose immediately
    textEditingController.dispose();
    focusNode.dispose();
    errorController.close();

    super.dispose();
  }

  void _startResendTimer() {
    if (_isDisposed) return;

    setState(() {
      _isResendEnabled = false;
      _resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed || !mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  PreferredSizeWidget _buildAppBar(Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: textColor,
          size: SizeConfig.defaultSize! * 2,
        ),
        onPressed: () {
          setState(() {
            _isNavigating = true;
          });
          if (mounted) {
            focusNode.unfocus();
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    SizeConfig().init(context);

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        final backgroundColor = isDarkMode ? kMainDark : Colors.white;
        final textColor = isDarkMode ? Colors.white : kMainLight;
        final subTextColor = isDarkMode ? Colors.white70 : kMainLight;

        return WillPopScope(
          onWillPop: () async {
            setState(() {
              _isNavigating = true;
            });
            return true;
          },
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
              if (_isDisposed || _isNavigating) return false;
              return current is AuthLoading ||
                  current is OTPVerificationSuccess ||
                  current is OTPVerificationError ||
                  current is PhoneNumberVerificationSent ||
                  current is AuthSuccess;
            },
            listener: (context, state) {
              if (_isDisposed || _isNavigating || !mounted) return;



              if (state is PhoneNumberVerificationSent) {
                UI.successSnack(context, state.message.tr());
                _startResendTimer();
              } else if (state is OTPVerificationSuccess) {
                setState(() {
                  _isNavigating = true;
                });
                UI.successSnack(context, state.message.tr());
                if (mounted) {
                  widget.onVerificationComplete();
                }
              } else if (state is AuthSuccess) {
                setState(() {
                  _isNavigating = true;
                });
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                  );
                }
              } else if (state is OTPVerificationError) {
                if (!_isDisposed && mounted) {
                  errorController.add(ErrorAnimationType.shake);
                  setState(() {
                    hasError = true;
                  });
                  UI.errorSnack(context, state.message.tr());
                }
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: backgroundColor,
                resizeToAvoidBottomInset: true,
                appBar: _buildAppBar(textColor),
                body: Stack(
                  children: [
                    _buildMainContent(textColor, subTextColor),
                    if (state is AuthLoading)
                      LoadingOverlay(message: state.message.tr()),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  Widget _buildMainContent(Color textColor, Color subTextColor) {
    final isLandscape = SizeConfig.orientation == Orientation.landscape;

    if (isLandscape) {
      return SafeArea(
        child: Row(
          children: [
            // Left half - Image
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.watch<ThemeCubit>().state ? Colors.white : kMainLight,
                      borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 1.5),
                    ),
                    padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
                    child: SvgPicture.asset(
                      'assets/images/Enter OTP-bro.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // Right half - Content
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.defaultSize! * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'auth.phone_verification'.tr(),
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize! * 2.8,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: SizeConfig.defaultSize! * 0.8),
                    Text(
                      'auth.enter_verification_code'.tr(),
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: SizeConfig.defaultSize! * 1.4,
                      ),
                    ),
                    SizedBox(height: SizeConfig.defaultSize! * 0.8),
                    Text(
                      widget.initialPhoneNumber,
                      style: TextStyle(
                        color: textColor,
                        fontSize: SizeConfig.defaultSize! * 1.6,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: ui.TextDirection.ltr,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: SizeConfig.defaultSize! * 2.4),
                    _buildVerificationUI(textColor, subTextColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Portrait mode
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.defaultSize! * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.defaultSize! * 2),
              Center(
                child: Container(
                  width: SizeConfig.screenWidth! * 0.8,
                  height: SizeConfig.screenHeight! * 0.25,
                  decoration: BoxDecoration(
                    color: context.watch<ThemeCubit>().state ? Colors.white : kMainLight,
                    borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 1.5),
                  ),
                  padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
                  child: SvgPicture.asset(
                    'assets/images/Enter OTP-bro.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 3),
              Text(
                'auth.phone_verification'.tr(),
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 2.8,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 0.8),
              Text(
                'auth.enter_verification_code'.tr(),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: SizeConfig.defaultSize! * 1.4,
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 0.8),
              Text(
                widget.initialPhoneNumber,
                style: TextStyle(
                  color: textColor,
                  fontSize: SizeConfig.defaultSize! * 1.6,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: ui.TextDirection.ltr,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: SizeConfig.defaultSize! * 2.4),
              _buildVerificationUI(textColor, subTextColor),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildVerificationUI(Color textColor, Color subTextColor) {
    return Column(
      children: [
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            focusNode: mounted ? focusNode : null,
            obscureText: false,
            animationType: AnimationType.fade,
            //mainAxisAlignment: MainAxisAlignment.start,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 1.2),
              fieldHeight: SizeConfig.defaultSize! * 4.5,
              fieldWidth: SizeConfig.defaultSize! * 4.5,
              activeFillColor: kHeader,
              inactiveFillColor: Colors.transparent,
              selectedFillColor: Colors.transparent,
              activeColor: kButton,
              inactiveColor: context.watch<ThemeCubit>().state ? Colors.white : kMainDark,
              selectedColor: kButton,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: textEditingController,
            keyboardType: TextInputType.number,
            autoFocus: true,
            boxShadows: const [],
            onCompleted: (v) {
              if (!_isDisposed && !_isNavigating && mounted) {
                _handleVerification();
              }
            },
            onChanged: (value) {
              if (!_isDisposed && !_isNavigating && mounted) {
                setState(() {
                  currentText = value;
                });
              }
            },
            beforeTextPaste: (text) => true,
            textStyle: TextStyle(
              fontSize: SizeConfig.defaultSize! * 2.4,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2.4),
        SizedBox(
          width: double.infinity,
          height: SizeConfig.defaultSize! * 5.6,
          child: CustomButton(
            text: 'auth.verify'.tr(),
            onPressed: (!_isDisposed && !_isNavigating && currentText.length == 6 && mounted)
                ? _handleVerification
                : null,
            fontSize: SizeConfig.defaultSize! * 2,
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2.4),
        Center(
          child: Column(
            children: [
              Text(
                'auth.didnt_receive_code'.tr(),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: SizeConfig.defaultSize! * 1.8,
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 1.2),
              InkWell(
                onTap: (!_isDisposed && !_isNavigating && _isResendEnabled && mounted)
                    ? _handleResend
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.watch<ThemeCubit>().state ? kMainLight : kMainLight,
                    borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 3),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.defaultSize! * 1.2),
                    child: Text(
                      _isResendEnabled
                          ? 'auth.resend_code'.tr()
                          : 'auth.resend_code_timer'.tr(args: [_resendTimer.toString()]),
                      style: TextStyle(
                        color: _isResendEnabled
                            ? kButton
                            : context.watch<ThemeCubit>().state ? Colors.white : kMainDark,
                        fontSize: SizeConfig.defaultSize! * 1.6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleVerification() {
    if (_isDisposed || _isNavigating || !mounted) return;

    if (currentText.length != 6) {
      if (mounted) {
        errorController.add(ErrorAnimationType.shake);
        setState(() {
          hasError = true;
        });
        UI.errorSnack(
          context,
          'auth.enter_valid_code'.tr(),
        );
      }
    } else {
      if (mounted) {
        focusNode.unfocus();
        setState(() {
          hasError = false;
        });
        context.read<AuthBloc>().add(OTPSubmitted(otp: currentText));
      }
    }
  }

  void _handleResend() {
    if (_isDisposed || _isNavigating || !mounted) return;

    if (mounted) {
      context.read<AuthBloc>().add(
        PhoneNumberSubmitted(phoneNumber: widget.initialPhoneNumber.trim()),
      );
    }
  }
}