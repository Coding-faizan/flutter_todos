import 'package:go_router/go_router.dart';

import '../../data/models/todo.dart';

abstract class Screen<T extends RouteArg> {
  T get arg;
}

abstract class RouteArg {
  const RouteArg();

  String get parsedPath => uri.toString();
  Uri get uri;
}

class SplashScreenRoute extends RouteArg {
  static const String path = '/';

  const SplashScreenRoute() : super();

  @override
  Uri get uri => Uri(path: path);
}

class LoginScreenRoute extends RouteArg {
  static const String path = '/login';

  const LoginScreenRoute() : super();

  @override
  Uri get uri => Uri(path: path);
}

class HomeScreenRoute extends RouteArg {
  static const String path = '/home';

  const HomeScreenRoute() : super();

  @override
  Uri get uri => Uri(path: path);
}

class StatsScreenRoute extends RouteArg {
  static const String path = '/stats';

  const StatsScreenRoute() : super();

  @override
  Uri get uri => Uri(path: path);
}

class NewTodoScreenRoute extends RouteArg {
  static const String path = '/todo/new';

  const NewTodoScreenRoute() : super();

  @override
  Uri get uri => Uri(path: path);
}

class TodoDetailScreenRoute extends RouteArg {
  static const String path = '/todo/edit';

  final Todo todo;

  const TodoDetailScreenRoute({required this.todo}) : super();
  factory TodoDetailScreenRoute.fromState(GoRouterState state) {
    final TodoDetailScreenRoute? route = state.extra as TodoDetailScreenRoute?;
    if (route == null) {
      throw Exception('Todo is null');
    }
    return route;
  }

  @override
  Uri get uri => Uri(path: path);
}
