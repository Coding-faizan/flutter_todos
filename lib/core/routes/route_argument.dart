abstract class Screen<T extends RouteArg> {
  T get arg;
}

abstract class RouteArg {
  const RouteArg();

  String get parsedPath => uri.toString();
  Uri get uri;
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
  static const String path = '/todo/';

  final String id;

  const TodoDetailScreenRoute({required this.id}) : super();

  @override
  Uri get uri => Uri(path: '$path$id');
}
