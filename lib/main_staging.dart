import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bootstrap.dart';
import 'data/datasource/local/local_storage_todos_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}
