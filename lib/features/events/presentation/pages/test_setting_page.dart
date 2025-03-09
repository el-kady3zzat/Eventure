import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kMainDark : Colors.white;
    final textColor = isDarkMode ? Colors.white : kMainDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'settings.title'.tr(),
          style: TextStyle(color: textColor),
        ),
        actions: [
          // Theme Toggle
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
              UI.infoSnack(
                context,
                'settings.theme_changed'.tr(),
              );
            },
          ),
          // Language Toggle
          IconButton(
            icon: Icon(
              Icons.language,
              color: textColor,
            ),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Settings options can go here
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _showLogoutDialog(context);
                },
                child: Text('settings.logout'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
                UI.successSnack(
                  context,
                  'settings.language_changed'.tr(),
                );
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                context.setLocale(const Locale('ar'));
                Navigator.pop(context);
                UI.successSnack(
                  context,
                  'settings.language_changed'.tr(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.logout'.tr()),
        content: Text('settings.logout_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('settings.cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  UI.errorSnack(
                    context,
                    'settings.logout_failed'.tr(args: [e.toString()]),
                  );
                }
              }
            },
            child: Text(
              'settings.logout'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}