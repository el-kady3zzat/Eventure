import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
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
                    Text("PRIVACY POLICY",
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: kWhite)),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                  _privacyPolicyText(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: kLightGrey,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _privacyPolicyText() {
    return "Welcome to Eventure, your go-to app for discovering and managing events effortlessly. "
        "Your privacy is important to us, and this policy explains how we collect, use, and safeguard your data.\n\n"
        "1. **Information We Collect**\n"
        "- Personal details (name, email, phone number) when you sign up.\n"
        "- Events you save, book, or mark as favorites.\n"
        "- Calendar-based event preferences and interactions.\n"
        "- Profile information, including edited data and uploaded images.\n"
        "- Device and usage data to enhance your experience.\n\n"
        "2. **How We Use Your Information**\n"
        "- To personalize your event recommendations.\n"
        "- To enable event booking, saving, and calendar-based filtering.\n"
        "- To send notifications about new and upcoming events.\n"
        "- To improve app functionality based on user engagement.\n\n"
        "3. **Sharing Your Information**\n"
        "- We do not sell your personal data to third parties.\n"
        "- We may share anonymized data with trusted partners to enhance our services.\n\n"
        "4. **Security Measures**\n"
        "- We implement encryption and secure storage to protect your data.\n"
        "- Only authorized personnel have access to sensitive information.\n\n"
        "By using Eventure, you agree to this Privacy Policy. If you have any concerns or questions, please contact our support team.";
  }
}
