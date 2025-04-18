// A primary button with a loading state
// if loading is true, the button will show a loading indicator
// if loading is false, the button will show the text
// default loading is false

import 'package:flutter/material.dart';

import '../../core/size_util.dart';
import 'localized_text.dart';

mixin ButtonLoadingMixin {
  Widget buildLoader(BuildContext context) {
    return SizedBox(
      width: 24.w,
      height: 24.h,
      child: CircularProgressIndicator(
        strokeWidth: 2.w,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

class PrimaryButtonWidget extends StatelessWidget with ButtonLoadingMixin {
  final LocalizedString text;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading ? buildLoader(context) : LocalizedText(text),
    );
  }
}

class TextButtonWidget extends StatelessWidget with ButtonLoadingMixin {
  final LocalizedString text;
  final VoidCallback? onPressed;
  final bool loading;

  const TextButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPressed,
      child: loading ? buildLoader(context) : LocalizedText(text),
    );
  }
}
