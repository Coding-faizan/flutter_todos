import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart';

import 'core/app.dart';
import 'core/app_bloc_observer.dart';
import 'data/repository/todos_api.dart';
import 'domain/repository/todos_repository.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const AppBlocObserver();
  final TodosApi todosApi = KiwiContainer().resolve<TodosApi>();

  runApp(App(createTodosRepository: () => TodosRepository(todosApi: todosApi)));
}
