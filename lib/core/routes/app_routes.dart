import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/todo.dart';
import '../../domain/repository/todos_repository.dart';
import '../../presentation/cubit/edit_todo/edit_todo_cubit.dart';
import '../../presentation/screens/edit_todo/edit_todo_screen.dart';
import '../../presentation/screens/home/main_screen.dart';
import '../../presentation/screens/stats/stats_screen.dart';
import '../../presentation/screens/todos_overview/todos_overview_screen.dart';
import '../injector.dart';
import 'route_argument.dart';

/// ```txt
/// (App Routes)
/// ├── / <- SplashScreen
/// ├── (shell route)
/// │   ├── /home <- HomeScreen
/// │   └── /stats <- StatsScreen
/// └── (push route)
///    ├── /todo/new <- NewTodoScreen
///    └── /todo/:id <- TodoDetailScreen
///    └── /todo/:id/edit <- EditTodoScreen
/// ```
class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter appRoutes = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: HomeScreenRoute.path,
    routes: <RouteBase>[
      /// SplashScreen add later
      // GoRoute(
      //   path: '/',
      //   builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      // ),

      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: HomeScreenRoute.path,
                builder: (BuildContext context, GoRouterState state) =>
                    const TodosOverviewPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: StatsScreenRoute.path,
                  builder: (BuildContext context, GoRouterState state) =>
                      const StatsPage()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: NewTodoScreenRoute.path,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<EditTodoCubit>(
            create: (BuildContext context) => EditTodoCubit(
              todosRepository: Injector.resolve<TodosRepository>(),
              initialTodo: null,
            ),
            child: const EditTodoPage(),
          );
        },
      ),
      GoRoute(
        path: TodoDetailScreenRoute.path,
        builder: (BuildContext context, GoRouterState state) {
          final TodoDetailScreenRoute route =
              TodoDetailScreenRoute.fromState(state);
          return BlocProvider<EditTodoCubit>(
            create: (BuildContext context) => EditTodoCubit(
              todosRepository: Injector.resolve<TodosRepository>(),
              initialTodo: route.todo,
            ),
            child: const EditTodoPage(),
          );
        },
      ),
    ],
  );
}
