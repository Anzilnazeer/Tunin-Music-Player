import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tunin_2/screens/settings_pages/about_us.dart';
import 'package:tunin_2/screens/settings_pages/license.dart';
import 'package:tunin_2/screens/settings_pages/privacy_policy.dart';
import 'package:tunin_2/screens/settings_pages/reset_app.dart';
import 'package:tunin_2/screens/settings_pages/settings_option.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const space = SizedBox(
    height: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            space,
            OptionWidget(
              infoText: 'About Us',
              infoIcon: Icons.person,
              infoAction: () {
                AboutUs().aboutUs(context);
              },
            ),
            space,
            OptionWidget(
                infoText: 'Reset App',
                infoIcon: Icons.restore,
                infoAction: () {
                  resetApp(context);
                }),
            space,
            OptionWidget(
                infoText: 'Privacy Policy',
                infoIcon: Icons.privacy_tip,
                infoAction: () {
                  Privacy().privacyPolicy(context);
                }),
            space,
            OptionWidget(
                infoText: 'License',
                infoIcon: Icons.info_outline,
                infoAction: () {
                  LicenseView().license(context);
                }),
            space,
            OptionWidget(
                infoText: 'App Settings',
                infoIcon: Icons.app_settings_alt,
                infoAction: () {
                  openAppSettings();
                }),
            space,
            OptionWidget(
              infoText: 'Share',
              infoIcon: Icons.share,
              infoAction: () {},
            ),
          ],
        ),
      ),
    );
  }
}
