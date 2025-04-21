import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/enums.dart';
import '../../domain/repository/auth_repository.dart';
import '../../data/repository/todos_repository_impl.dart';
import '../../presentation/cubit/auth/auth_cubit.dart';
import '../../presentation/cubit/auth/login/login_cubit.dart';
import '../../presentation/cubit/edit_todo/edit_todo_cubit.dart';
import '../../presentation/screens/edit_todo/edit_todo_screen.dart';
import '../../presentation/screens/home/main_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/splash_screen/SplashScreen.dart';
import '../../presentation/screens/stats/stats_screen.dart';
import '../../presentation/screens/todos_overview/todos_overview_screen.dart';
import '../injector.dart';
import '../logger_navigation_observer.dart';
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
    initialLocation: SplashScreenRoute.path,
    observers: <NavigatorObserver>[
      LoggerNavigatorObserver(),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = context.read<AuthCubit>().state;
      final bool isLoginRoute = state.matchedLocation == LoginScreenRoute.path;

      switch (authState) {
        case AuthInitial():
          return SplashScreenRoute.path;
        case AuthAuthenticated():
          final bool isAuthRoute = isLoginRoute;
          if (isAuthRoute) {
            return HomeScreenRoute.path;
          }
          return null;
        case AuthUnauthenticated():
          return LoginScreenRoute.path;
      }
    },
    routes: <RouteBase>[
      /// SplashScreen add later
      GoRoute(
        path: SplashScreenRoute.path,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),

      GoRoute(
        path: LoginScreenRoute.path,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<LoginCubit>(
            create: (BuildContext context) => LoginCubit(
              Injector.resolve<AuthRepository>(),
            ),
            child: const LoginScreen(),
          );
        },
      ),

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
              todosRepository: Injector.resolve<TodosRepositoryImpl>(),
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
              todosRepository: Injector.resolve<TodosRepositoryImpl>(),
              initialTodo: route.todo,
            ),
            child: const EditTodoPage(),
          );
        },
      ),
    ],
  );
}
