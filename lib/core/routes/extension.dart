import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'route_argument.dart';

extension XBuildContext on BuildContext {
  void goToScreen({required RouteArg arg}) {
    go(arg.parsedPath, extra: arg);
  }

  void pushScreen({required RouteArg arg}) {
    push(arg.parsedPath, extra: arg);
  }

  void shouldPop() {
    if (canPop()) {
      pop();
    }
  }

  String get location {
    final GoRouter router = GoRouter.of(this);
    final RouteMatch lastMatch =
        router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
