import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

typedef LocalizedString = String;

class LocalizedText extends StatelessWidget {
  final LocalizedString text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Map<String, String>? args;

  const LocalizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.args,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(namedArgs: args),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}
