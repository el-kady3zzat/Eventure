import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    Text("ABOUT US",
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: kWhite)),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 25.h),
                _illustration(),
                SizedBox(height: 30.h),
                Text(
                  _aboutUsText(),
                  textAlign: TextAlign.justify,
                  //softWrap: false,
                  style: TextStyle(
                    color: kLightGrey,
                    fontSize: 14.sp,
                    // height: 1.6,
                  ),
                ),
                SizedBox(height: 30.h),
                _appName(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _illustration() {
    return Center(
      child: SizedBox(
        width: 230,
        height: 180,
        child: SvgPicture.asset(
          'assets/images/about.svg',
          fit: BoxFit.contain, // Adjust fit
        ),
      ),
    );
  }

  String _aboutUsText() {
    return """Eventure is your ultimate event discovery and management app. 
      Whether you're looking for exciting events, saving your favorites, or booking your next experience, 
      Eventure makes it easy. With calendar-based event filtering, real-time notifications, and a personalized profile,
      we ensure you never miss out on what matters most to you. 
      Seamlessly browse, save, and enjoy events with Eventure – your gateway to unforgettable experiences.""";
  }

  Widget _appName() {
    return Text(
      "Eventure",
      style: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.bold,
        color: kWhite,
        //  fontFamily: "Poppins",
      ),
    );
  }
}
