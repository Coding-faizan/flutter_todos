import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

final Map<String, Locale> supportedLocales = {
  for (Locale e in const <Locale>[
    Locale('en'),
    Locale('ar'),
  ])
    e.languageCode: e
};

final List<Locale> supportedLocalesList = supportedLocales.values.toList();

class Localization extends StatelessWidget {
  const Localization({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: supportedLocalesList,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: child,
    );
  }
}
