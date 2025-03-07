import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// custom resuable widget implements every row in profile
class ProfileItem extends StatelessWidget {
  final String txt;
  final IconData icon;
  final bool? isObscure;
  const ProfileItem({
    super.key,
    required this.txt,
    required this.icon,
    this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      title: Text(
        isObscure == true ? txt : txt.replaceAll(RegExp(r"."), "*"),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      leading: Container(
        padding: EdgeInsets.all(9).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: isDarkMode ? kMainColorDark : kMainColor,
        ),
        child: CircleAvatar(
              backgroundColor: kWhite,
              child: Icon(icon, color: kHeader, size: 20.w),
            ),
         
        
      ),
    );
  }
}