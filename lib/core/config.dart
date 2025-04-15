import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String kDefaultFlavor = 'qa';

/// Represents the environment of the app.
enum Environment {
  qa(kDefaultFlavor),
  prod('prod');

  final String value;
  const Environment(this.value);

  factory Environment.from(String value) => Environment.values.firstWhere(
        (Environment e) => e.value == value,
        orElse: () =>
            throw UnimplementedError('Environment $value is not supported'),
      );
}

/// Holds the current environment of the app.
/// This is set by dart define flag `--dart-define=flavor=qa` in the run command.
/// The default value is `qa`.
final Environment kEnvironment = Environment.from(
  const String.fromEnvironment('flavor', defaultValue: kDefaultFlavor),
);

/// Holds the current app config.
/// Returns the correct config based on the current environment.
abstract class AppConfig {
  String get baseUrl;
  Environment get environment;

  /// Factory constructor to create an instance of [AppConfig]
  /// based on the current environment.
  factory AppConfig() {
    return kEnvironment.map(
      staging: () => _StagingAppConfig(),
      prod: () => _ProdAppConfig(),
    );
  }
}

class _StagingAppConfig implements AppConfig {
  @override
  final Environment environment = Environment.qa;
  @override
  final String baseUrl = 'https://api.example.com';
}

class _ProdAppConfig implements AppConfig {
  @override
  final Environment environment = Environment.prod;
  @override
  final String baseUrl = 'https://api.example.com';
}

extension XEnvironment on Environment {
  bool get isProd => this == Environment.prod;
  bool get isStaging => this == Environment.qa;

  void maybeWhen({
    void Function()? prod,
    void Function()? staging,
    void Function()? orElse,
  }) {
    switch (this) {
      case Environment.prod:
        if (prod != null) {
          prod();
        } else {
          orElse?.call();
        }
      case Environment.qa:
        if (staging != null) {
          staging();
        } else {
          orElse?.call();
        }
    }
  }

  /// The [map] method allows mapping different values
  ///  based on the current environment.
  T map<T>({
    required T Function() prod,
    required T Function() staging,
  }) {
    switch (this) {
      case Environment.prod:
        return prod();
      case Environment.qa:
        return staging();
    }
  }
}

extension _XEnvironment on Environment {
  String get verisonSuffix {
    switch (this) {
      case Environment.qa:
        return '-qa';
      case Environment.prod:
        return '';
    }
  }
}

class VersionView extends StatelessWidget {
  final Future<PackageInfo> info;
  final Environment environment;
  final TextStyle? style;

  const VersionView({
    Key? key,
    required this.info,
    required this.environment,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: info,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final packageInfo = snapshot.data!;
        final version = packageInfo.version;
        final buildNumber = packageInfo.buildNumber;
        final versionSuffix = environment.verisonSuffix;
        return Text(
          'v$version$versionSuffix+$buildNumber',
          style: style ?? Theme.of(context).textTheme.bodySmall,
        );
      },
    );
  }
}
