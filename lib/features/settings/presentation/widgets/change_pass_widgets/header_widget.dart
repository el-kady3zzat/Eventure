 import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kWhite, size: 21.w),
          onPressed: () => Navigator.pop(context),
        ),
        Spacer(),
        Text("CHANGE PASSWORD",
            style: TextStyle(
                fontSize: 17.sp, fontWeight: FontWeight.bold, color: kWhite)),
        Spacer(),
      ],
    );
}