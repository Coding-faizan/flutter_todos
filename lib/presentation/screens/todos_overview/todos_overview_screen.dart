import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_argument.dart';
import '../../../data/models/todo.dart';
import '../../../domain/repository/todos_repository.dart';
import '../../../l10n/l10n.dart';
import 'package:nested/nested.dart';
import '../../bloc/todos_overview/todos_overview_bloc.dart';
import '../../shared_widgets/todo_list_tile.dart';
import '../../shared_widgets/todos_overview_filter_button.dart';
import '../../shared_widgets/todos_overview_options_button.dart';
import '../edit_todo/edit_todo_screen.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
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
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen:
                (TodosOverviewState previous, TodosOverviewState current) =>
                    previous.status != current.status,
            listener: (BuildContext context, TodosOverviewState state) {
              if (state.status == TodosOverviewStatus.failure) {
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
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
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
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (BuildContext context, TodosOverviewState state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
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
                      context.read<TodosOverviewBloc>().add(
                            TodosOverviewTodoCompletionToggled(
                              todo: todo,
                              isCompleted: isCompleted,
                            ),
                          );
                    },
                    onDismissed: (_) {
                      context
                          .read<TodosOverviewBloc>()
                          .add(TodosOverviewTodoDeleted(todo));
                    },
                    onTap: () {
                      context.push(const TodoDetailScreenRoute().toString(),
                          extra: todo);
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
