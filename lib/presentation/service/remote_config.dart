import 'dart:developer';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config.dart';
import '../../firebase.dart';
import '../shared/force_update_dialog.dart';
import 'version.dart';

class ForceAppUpdate {
  static String version = 'enforcedVersion';

  static Future<void> enforcedVersion(BuildContext context) async {
    if (kEnvironment.isProd) {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 0),
        ),
      );
      try {
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final _currentVersion = Version.parse(packageInfo.version);
        await remoteConfig.fetchAndActivate();
        final _enforcedVersion = Version.parse(remoteConfig.getString(version));
        if (_enforcedVersion > _currentVersion) {
          if (context.mounted) {
            await _forceAppUpdateDialogBox(context);
          }
          return;
        }
      } catch (exception, stackTrace) {
        log('Error on Remote Config: $exception');
        ReportingService().recordError(exception, stackTrace);
      }
    }
  }

  static Future<void> _forceAppUpdateDialogBox(BuildContext context) async {
    Future<bool> onBackButton() async {
      await SystemNavigator.pop();
      return false;
    }

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => onBackButton(),
          child: const ForceAppUpdateDialog(),
        );
      },
    );
  }
}
