import 'package:easy_localization/easy_localization.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasource/local/local_storage_todos_api.dart';
import '../data/repository/todos_api.dart';
import '../domain/repository/todos_repository.dart';

abstract base class Injector {
  // maybe pass config
  static Future<void> initialise() async {
    return _Injector()._initialise();
  }

  static final resolve = KiwiContainer().resolve;
  static final unregister = KiwiContainer().unregister;
  static final clear = KiwiContainer().clear;

  Future<void> _initialise() async {}

  Future<void> _initialiseServices();

  Future<void> _initialiseDatasource();

  Future<void> _initialiseRepositories();
}

final class _Injector extends Injector {
  @override
  Future<void> _initialise() async {
    await _initialiseDatasource();
    await _initialiseRepositories();
    await _initialiseServices();
  }

  @override
  Future<void> _initialiseServices() async {
    final KiwiContainer container = KiwiContainer();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await EasyLocalization.ensureInitialized();

    container.registerSingleton<SharedPreferences>(
      (KiwiContainer c) => preferences,
    );
  }

  @override
  Future<void> _initialiseDatasource() async {
    final KiwiContainer container = KiwiContainer();

    container.registerSingleton<TodosApi>(
      (KiwiContainer c) => LocalStorageTodosApi(plugin: c<SharedPreferences>()),
    );
  }

  @override
  Future<void> _initialiseRepositories() async {
    final KiwiContainer container = KiwiContainer();

    container.registerSingleton<TodosRepository>(
      (KiwiContainer c) => TodosRepository(todosApi: c<TodosApi>()),
    );
  }
}
