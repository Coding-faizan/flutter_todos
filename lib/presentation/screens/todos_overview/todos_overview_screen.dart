import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

import '../../../core/injector.dart';
import '../../../core/routes/extension.dart';
import '../../../core/routes/route_argument.dart';
import '../../../data/models/todo.dart';
import '../../../domain/repository/todos_repository.dart';
import '../../../l10n/l10n.dart';

import '../../cubit/todos_overview/todos_overview_bloc.dart';
import '../../shared_widgets/todo_list_tile.dart';
import '../../shared_widgets/todos_overview_filter_button.dart';
import '../../shared_widgets/todos_overview_options_button.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosOverviewCubit>(
      create: (BuildContext context) => TodosOverviewCubit(
        todosRepository: Injector.resolve<TodosRepository>(),
      ),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todosOverviewAppBarTitle),
        actions: const <Widget>[
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: <SingleChildWidget>[
          BlocListener<TodosOverviewCubit, TodosOverviewState>(
            listenWhen:
                (TodosOverviewState previous, TodosOverviewState current) =>
                    previous != current,
            listener: (BuildContext context, TodosOverviewState state) {
              if (state == const TodosOverviewFailure()) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.todosOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewCubit, TodosOverviewState>(
            listenWhen:
                (TodosOverviewState previous, TodosOverviewState current) =>
                    previous.lastDeletedTodo != current.lastDeletedTodo &&
                    current.lastDeletedTodo != null,
            listener: (BuildContext context, TodosOverviewState state) {
              final Todo deletedTodo = state.lastDeletedTodo!;
              final ScaffoldMessengerState messenger =
                  ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.todosOverviewTodoDeletedSnackbarText(
                        deletedTodo.title,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.todosOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewCubit>()
                            .onUndoDeletionRequested();
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewCubit, TodosOverviewState>(
          builder: (BuildContext context, TodosOverviewState state) {
            if (state.todos.isEmpty) {
              if (state == const TodosOverviewLoading()) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state != const TodosOverviewSuccess()) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.todosOverviewEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.filteredTodos.length,
                itemBuilder: (_, int index) {
                  final Todo todo = state.filteredTodos.elementAt(index);
                  return TodoListTile(
                    todo: todo,
                    onToggleCompleted: (bool isCompleted) {
                      context
                          .read<TodosOverviewCubit>()
                          .onTodoCompletionToggled(todo);
                    },
                    onDismissed: (_) {
                      context.read<TodosOverviewCubit>().onTodoDeleted(todo);
                    },
                    onTap: () {
                      context.pushScreen(
                        arg: TodoDetailScreenRoute(todo: todo),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
