import 'package:flutter/material.dart';

import '../shared_widgets/localized_text.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: LocalizedText(message),
      ),
    );
  }
}
