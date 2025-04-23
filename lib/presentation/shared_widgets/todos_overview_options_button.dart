import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/todos_overview/todos_overview_bloc.dart';
import 'localized_text.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodosOverviewCubit bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodosOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: 'todosOverviewOptionsTooltip',
      onSelected: (options) {
        switch (options) {
          case TodosOverviewOption.toggleAll:
            context.read<TodosOverviewCubit>().onToggleAllRequested();
          case TodosOverviewOption.clearCompleted:
            context.read<TodosOverviewCubit>().onClearCompletedRequested();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosOverviewOption.toggleAll,
            enabled: hasTodos,
            child: LocalizedText(
              completedTodosAmount == todos.length
                  ? 'todosOverviewOptionsMarkAllIncomplete'
                  : 'todosOverviewOptionsMarkAllComplete',
            ),
          ),
          PopupMenuItem(
            value: TodosOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: LocalizedText('todosOverviewOptionsClearCompleted'),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
