import 'dart:convert';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedEventCard extends StatelessWidget {
  final String asset;
  final String title;
  final String date;
  final String time;

  const SavedEventCard({
    Key? key,
    required this.asset,
    required this.title,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w, bottom: 38.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        color: kMainLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10.r,
            offset: Offset(0.w, 5.h),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Image.memory(
                      base64Decode(asset),
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 13.h,
                    right: 13.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: const EdgeInsets.all(8).w,
                      child: Icon(Icons.edit_outlined,
                          size: 18.w, color: kMainLight),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: -35.h,
            left: 10.w,
            right: 10.w,
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: kMainLight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: kWhite, size: 12.sp),
                          SizedBox(width: 5.w),
                          Text(date,
                              style: TextStyle(color: kWhite, fontSize: 10.sp)),
                          SizedBox(width: 10.w),
                          Icon(Icons.access_time, color: kWhite, size: 14.w),
                          SizedBox(width: 5),
                          Text(time,
                              style: TextStyle(color: kWhite, fontSize: 10.sp)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kDetails,
                      backgroundColor: kButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    ),
                    onPressed: () {},
                    child: Text("Chat",
                        style: TextStyle(
                            color: kMainLight, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
