import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/pages/settings_options/about_us_page.dart';
import 'package:eventure/features/events/presentation/pages/settings_options/change_password_page.dart';
import 'package:eventure/features/events/presentation/pages/settings_options/contact_screen.dart';
import 'package:eventure/features/events/presentation/pages/settings_options/notifications_screen.dart';
import 'package:eventure/features/events/presentation/pages/settings_options/privacy_page.dart';
import 'package:eventure/features/events/presentation/widgets/settings_page/logout_button_widget.dart';
import 'package:eventure/features/events/presentation/widgets/settings_page/settings_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainLight,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text("SETTINGS",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: kWhite)),
            SizedBox(height: 25.h),
            SettingsOption(
                icon: LucideIcons.bell,
                title: "Notification settings",
                fun: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsScreen()));
                }),
            SettingsOption(
                icon: LucideIcons.fileLock,
                title: "Change Password",
                fun: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()));
                }),
            SettingsOption(
                icon: LucideIcons.helpCircle,
                title: "Contact US",
                fun: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsScreen()));
                }),
            SettingsOption(
                icon: LucideIcons.lock,
                title: "Privacy Policy",
                fun: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PrivacyPage()));
                }),
            SettingsOption(
                icon: LucideIcons.info,
                title: "About US",
                fun: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()));
                }),
            Spacer(),
            LogoutButton(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
