import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButton,
          foregroundColor: kDetails,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        onPressed: () {
          FirebaseService().signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false, // Removes all previous routes from the stack
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.power_settings_new,
              size: 24.w,
              color: kDetails,
            ),
            SizedBox(width: 8.w),
            Text("LOGOUT",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                    color: kDetails)),
          ],
        ),
      ),
    );
  }
}
