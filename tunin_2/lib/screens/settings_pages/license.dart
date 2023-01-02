import 'package:flutter/material.dart';

class LicenseView {
  license(context) {
    showLicensePage(
        context: context,
        applicationIcon: Image.asset(
          'assets/Tunin.png',
          height: 80,
        ),
        applicationName: 'TUNIN',
        applicationVersion: '1.2.0',
        applicationLegalese: 'Made with love from anzil(Brocamp)');
  }
}
