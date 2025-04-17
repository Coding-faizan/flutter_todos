import 'package:flutter/material.dart';

import 'logger.dart';

class LoggerNavigatorObserver extends NavigatorObserver {
  /// The [Navigator] pushed `route`.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    println.debug('Route Pushed — ${route.settings.name}');
  }

  /// The [Navigator] popped `route`.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    println.debug('Route Popped — ${route.settings.name}');
  }

  /// The [Navigator] removed `route`.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    println.debug('Route Removed — ${route.settings.name}');
  }

  /// The [Navigator] replaced `oldRoute` with `newRoute`.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    println.debug('Route Replaced — ${newRoute?.settings.name ?? ""}');
  }

  /// The [Navigator]'s routes are being moved by a user gesture.
  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// User gesture is no longer controlling the [Navigator].
  @override
  void didStopUserGesture() {}
}
