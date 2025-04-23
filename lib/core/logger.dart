import 'dart:convert';

import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/foundation.dart';

Map<LevelMessages, String> _levelEmojis = {
  LevelMessages.debug: '🐛  DEBUG   — ',
  LevelMessages.info: '💡  INFO    — ',
  LevelMessages.warning: '👊🏻  WARNING — ',
  LevelMessages.error: '⛔  ERROR   — ',
};

final EasyLogger _logger = EasyLogger(
  name: 'LS',
  defaultLevel: LevelMessages.debug,
  enableBuildModes: [BuildMode.debug, BuildMode.profile, BuildMode.release],
  enableLevels: [
    LevelMessages.debug,
    LevelMessages.info,
    LevelMessages.error,
    LevelMessages.warning,
  ],
  printer: (object, {level, name, stackTrace}) {
    String stringifyMessage(dynamic message) {
      if (message is Map || message is Iterable) {
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(message);
      } else {
        return message.toString();
      }
    }

    final List<String> buffer = [];
    buffer.add(_levelEmojis[level]! + stringifyMessage(object));
    // if (name != null) buffer.add(name);
    if (stackTrace != null) buffer.add(stackTrace.toString());
    buffer.add('—————————————————————————————————————————————————————————');

    final result = buffer.join('\n');
    if (kDebugMode) {
      print(result);
    }
  },
);

final println = _logger;

// Ideas
// 📕: error message
// 📙: warning message
// 📗: ok status message
// 📘: action message
// 📓: canceled status message
// 📔: Or anything you like and want to recognize immediately by color
