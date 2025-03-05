import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    // Clean up the controller when the widget is removed from the widget tree
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive sizes
    final verticalSpacing = screenHeight * 0.01; // 3% of screen height
    final horizontalPadding = screenWidth * 0.04;
    return Scaffold(
      backgroundColor: kMainLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              //vertical: verticalSpacing,
            ),
            child: Form(
              key: _formKey,
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: kWhite,
                    size: 21.w,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Text("CHANGE PASSWORD",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: kWhite)),
                Spacer(),
              ],
            ),
            SizedBox(height: 25.h),
                  _buildTextField(
                      "Enter Current Password", _currentPasswordController,
                      isCurrent: true),
                  SizedBox(height: 15.h),
                  _buildTextField("New Password", _newPasswordController,
                      isNew: true),
                  SizedBox(height: 15.h),
                  _buildTextField("Confirm Password", _confirmPasswordController,
                      isConfirm: true),
                  SizedBox(height: 40.h),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController? controller,
      {bool isCurrent = false, bool isNew = false, bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (isCurrent) {
            return "${hintText.substring(6)} is required";
          } else if (isNew) {
            return "${hintText.substring(0)} is required";
          } else if (isConfirm) {
            return "${hintText.substring(0)} is required";
          }
        }

        if (value!.length < 6) {
          return "Password must be at least 6 characters";
        }

        if (_confirmPasswordController.text != _newPasswordController.text) {
          return "Passwords do not match";
        }

        return null;
      },
      style: TextStyle(color: kWhite),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: kGrey, fontSize: 13.sp, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: kDetails,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
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
        onPressed: () {
          _formKey.currentState!.validate();
        },
        child: Text(
          "SAVE",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: kWhite,
          ),
        ),
      ),
    );
  }
}
