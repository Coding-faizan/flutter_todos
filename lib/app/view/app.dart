import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/todos_repository.dart';
import '../../l10n/l10n.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../theme/theme.dart';

class App extends StatelessWidget {
  const App({required this.createTodosRepository, super.key});

  final TodosRepository Function() createTodosRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TodosRepository>(
      create: (_) => createTodosRepository(),
      dispose: (repository) => repository.dispose(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTodosTheme.light,
      darkTheme: FlutterTodosTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
