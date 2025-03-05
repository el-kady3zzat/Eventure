import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function? fun;

  SettingsOption({required this.icon, required this.title, this.fun});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (fun != null) {
          fun!();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        child: Container(
          decoration: BoxDecoration(
            color: kDetails,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: kWhite,
              child: Icon(icon, color: kHeader, size: 20.w),
            ),
            title:
                Text(title, style: TextStyle(color: kWhite, fontSize: 15.sp)),
            trailing: Icon(Icons.arrow_forward_ios, color: kButton, size: 17.w),
          ),
        ),
      ),
    );
  }
}
