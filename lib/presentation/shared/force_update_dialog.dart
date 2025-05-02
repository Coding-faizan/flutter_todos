import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceAppUpdateDialog extends StatelessWidget {
  const ForceAppUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Required'),
      content: const Text(
          'A new version of the app is available. Please update to continue.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (Platform.isIOS) {
              _launchAppleURL();
            } else if (Platform.isAndroid) {
              _launchAndroidURL();
            }
          },
          child: const Text('Update Now'),
        ),
      ],
    );
  }

  static Future<void> _launchAppleURL() async {
    //  Apple Store Link
    // 'https://apps.apple.com/pk/app/example/id1234567890';
    Uri url = Uri(
      scheme: 'https',
      host: 'apps.apple.com',
      path: '/pk/app/example/id1234567890',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> _launchAndroidURL() async {
    //  Google Play Store Link
    // 'https://play.google.com/store/apps/details?id=com.example.xyz';

    Uri url = Uri(
        scheme: 'https',
        host: 'play.google.com',
        path: '/store/apps/details',
        queryParameters: {'id': 'com.example.xyz'});
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
