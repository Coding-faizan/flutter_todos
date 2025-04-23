import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasource/local/local_storage_todos_api.dart';
import '../data/datasource/todos_datasource.dart';
import '../data/repository/repository.dart';
import '../domain/repository/auth_repository.dart';
import '../data/repository/todos_repository_impl.dart';
import '../firebase_options.dart';

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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    container.registerSingleton<SharedPreferences>(
      (KiwiContainer c) => preferences,
    );

    container.registerSingleton(
      (KiwiContainer c) => FirebaseAuth.instance,
    );
    container.registerSingleton(
      (c) => FirebaseFirestore.instance,
    );
    // container.registerSingleton(
    //   (c) => FirebaseStorage.instance,
    // );
  }

  @override
  Future<void> _initialiseDatasource() async {
    final KiwiContainer container = KiwiContainer();

    // container.registerSingleton<TodosRepository>(
    //   (KiwiContainer c) => LocalStorageTodosApi(
    //     plugin: c<SharedPreferences>(),
    //   ),
    // );

    container.registerSingleton<TodosDatasource>(
      (KiwiContainer c) => TodosDatasourceImpl(
        firestore: c<FirebaseFirestore>(),
      ),
    );
  }

  @override
  Future<void> _initialiseRepositories() async {
    final KiwiContainer container = KiwiContainer();

    container.registerSingleton<TodosRepository>(
      (KiwiContainer c) => TodosRepositoryImpl(todosApi: c<TodosDatasource>()),
    );

    container.registerSingleton<AuthRepository>((KiwiContainer c) =>
        AuthRepositoryImpl(firebaseAuth: c<FirebaseAuth>()));
  }
}
