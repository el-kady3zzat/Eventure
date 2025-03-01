import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(
        SizeConfig.size(p: 150.h, l: 120.h),
      );

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    double mainHeight = SizeConfig.size(p: 150.h, l: 120.h);
    double mainRadius = SizeConfig.size(p: 30, l: 20);

    return Card(
      elevation: 10,
      shadowColor: kHeader,
      margin: REdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(mainRadius),
          bottomRight: Radius.circular(mainRadius),
        ),
      ),
      child: AppBar(
        backgroundColor: kMainDark,
        toolbarHeight: mainHeight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(mainRadius),
            bottomRight: Radius.circular(mainRadius),
          ),
        ),
        title: SizedBox(
          height: mainHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: SizeConfig.size(p: 65.h, l: 110.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.place_outlined, color: kHeader, size: 30),
                        Text(
                          ' Egypt',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    if (!SizeConfig.isPortrait())
                      Center(
                        child: Text(
                          'Hello, Qadi Ezzat',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        badges.Badge(
                          badgeContent: Padding(
                            padding: REdgeInsets.all(2.0),
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          position: badges.BadgePosition.topStart(start: 23),
                          badgeStyle: badges.BadgeStyle(
                              badgeColor: kHeader,
                              borderSide:
                                  BorderSide(width: 2, color: kMainDark)),
                          child: Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          height: 65,
                          width: 65,
                          child: CircleAvatar(
                            foregroundImage:
                                AssetImage('assets/images/logo.webp'),
                            child: Icon(Icons.person, size: 40),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              if (SizeConfig.isPortrait())
                SizedBox(
                  child: Text(
                    'Hello,\nQadi Ezzat',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
