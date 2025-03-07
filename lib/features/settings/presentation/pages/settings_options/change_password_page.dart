import 'package:eventure/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:eventure/features/settings/presentation/blocs/change_pass_bloc/change_password_bloc.dart';
import 'package:eventure/features/settings/presentation/blocs/change_pass_bloc/change_password_event.dart';
import 'package:eventure/features/settings/presentation/blocs/change_pass_bloc/change_password_state.dart';
import 'package:eventure/features/settings/presentation/widgets/change_pass_widgets/header_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eventure/core/utils/theme/colors.dart';
// Import your Bloc file

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    context.read<ChangePasswordBloc>().add(
          ChangePasswordRequested(
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordBloc(),
      child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            CustomSnackBar.showSuccess(
                context: context, message: "Password updated successfully!");

            Navigator.pop(context); // Close the screen on success
          } else if (state is ChangePasswordFailure) {
            CustomSnackBar.showError(context: context, message: state.error);
          }
        },
        child: Scaffold(
          backgroundColor: kMainLight,
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        buildHeader(context),
                        SizedBox(height: 25.h),
                        _buildTextField("Enter Current Password",
                            "Current Password", _currentPasswordController,
                            isCurrent: true),
                        SizedBox(height: 15.h),
                        _buildTextField("New Password", "New Password",
                            _newPasswordController,
                            isNew: true),
                        SizedBox(height: 15.h),
                        _buildTextField("Confirm Password", "Confirm Password",
                            _confirmPasswordController,
                            isConfirm: true),
                        SizedBox(height: 40.h),
                        _buildSaveButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, String txt, TextEditingController controller,
      {bool isCurrent = false, bool isNew = false, bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) return "$txt is required";
        if (value.length < 6) return "Password must be at least 6 characters";
        if (isConfirm &&
            _newPasswordController.text != _confirmPasswordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
      style: TextStyle(color: kWhite),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: kGrey, fontSize: 13.sp),
        filled: true,
        fillColor: kDetails,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 60.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kHeader,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(33.r),
              ),
            ),
            onPressed: state is ChangePasswordLoading
                ? null
                : () => _submitForm(context),
            child: state is ChangePasswordLoading
                ? CircularProgressIndicator(color: kWhite)
                : Text(
                    "SAVE",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: kWhite),
                  ),
          ),
        );
      },
    );
  }

 
  
}
